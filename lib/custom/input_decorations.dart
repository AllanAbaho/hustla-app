import 'package:hustla/custom/resources.dart';
import 'package:flutter/material.dart';
import 'package:hustla/my_theme.dart';

class InputDecorations {
  static InputDecoration buildInputDecoration_1({hint_text = "", suffix}) {
    return InputDecoration(
        hintText: hint_text,
        filled: true,
        fillColor: MyTheme.white,
        hintStyle: TextStyle(fontSize: 12.0, color: MyTheme.textfield_grey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.appBarColor, width: 0.2),
          borderRadius: const BorderRadius.all(
            const Radius.circular(6.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyTheme.accent_color, width: 1),
          borderRadius: const BorderRadius.all(
            const Radius.circular(6.0),
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        suffix: suffix);
  }

  static InputDecoration buildInputDecoration_phone({hint_text = ""}) {
    return InputDecoration(
        hintText: hint_text,
        hintStyle: TextStyle(fontSize: 12.0, color: MyTheme.textfield_grey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyTheme.textfield_grey, width: 0.5),
          borderRadius: BorderRadius.all(
            Radius.circular(6.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyTheme.accent_color, width: 0.5),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(6.0),
                bottomRight: Radius.circular(6.0))),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0));
  }
}
