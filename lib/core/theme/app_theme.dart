import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF7F56D9); // Violet from UI
  static const Color secondaryColor = Color(0xFFF5F5F9); // Light Grey Background
  static const Color accentColor = Color(0xFF66C61C); // Green "Active" badges
  static const Color textDark = Color(0xFF1D2939);
  static const Color textLight = Color(0xFF667085);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: secondaryColor,
      primaryColor: primaryColor,
      fontFamily: GoogleFonts.inter().fontFamily,
      
      // Card Theme (Clean white with soft shadow)
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFEAECF0)),
        ),
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      
      // Text Theme overrides
      textTheme: TextTheme(
        displayLarge: const TextStyle(color: textDark, fontWeight: FontWeight.bold),
        bodyLarge: const TextStyle(color: textDark),
        bodyMedium: const TextStyle(color: textLight),
      ),
    );
  }
}