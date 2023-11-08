import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomInputs {
  static InputDecoration loginInputDecoration({
    required String hint,
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 10, 125, 243))),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 10, 125, 243)),
        ),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 247, 36, 36))),
        focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 10, 125, 243))),
        hintText: hint,
        hintStyle: const TextStyle(
            color: Color.fromARGB(255, 209, 209, 209), fontSize: 16),
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          color: Colors.blue,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          icon,
          color: const Color.fromARGB(255, 209, 209, 209),
        ));
  }

  static InputDecoration searchInputDecoration(
      {required String hint, required IconData icon}) {
    return InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey),
        labelStyle: const TextStyle(color: Colors.blue),
        hintStyle: const TextStyle(color: Colors.grey));
  }
}
