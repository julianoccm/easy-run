import 'package:flutter/material.dart';
import 'package:frontend/resources/colors.dart';
import 'package:frontend/resources/fonts.dart';

class PrimaryTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final bool? isPassword;
  final bool? isNumber;

  const PrimaryTextInput(
      {super.key,
      required this.controller,
      required this.placeholder,
      this.isPassword,
      this.isNumber});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword == true ? true : false,
      enableSuggestions: isPassword == true ? false : true,
      keyboardType: isNumber == true
          ? const TextInputType.numberWithOptions(decimal: false)
          : TextInputType.text,
      autocorrect: false,
      style: TextStyle(
          color: appColors['white'],
          fontSize: 15,
          fontFamily: appFonts['primary']),
      decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: TextStyle(
              color: appColors['white'],
              fontSize: 15,
              fontFamily: appFonts['secondary']),
          filled: true,
          fillColor: appColors['secondaryDark'],
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: appColors['primary']!),
              borderRadius: const BorderRadius.all(Radius.circular(6))),
          border: const OutlineInputBorder(
              borderSide: BorderSide(width: 0),
              borderRadius: BorderRadius.all(Radius.circular(6)))),
    );
  }
}
