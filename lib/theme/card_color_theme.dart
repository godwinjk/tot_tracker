import 'package:flutter/material.dart';

@immutable
class CardColorTheme extends ThemeExtension<CardColorTheme> {
  final List<Color> cardColors;

  const CardColorTheme({required this.cardColors});

  @override
  CardColorTheme copyWith({List<Color>? cardColors}) {
    return CardColorTheme(cardColors: cardColors ?? this.cardColors);
  }

  @override
  CardColorTheme lerp(CardColorTheme? other, double t) {
    if (other is! CardColorTheme) return this;
    return CardColorTheme(
      cardColors: List<Color>.generate(
        cardColors.length,
            (index) => Color.lerp(cardColors[index], other.cardColors[index], t)!,
      ),
    );
  }
}