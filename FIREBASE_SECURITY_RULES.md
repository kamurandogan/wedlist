# Firebase Firestore Güvenlik Kuralları

## Sorun

Offline kullanıcılar (giriş yapmamış kullanıcılar) Firestore'dan ülkeye özel wishlist itemlerini okuyamıyor.

**Hata:**
```
[cloud_firestore/permission-denied] The caller does not have permission to execute the specified operation.
```

## Çözüm

Firebase Console'da Firestore güvenlik kurallarına offline kullanıcıların `items_*` koleksiyonlarını okuyabilmesi için izin eklenmesi gerekiyor.

## Adımlar

1. Firebase Console'a git: https://console.firebase.google.com
2. Projenizi seçin (wedlist)
3. Sol menüden **Firestore Database** → **Rules** (Kurallar) sekmesine tıklayın
4. Aşağıdaki kuralı ekleyin:

## Güncellenmiş Güvenlik Kuralları

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // ============================================
    // Offline Kullanıcılar için Base Items
    // ============================================
    // Tüm ülkelerin items koleksiyonlarına public read erişimi
    // Örnekler: items_TR, items_EN, items_DE, items_FR, vb.
    match /items_{country}/{itemId} {
      allow read: if true;        // Herkes okuyabilir (offline kullanıcılar dahil)
      allow write: if false;      // Kimse yazamaz (sadece admin console'dan)
    }

    // ============================================
    // Authenticated Users için Kurallar
    // ============================================

    // Kullanıcıların kendi wishlist itemleri
    match /users/{userId}/wishlist/{itemId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Kullanıcıların kendi dowry list itemleri
    match /users/{userId}/items/{itemId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Kullanıcı profilleri
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Bildirimler
    match /users/{userId}/notifications/{notificationId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Partner davetleri
    match /users/{userId}/partners/{partnerId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Önemli Notlar

### `items_{country}` Koleksiyonları için

- **Read erişimi**: `allow read: if true;` - Herkes (offline kullanıcılar dahil) okuyabilir
- **Write erişimi**: `allow write: if false;` - Kimse yazamaz, sadece Firebase Console'dan admin tarafından yönetilir
- Bu koleksiyonlar:
  - `items_TR` - Türkiye
  - `items_EN` - İngiltere/ABD
  - `items_DE` - Almanya
  - `items_FR` - Fransa
  - `items_ES` - İspanya
  - `items_IT` - İtalya
  - vb.

### Neden Bu Gerekli?

1. **Offline-First Yaklaşım**: Uygulama ilk açıldığında kullanıcı giriş yapmamış olabilir
2. **Ülkeye Özel Veriler**: Her ülke için önceden tanımlanmış wishlist itemleri var
3. **Read-Only Data**: Bu veriler sadece okunacak, değiştirilmeyecek (template/base data)

## Test Etme

Kuralları yayınladıktan sonra:

1. Uygulamayı tamamen kapatın
2. Uygulama verilerini temizleyin (Settings → Apps → Wedlist → Clear Data)
3. Uygulamayı yeniden açın
4. Giriş yapmadan wishlist sayfasına gidin
5. Ülkenize özel wishlist itemlerini görebilmelisiniz

## Beklenen Log Çıktısı

Başarılı olduğunda şu logları göreceksiniz:

```
💡 Fetching base items from Firestore: items_TR
💡 Fetched 50 base items from items_TR
💡 Cached 50 items to Hive
💡 WishlistRepo STREAM: Yielding 50 items
```

## Güvenlik Endişeleri

**Soru**: Public read erişimi güvenli mi?

**Cevap**: Evet, çünkü:
- Bu veriler zaten herkese açık olması gereken template/base veriler
- Kullanıcılar bu verileri değiştiremez (write: false)
- Kullanıcıların kendi özel verileri (`users/{userId}/*`) hala korunuyor
- Sadece önceden tanımlanmış kategoriler ve itemler okunabiliyor

## Alternatif Çözümler

Eğer public read erişimi vermek istemiyorsanız:

1. **Cloud Functions**: Bir Cloud Function oluşturup admin olarak veri çekin
2. **REST API**: Custom bir backend API oluşturun
3. **Static JSON**: items_*.json dosyalarını app bundle'a dahil edin

Ancak en basit ve etkili çözüm yukarıdaki güvenlik kuralıdır.
