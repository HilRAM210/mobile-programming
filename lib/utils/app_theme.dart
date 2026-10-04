import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized theme configuration for TokoKamu.
///
/// - Display / headline / title → Space Grotesk (bold, geometric)
/// - Body / label              → Inter (readable, clean)
class AppTheme {
  AppTheme._();

  static const _seedColor = Colors.green;

  // ---------------------------------------------------------------------------
  // Public entry point
  // ---------------------------------------------------------------------------

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(colorScheme),
    );
  }

  // ---------------------------------------------------------------------------
  // Text theme
  // ---------------------------------------------------------------------------

  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    final onSurface = colorScheme.onSurface;

    // Space Grotesk for headlines & titles
    final sg = GoogleFonts.spaceGrotesk;
    // Inter for body & labels
    final inter = GoogleFonts.inter;

    return TextTheme(
      // Display — Space Grotesk
      displayLarge: sg(fontSize: 57, fontWeight: FontWeight.w400, color: onSurface),
      displayMedium: sg(fontSize: 45, fontWeight: FontWeight.w400, color: onSurface),
      displaySmall: sg(fontSize: 36, fontWeight: FontWeight.w400, color: onSurface),
      // Headline — Space Grotesk
      headlineLarge: sg(fontSize: 32, fontWeight: FontWeight.w600, color: onSurface),
      headlineMedium: sg(fontSize: 28, fontWeight: FontWeight.w600, color: onSurface),
      headlineSmall: sg(fontSize: 24, fontWeight: FontWeight.w600, color: onSurface),
      // Title — Space Grotesk
      titleLarge: sg(fontSize: 22, fontWeight: FontWeight.w600, color: onSurface),
      titleMedium: sg(fontSize: 16, fontWeight: FontWeight.w600, color: onSurface),
      titleSmall: sg(fontSize: 14, fontWeight: FontWeight.w600, color: onSurface),
      // Body — Inter
      bodyLarge: inter(fontSize: 16, fontWeight: FontWeight.w400, color: onSurface),
      bodyMedium: inter(fontSize: 14, fontWeight: FontWeight.w400, color: onSurface),
      bodySmall: inter(fontSize: 12, fontWeight: FontWeight.w400, color: onSurface),
      // Label — Inter
      labelLarge: inter(fontSize: 14, fontWeight: FontWeight.w500, color: onSurface),
      labelMedium: inter(fontSize: 12, fontWeight: FontWeight.w500, color: onSurface),
      labelSmall: inter(fontSize: 11, fontWeight: FontWeight.w500, color: onSurface),
    );
  }
}
