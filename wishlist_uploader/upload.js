const admin = require("firebase-admin");
const fs = require("fs");
const yargs = require("yargs");

// Servis hesabını başlat
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// yargs ile terminalden veri al (argv tanımı en başta olmalı)
const argv = yargs
  .option('json', { alias: 'j', description: 'Yüklenecek JSON dosyasının yolu', type: 'string', default: 'wishlist.json' })
  .option('doc', { alias: 'd', description: 'Firestore koleksiyon doküman id', type: 'string', default: 'preset_1' })
  .option('country', { alias: 'c', description: 'Hedef ülke ISO kodu (ör. TR, US, UK)', type: 'string' })
  .option('collection', { alias: 'C', description: 'Koleksiyon adı override', type: 'string' })
  .option('listVersion', { alias: 'v', description: 'Liste versiyonu', type: 'number', default: 1 })
  .option('dry', { description: 'Kuru çalıştırma (yazmadan)', type: 'boolean', default: false })
  .option('audit', { description: 'Audit mod', type: 'boolean', default: false })
  .option('countries', { description: 'Virgülle ayrılmış ülke kodları', type: 'string' })
  .option('auditJson', { description: 'Audit JSON rapor yolu', type: 'string' })
  .option('expectedCategories', { description: 'Beklenen kategoriKey liste override', type: 'string' })
  .option('allowDuplicateInJson', { description: 'JSON içi duplicate id + kategoriye izin ver', type: 'boolean', default: false })
  .option('cleanupDuplicates', { description: 'Koleksiyonda duplicate suffix taraması', type: 'boolean', default: false })
  .option('execute', { description: 'Cleanup sırasında gerçek silme', type: 'boolean', default: false })
  .option('cleanupMode', { description: 'baseKeeps | latestKeeps', type: 'string', default: 'baseKeeps' })
  .help()
  .argv;

// Duplicate cleanup tek koleksiyon
async function runCleanupDuplicatesSingle(collectionName, opts) {
  const mode = opts.mode;
  console.log(`\n[Cleanup] Koleksiyon: ${collectionName}`);
  const snap = await db.collection(collectionName).get();
  // Önce tüm doc snapshotlarını id -> snap map'ine al
  const allDocs = new Map();
  snap.forEach(d => allDocs.set(d.id, d));
  const groups = new Map(); // baseId => { base: snap, suffixes: [ {snap, suffixNum} ] }
  const suffixRegex = /^(.*)_([0-9]+)$/;
  // İlk geçiş: potansiyel base doc'ları ekle
  allDocs.forEach((doc, id) => {
    // Eğer id'nin sonundaki sayı segmenti çıkarıldığında kalan id mevcut bir doc ise BU doc suffix olabilir; base değil.
    const m = id.match(suffixRegex);
    if (m) {
      const possibleBase = m[1];
      if (allDocs.has(possibleBase)) {
        // Bu doc suffix olacak, base eklenmesi ikinci geçişte yapılır
        return;
      }
    }
    if (!groups.has(id)) groups.set(id, { base: doc, suffixes: [] });
  });
  // İkinci geçiş: suffix dokümanları base gruplarına ekle
  allDocs.forEach((doc, id) => {
    const m = id.match(suffixRegex);
    if (!m) return;
    const baseCandidate = m[1];
    if (!allDocs.has(baseCandidate)) return; // Gerçek base yoksa zincir suffix (şimdilik es geç)
    if (!groups.has(baseCandidate)) groups.set(baseCandidate, { base: allDocs.get(baseCandidate), suffixes: [] });
    const suffixNum = parseInt(m[2], 10);
    groups.get(baseCandidate).suffixes.push({ snap: doc, suffixNum });
  });
  const deletePlanned = [];
  groups.forEach(val => {
    if (!val.suffixes.length) return;
    if (mode === 'baseKeeps') {
      if (val.base) deletePlanned.push(...val.suffixes.map(s => s.snap));
    } else if (mode === 'latestKeeps') {
      const max = val.suffixes.reduce((a, b) => b.suffixNum > a.suffixNum ? b : a, val.suffixes[0]);
      if (val.base) deletePlanned.push(val.base);
      for (const s of val.suffixes) if (s !== max) deletePlanned.push(s.snap);
    }
  });
  console.log(`  Gruplar: ${groups.size}`);
  console.log(`  Silinmesi planlanan: ${deletePlanned.length}`);
  if (!deletePlanned.length) return { deleted: 0, planned: 0 };
  if (!opts.execute) {
    console.log('  (Rapor modu) İlk 10 örnek:');
    deletePlanned.slice(0, 10).forEach(d => console.log('   * ' + d.id));
    return { deleted: 0, planned: deletePlanned.length };
  }
  let delCount = 0;
  for (const d of deletePlanned) {
    // eslint-disable-next-line no-await-in-loop
    await db.collection(collectionName).doc(d.id).delete();
    delCount++;
    if (delCount <= 10) console.log('  Deleted: ' + d.id);
  }
  console.log(`  ✅ Silindi: ${delCount}`);
  return { deleted: delCount, planned: deletePlanned.length };
}

async function runCleanupDuplicatesAll() {
  const mode = argv.cleanupMode;
  if (!['baseKeeps', 'latestKeeps'].includes(mode)) {
    console.error('Geçersiz cleanupMode. baseKeeps veya latestKeeps kullanın.');
    process.exit(1);
  }
  // Tek koleksiyon belirtilmişse
  if (argv.collection || argv.country) {
    const country = (argv.country || '').toString().toUpperCase() || undefined;
    const collectionName = argv.collection || (country ? `items_${country}` : 'items');
    await runCleanupDuplicatesSingle(collectionName, { mode, execute: argv.execute });
    return;
  }
  // Aksi halde dosya adlarından ülkeleri bul ve hepsi için çalıştır
  const countries = parseCountryCodes();
  if (!countries.length) {
    console.log('Ülke bulunamadı (wishlist_items_*.json dosyaları yok).');
    return;
  }
  console.log(`Toplam ülke: ${countries.length}`);
  let totalPlanned = 0; let totalDeleted = 0;
  for (const code of countries) {
    const col = `items_${code}`;
    // eslint-disable-next-line no-await-in-loop
    const res = await runCleanupDuplicatesSingle(col, { mode, execute: argv.execute });
    if (res) { totalPlanned += res.planned; totalDeleted += res.deleted; }
  }
  console.log('\n=== ÖZET ===');
  console.log(`Planlanan toplam silme: ${totalPlanned}`);
  if (argv.execute) console.log(`Gerçekleşen silme: ${totalDeleted}`);
  else console.log('Silme yapılmadı (rapor modu). --execute ekleyin.');
}

if (argv.cleanupDuplicates) {
  runCleanupDuplicatesAll().then(() => process.exit(0)).catch(e => { console.error(e); process.exit(1); });
  return;
}

// Varsayılan kategori anahtarları
const DEFAULT_EXPECTED_CATEGORIES = ['kitchen', 'bedroom', 'living_room', 'bathroom', 'electronic_goods', 'hall', 'other_home_needs'];

function median(values) {
  if (!values.length) return 0;
  const sorted = [...values].sort((a, b) => a - b);
  const mid = Math.floor(sorted.length / 2);
  return sorted.length % 2 ? sorted[mid] : (sorted[mid - 1] + sorted[mid]) / 2;
}

function parseCountryCodes() {
  if (argv.countries) {
    return argv.countries.split(',').map(s => s.trim().toUpperCase()).filter(Boolean);
  }
  if (argv.country) return [argv.country.toUpperCase()];
  // Heuristik: wishlist_uploader klasöründe wishlist_items_*.json tara
  const dirFiles = fs.readdirSync(__dirname).filter(f => f.startsWith('wishlist_items_') && f.endsWith('.json'));
  return dirFiles.map(f => {
    const m = f.match(/wishlist_items_(.*)\.json$/);
    return m ? m[1].toUpperCase() : null;
  }).filter(Boolean);
}

function loadItemsFromJson(path) {
  try {
    const raw = fs.readFileSync(path, 'utf8');
    return JSON.parse(raw);
  } catch (e) {
    return { __error: e.message };
  }
}

async function runAudit() {
  const expected = argv.expectedCategories ? argv.expectedCategories.split(',').map(s => s.trim()).filter(Boolean) : DEFAULT_EXPECTED_CATEGORIES;
  const countries = parseCountryCodes();
  if (!countries.length) {
    console.log('⚠ Denetlenecek ülke bulunamadı (countries/country parametresi ya da dosya eşleşmesi yok).');
    return;
  }
  const report = { generatedAt: new Date().toISOString(), expectedCategories: expected, countries: {}, stats: {}, warnings: [] };
  for (const code of countries) {
    const file = `wishlist_items_${code.toLowerCase()}.json`;
    const fullPath = `${__dirname}/${file}`;
    const data = loadItemsFromJson(fullPath);
    if (data.__error) {
      report.countries[code] = { error: data.__error };
      report.warnings.push(`FILE_MISSING:${code}:${data.__error}`);
      continue;
    }
    const counts = Object.fromEntries(expected.map(k => [k, 0]));
    const duplicates = new Set();
    const idSet = new Set();
    let total = 0;
    const invalidCategory = [];
    for (const it of data) {
      total++;
      const catKey = (it.categoryKey || it.category || '').trim();
      if (!catKey) {
        report.warnings.push(`EMPTY_CATEGORY_KEY:${code}:${JSON.stringify(it)}`);
        continue;
      }
      if (!(catKey in counts)) {
        // Yabancı kategori - yine kaydet, counts içine ekle
        counts[catKey] = (counts[catKey] || 0) + 1;
        invalidCategory.push(catKey);
      } else {
        counts[catKey]++;
      }
      const composite = `${catKey}::${it.id}`;
      if (idSet.has(composite)) {
        duplicates.add(composite);
      } else {
        idSet.add(composite);
      }
    }
    const missing = expected.filter(k => (counts[k] || 0) === 0);
    report.countries[code] = { total, counts, missing, duplicates: [...duplicates], extraCategories: [...new Set(invalidCategory)] };
    if (missing.length) report.warnings.push(`MISSING:${code}:${missing.join(',')}`);
    if (duplicates.size) report.warnings.push(`DUPLICATES:${code}:${[...duplicates].join('|')}`);
  }
  // Global istatistik (sadece expected kategoriler)
  const perCategoryValues = {};
  for (const cat of report.expectedCategories) perCategoryValues[cat] = [];
  for (const code of Object.keys(report.countries)) {
    const c = report.countries[code];
    if (c.error) continue;
    for (const cat of Object.keys(c.counts)) {
      if (!perCategoryValues[cat]) perCategoryValues[cat] = [];
      perCategoryValues[cat].push(c.counts[cat]);
    }
  }
  for (const cat of Object.keys(perCategoryValues)) {
    const arr = perCategoryValues[cat];
    if (!arr.length) continue;
    const min = Math.min(...arr);
    const max = Math.max(...arr);
    const avg = arr.reduce((a, b) => a + b, 0) / arr.length;
    const med = median(arr);
    report.stats[cat] = { min, max, avg: Number(avg.toFixed(2)), median: med, values: arr };
  }
  // Threshold uyarıları (heuristic)
  for (const cat of Object.keys(report.stats)) {
    const { median: med } = report.stats[cat];
    const lowThreshold = med * 0.6;
    const highThreshold = med * 1.5;
    for (const code of Object.keys(report.countries)) {
      const c = report.countries[code];
      if (c.error) continue;
      const val = c.counts[cat];
      if (val < lowThreshold) report.warnings.push(`LOW:${code}:${cat}:${val}<${lowThreshold.toFixed(1)}`);
      else if (val > highThreshold) report.warnings.push(`HIGH:${code}:${cat}:${val}>${highThreshold.toFixed(1)}`);
    }
  }
  // Yazdırma
  console.log('=== AUDIT REPORT ===');
  const countryCodes = Object.keys(report.countries);
  for (const code of countryCodes) {
    const c = report.countries[code];
    if (c.error) {
      console.log(`${code}: ERROR ${c.error}`);
      continue;
    }
    const parts = Object.keys(c.counts).map(k => `${k}=${c.counts[k]}`);
    console.log(`${code}: total=${c.total} ${parts.join(' ')}`);
    if (c.missing.length) console.log(`  -> missing: ${c.missing.join(', ')}`);
    if (c.extraCategories.length) console.log(`  -> extra categories: ${c.extraCategories.join(', ')}`);
    if (c.duplicates.length) console.log(`  -> duplicates: ${c.duplicates.join(', ')}`);
  }
  console.log('\nCategory stats:');
  for (const cat of Object.keys(report.stats)) {
    const s = report.stats[cat];
    console.log(`${cat.padEnd(16)} min=${s.min} max=${s.max} median=${s.median} avg=${s.avg}`);
  }
  if (report.warnings.length) {
    console.log('\nWarnings:');
    for (const w of report.warnings) console.log(' - ' + w);
  } else {
    console.log('\nNo warnings.');
  }
  if (argv.auditJson) {
    try {
      fs.writeFileSync(argv.auditJson, JSON.stringify(report, null, 2));
      console.log(`\nJSON report written to ${argv.auditJson}`);
    } catch (e) {
      console.log('JSON report write error:', e.message);
    }
  }
}

// Eğer audit modu seçilmişse yükleme yerine audit çalıştır ve çık
if (argv.audit) {
  runAudit().then(() => process.exit(0)).catch(e => { console.error(e); process.exit(1); });
  return; // upload akışına girme
}

// Duplicate cleanup modu
async function runCleanupDuplicates() {
  const country = (argv.country || '').toString().toUpperCase() || undefined;
  const collectionName = argv.collection || (country ? `items_${country}` : 'items');
  console.log(`Duplicate cleanup target: ${collectionName}`);
  const mode = argv.cleanupMode;
  if (!['baseKeeps', 'latestKeeps'].includes(mode)) {
    console.error('Geçersiz cleanupMode. baseKeeps veya latestKeeps kullanın.');
    process.exit(1);
  }
  // Tüm dokümanları çek (koleksiyon büyükse maliyetli!)
  const snap = await db.collection(collectionName).get();
  const groups = new Map(); // baseId => { base: docSnapshot|null, suffixes: [ {snap, suffixNum} ] }
  const suffixRegex = /^(.*)_([0-9]+)$/;
  snap.forEach(doc => {
    const id = doc.id;
    const m = id.match(suffixRegex);
    if (m) {
      const base = m[1];
      const num = parseInt(m[2], 10);
      if (!groups.has(base)) groups.set(base, { base: null, suffixes: [] });
      groups.get(base).suffixes.push({ snap: doc, suffixNum: num });
    } else {
      if (!groups.has(id)) groups.set(id, { base: doc, suffixes: [] }); else groups.get(id).base = doc;
    }
  });
  let deletePlanned = [];
  groups.forEach((val, baseId) => {
    if (!val.suffixes.length) return; // Tek kopya yok
    // Hem base hem suffix(ler) var ise veya sadece suffix(ler) varsa
    if (mode === 'baseKeeps') {
      // Eğer base mevcutsa tüm suffixler silinir
      if (val.base) {
        deletePlanned.push(...val.suffixes.map(s => s.snap));
      } else {
        // base yoksa en küçük suffix kalabilir, diğerleri silinsin (opsiyon)
        // Şimdilik hiçbir şey yapma; ileride eklenebilir.
      }
    } else if (mode === 'latestKeeps') {
      // En büyük suffix kalır, diğer suffixler + base (varsa) silinir
      const max = val.suffixes.reduce((a, b) => b.suffixNum > a.suffixNum ? b : a, val.suffixes[0]);
      // base varsa o da silinecek (çünkü latest kalmalı)
      if (val.base) deletePlanned.push(val.base);
      for (const s of val.suffixes) if (s !== max) deletePlanned.push(s.snap);
    }
  });
  console.log(`Taranan grup sayısı: ${groups.size}`);
  console.log(`Silinmesi planlanan doküman sayısı: ${deletePlanned.length}`);
  if (!deletePlanned.length) {
    console.log('Silinecek duplicate yok.');
    return;
  }
  if (!argv.execute) {
    console.log('Dry (rapor) modu: --execute eklemeden silme yapılmaz. Örnek ilk 10:');
    deletePlanned.slice(0, 10).forEach(d => console.log('  * ' + d.id));
    return;
  }
  let delCount = 0;
  for (const d of deletePlanned) {
    // eslint-disable-next-line no-await-in-loop
    await db.collection(collectionName).doc(d.id).delete();
    delCount++;
    if (delCount <= 10) console.log('Deleted: ' + d.id);
  }
  console.log(`✅ Toplam ${delCount} doküman silindi.`);
}

if (argv.cleanupDuplicates) {
  runCleanupDuplicates().then(() => process.exit(0)).catch(e => { console.error(e); process.exit(1); });
  return;
}

// JSON'u oku (upload modu)
const rawData = fs.readFileSync(argv.json);
const items = JSON.parse(rawData);

// Yükleme öncesi JSON içi duplicate kontrolü
function validateNoDuplicates(list) {
  if (argv.allowDuplicateInJson) return;
  const seen = new Map(); // key => first index
  const dupErrors = [];
  list.forEach((it, idx) => {
    const catKey = (it.categoryKey || it.category || '').trim();
    const id = (it.id || '').toString().trim();
    if (!id) {
      dupErrors.push(`INDEX ${idx}: Boş id`);
      return;
    }
    const key = `${catKey}::${id}`;
    if (seen.has(key)) {
      dupErrors.push(`INDEX ${idx}: Duplicate (ilk index=${seen.get(key)}) key=${key}`);
    } else {
      seen.set(key, idx);
    }
  });
  if (dupErrors.length) {
    console.error('❌ JSON duplicate kontrolü başarısız:');
    dupErrors.forEach(e => console.error(' - ' + e));
    console.error('\nÇözüm: id veya categoryKey değiştirin ya da --allowDuplicateInJson ile zorlayın.');
    process.exit(2);
  }
}

validateNoDuplicates(items);

// Kategori slug iyileştirme: Türkçe karakterleri ASCII'ye çevir, / ve benzeri işaretleri alt çizgi yap
function slugifyCategory(cat) {
  if (!cat) return 'unknown';
  const map = {
    'ç': 'c', 'Ç': 'c',
    'ğ': 'g', 'Ğ': 'g',
    'ı': 'i', 'İ': 'i',
    'ö': 'o', 'Ö': 'o',
    'ş': 's', 'Ş': 's',
    'ü': 'u', 'Ü': 'u'
  };
  let s = cat.replace(/[çÇğĞıİöÖşŞüÜ]/g, ch => map[ch] || ch);
  s = s.replace(/[\/]/g, ' '); // slashları boşluk kabul et
  s = s.replace(/&/g, ' ve ');
  s = s.normalize('NFKD').replace(/[^\w\s-]+/g, '');
  s = s.trim().replace(/\s+/g, '_').toLowerCase();
  // Çoklu alt çizgileri tekilleştir
  s = s.replace(/_+/g, '_');
  return s || 'unknown';
}

// Her item'ı 'items' koleksiyonuna ayrı doküman olarak yükle
async function uploadItems() {
  const dryRun = argv.dry === true; // --dry parametresi varsa sadece ön izleme
  const country = (argv.country || '').toString().toUpperCase() || undefined;
  const collectionName = argv.collection || (country ? `items_${country}` : 'items');
  console.log(`Target collection: ${collectionName}${country ? ` (country=${country})` : ''}`);
  let count = 0;
  for (const item of items) {
    const rawCategory = item.categoryKey || item.category;
    const slug = slugifyCategory(rawCategory);
    const baseId = `${slug}_${item.id}`;
    let docId = baseId;
    // Çakışma durumunda sonuna artan sayaç ekle
    let i = 1;
    while (!dryRun) {
      // eslint-disable-next-line no-await-in-loop
      const exists = await db.collection(collectionName).doc(docId).get();
      if (!exists.exists) break;
      docId = `${baseId}_${i++}`;
    }
    if (dryRun) {
      console.log(`[DRY] ${baseId} => title:"${item.title}" category:"${item.category}"`);
      continue;
    }
    // eslint-disable-next-line no-await-in-loop
    await db.collection(collectionName).doc(docId).set({
      id: docId,
      title: item.title,
      category: item.category,
      categorySlug: slug,
      country: country || 'GLOBAL',
      listVersion: argv.listVersion
    });
    count++;
    console.log(`Uploaded: ${docId}`);
  }
  if (dryRun) {
    console.log('✅ Dry run tamamlandı. (Gerçek yükleme için --dry kaldır)');
  } else {
    console.log(`🎉 Toplam ${count} item Firestore'a yüklendi!`);
  }
}

uploadItems().catch(console.error);
