import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle surahText(BuildContext context) {
  return GoogleFonts.amiri(
    fontSize: 22, // Set the font size
    color: Theme.of(context).colorScheme.secondary, // Use secondary color from theme
  );
}
TextStyle primaryText(BuildContext context,) {
  return GoogleFonts.roboto(
    fontSize: 15, // Set the font size
    color: Theme.of(context).colorScheme.secondary, // Use secondary color from theme
  );
}

