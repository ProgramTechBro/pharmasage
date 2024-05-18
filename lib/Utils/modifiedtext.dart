import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class modifiedtext extends StatelessWidget {
  final String? text;
  final Color? colors;
  final double? Size;
  modifiedtext({this.text,this.colors,this.Size});
  @override
  Widget build(BuildContext context) {
    return Text(
      text!,style: GoogleFonts.breeSerif(
      color: colors!,
      fontSize: Size!,
    ),
    );
  }
}