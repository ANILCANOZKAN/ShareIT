import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class projectTitle {
  Text appBarTitle(String _title) {
    return Text(
      _title,
      style: GoogleFonts.pacifico(fontSize: 35, color: Color(0xff3e003e)),
    );
  }
}
