import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

String baseUrl = "https://newsapi.org/v2/everything?";
String token = "45cf1b4a7470403894da422b709c1cbe";

myStyle(double size, Color clr, [FontWeight? fw]) {
  return GoogleFonts.nunito(fontSize: size, color: clr, fontWeight: fw);
}
