import 'package:flutter/material.dart';
import 'package:wedlist/feature/on_boarding/domain/entities/onboarding_entity.dart';

// Onboarding ekranında gösterilecek kart widget'ı
class OnboardingCard extends StatelessWidget {
  const OnboardingCard({required this.data, super.key});
  // Kartta gösterilecek veri modeli
  final OnboardingEntity data;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Kartın üst kısmında ikon
        Center(child: Image.asset(data.imagePath, height: size.height * .4)),
        const SizedBox(height: 30),
        // Başlık metni
        SizedBox(
          width: size.width * 0.7,
          child: Text(
            data.title,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 20),
        // Açıklama metni
        Text(
          data.body,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}
