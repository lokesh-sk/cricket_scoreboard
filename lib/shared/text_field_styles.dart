import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

InputDecoration inputDecoration({required String labelText}) {
  return InputDecoration(
      labelText: labelText, filled: true, border: const OutlineInputBorder());
}

TextStyle textStyle = const TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
);

TextStyle scoreBoardTextSTyle = GoogleFonts.anton();