import 'package:flutter/material.dart';

InputDecoration inputDecoration({required String labelText}) {
  return InputDecoration(
      labelText: labelText, filled: true, border: const OutlineInputBorder());
}

TextStyle textStyle = const TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
);
