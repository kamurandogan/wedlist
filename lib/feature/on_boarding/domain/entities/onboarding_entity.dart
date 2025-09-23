// Onboarding ekranında kullanılacak veri modeli

/// Onboarding ekranında her bir kart için başlık, açıklama ve ikon tutan model
class OnboardingEntity {
  /// OnboardingData kurucu metodu
  const OnboardingEntity({
    required this.title,
    required this.body,
    required this.imagePath,
  });

  /// Kart başlığı
  final String title;

  /// Kart açıklama metni
  final String body;

  /// Kartta gösterilecek ikon
  final String imagePath;
}
