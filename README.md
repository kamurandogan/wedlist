# wedlist

Çok dilli (11+ dil), çok ülkeli düğün / çeyiz (wish & dowry list) yönetimi, iş birliği, IAP (in‑app purchase) ve Google Mobile Ads desteği olan bir Flutter uygulaması.

## Özellikler

- Firestore tabanlı çok ülkeli item koleksiyonları
- Gerçek zamanlı iş birliği (karşılıklı eşleşen collaborator ilişkisi)
- Çok dillilik (Flutter gen_l10n, 11+ locale)
- Reklamlar: Banner, Interstitial, Rewarded (merkezi servis)
- Satın alma: Reklamsız kullanım ve partner özelliği kilit açma
- Teknolojiler: `firebase_core`, `cloud_firestore`, `google_mobile_ads`, `in_app_purchase`, `go_router`, `bloc/cubit`

## Kurulum ve Çalıştırma

Önkoşullar

- Flutter SDK (stable)
- Android Studio veya Xcode (platforma göre)
- Firebase projeniz yapılandırılmış olmalı (FlutterFire CLI `lib/firebase_options.dart` üretmiş olmalı)

Hızlı başlatma

```powershell
# Bağımlılıkları indir
flutter pub get

# (İsteğe bağlı) l10n üretimi
flutter gen-l10n

# Uygulamayı çalıştır (bağlı cihaza ya da seçili emülatöre)
flutter run
```

### iOS

- macOS üzerinde Xcode gereklidir.
- İlk kurulumda CocoaPods çalışır; sorun olursa aşağıyı deneyin:

```bash
cd ios
pod install
```

### Android

- Geliştirici modu ve USB hata ayıklama açık olmalı.
- Release derlemesi için `android/key.properties` ve keystore (repo dışında) gerekir.

## Ekran Görüntüleri

`assets/images/` içindeki görsellerden bazıları:

| Ana Sayfa | Giriş | Onboarding |
| --- | --- | --- |
| ![home](assets/images/wedlist_logo_512.png) | ![login](assets/images/login.png) | ![onboarding](assets/images/planning.png) |

## Cloud Functions (Opsiyonel)

`functions/` dizininde örnek bir tetikleyici akışı:

- İş birliği (collaborators) çift yönlü senkronizasyonu
- İki tarafın wishlist listesinin birleştirilmesi

Deploy

```bash
cd functions
npm i
npx firebase deploy --only functions
```

---

## Reklam (Google Mobile Ads) Entegrasyonu

Bu projede `google_mobile_ads` paketi kullanılarak merkezi bir `AdsService` ile Banner, Interstitial (geçiş) ve Rewarded (ödüllü) reklamlar yönetilmektedir.

### 1. Eklenen Bağımlılık

`pubspec.yaml` içinde:

```yaml
  google_mobile_ads: ^5.1.0
```

### 2. Android Kurulumu

1. AdMob'da bir uygulama oluştur ve Android App ID al (örn: `ca-app-pub-XXXXXXXX~YYYYYYYY`).
2. `android/app/src/main/AndroidManifest.xml` dosyasında `<application>` etiketinin içine meta-data ekleyin:

```xml
<meta-data
        android:name="com.google.android.gms.ads.APPLICATION_ID"
        android:value="ca-app-pub-3940256099942544~3347511713" /> <!-- TEST ID -->
```

Yayın öncesi TEST ID yerine kendi App ID değerini koymayı unutmayın.

### 3. iOS Kurulumu

1. iOS App ID (AdMob) oluşturun.
2. `ios/Runner/Info.plist` içine ekleyin:

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-3940256099942544~1458002511</string> <!-- TEST ID -->
```

iOS 14+ için (gerekiyorsa) App Tracking Transparency açıklaması ekleyin:

```xml
<key>NSUserTrackingUsageDescription</key>
<string>Bu bilgi, daha alakalı reklamlar gösterebilmemiz için kullanılır.</string>
```

### 4. Servis Mimarisi

`lib/core/services/ads_service.dart`:

- `init()` : SDK başlatma (idempotent)
- `createAnchoredBanner()` : Banner döndürür (Widget içinde `AdWidget` ile kullanılır)
- `showInterstitial()` : Tam ekran geçiş reklamı
- `showRewarded(onReward: ...)` : Ödüllü reklam ve ödül callback’i
- Otomatik preload: İlk init’ten sonra interstitial & rewarded önceden yüklenir

### 5. Kullanım Örnekleri

Banner gösterimi (örneğin bir sayfanın alt kısmında):

```dart
Column(
    children: const [
        Expanded(child: YourContent()),
        BannerAdWidget(),
    ],
)
```

Interstitial tetikleme (örnek bir aksiyon sonrası):

```dart
final shown = await sl<AdsService>().showInterstitial();
if (shown) {
    // Reklam başarıyla gösterildi.
}
```

Rewarded reklam (ödül verme senaryosu):

```dart
final success = await sl<AdsService>().showRewarded(
    onReward: (reward) {
        // reward.amount ve reward.type ile kullanıcıya ödül ver
    },
);
if (success) {
    // Reklam kapandı (kullanıcı izlemiş kabul edilir)
}
```

### 6. Test ID / Production ID

Şu an servis test ID’leri kullanıyor (Google örnekleri). Yayına çıkarken:

- `AdsService` içindeki getter’ları gerçek Ad Unit ID’leriniz ile değiştirin.
- Yayından önce gerçek ID’lerle test için bir süre (24s) bekleyin.

### 7. Önerilen Interstitial Stratejisi

Spam olmaması için:

- Her X kullanıcı aksiyonundan sonra (örn: 5. veya 7. kritik işlemde)
- Sayfa geçişleri arasında (back-to-back değil)
- Kullanıcı odaklı akışları bölmeyecek yerlerde

Basit sayaç yaklaşımı:

```dart
int _actionCount = 0;
Future<void> onUserAction() async {
    _actionCount++;
    if (_actionCount % 5 == 0) {
        await sl<AdsService>().showInterstitial();
    }
}
```

### 8. Rewarded Ödül Tasarımı Önerileri

- Örneğin: ekstra günlük limit, özel tema kilit açma, geçici premium özellik
- İstismarı azaltmak için: Son izlenme zamanını saklayıp minimum aralık koyun

### 9. Yayın Öncesi Kontrol Listesi

- [ ] Test ID’ler prod ID’lerle değiştirildi mi?
- [ ] Manifest / Info.plist App ID doğru mu?
- [ ] İçerik sınıflandırması (çocuk vs. genel) uygun ayarlandı mı?
- [ ] Reklam sıklığı kullanıcı deneyimini bozuyor mu?
- [ ] Rewarded ödülleri kötüye kullanım senaryolarına karşı sınırlandı mı?

---

Her türlü ekleme / iyileştirme için PR veya issue açabilirsiniz.
