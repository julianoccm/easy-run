import 'package:flutter/material.dart';
import 'package:frontend/resources/colors.dart';
import 'package:frontend/resources/fonts.dart';

class PrimaryTitle extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final TextAlign? textAlign;

  const PrimaryTitle(
      {super.key, required this.title, this.style, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        textAlign: textAlign,
        style: TextStyle(
          color: appColors['white'],
          fontSize: 25,
          fontWeight: FontWeight.bold,
          fontFamily: appFonts['primary'],
        ).merge(style ?? const TextStyle()));
  }
}
