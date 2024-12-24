import 'package:flutter/material.dart';
import 'package:frontend/resources/colors.dart';
import 'package:frontend/resources/fonts.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const PrimaryButton(
      {super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: appColors['primary'],
          minimumSize: const Size.fromHeight(50)),
      child: Text(
        title,
        style: TextStyle(
            color: appColors['white'],
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: appFonts['primary']),
      ),
    );
  }
}
