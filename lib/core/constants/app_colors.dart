import 'package:flutter/material.dart';

/// Centralized color palette for dark & light themes
class AppColors {
  AppColors._();

  // ─── Cyber-Glass Palette ────────────────────────
  static const Color darkBg = Color(0xFF030712);        // Deep indigo/black
  static const Color darkBgSecondary = Color(0xFF0F172A); // Navy depth

  // ─── Accent Colors (Neon) ──────────────────────
  static const Color primary = Color(0xFFFF6600);       // Neon Orange
  static const Color secondary = Color(0xFF00F2FF);     // Electric Cyan
  static const Color primaryGlow = Color(0x66FF6600);   // Soft Orange Glow
  static const Color secondaryGlow = Color(0x6600F2FF); // Soft Cyan Glow

  // ─── Glassmorphism ─────────────────────────────
  static const Color glassBg = Color(0x1AFFFFFF);      // Semi-transparent overlay
  static const Color glassBorder = Color(0x33FFFFFF);  // Subtle white border
  static const Color glassBorderCyan = Color(0x3300F2FF); // Subtle cyan border
  static const Color darkDivider = Color(0x1AFFFFFF);   // White with 10% alpha

  // ─── Text Colors ───────────────────────────────

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8); // Slate-400
  static const Color textHint = Color(0xFF64748B);      // Slate-500
  static const Color darkTextHint = Color(0xFF475569);  // Slate-600

  // ─── Semantic Colors ───────────────────────────
  static const Color success = Color(0xFF10B981);       // Emerald
  static const Color error = Color(0xFFEF4444);         // Rose
  static const Color warning = Color(0xFFF59E0B);       // Amber
  static const Color info = Color(0xFF3B82F6);          // Blue
  static const Color accent = Color(0xFF8B5CF6);        // Violet


  // ─── Gradient Presets ──────────────────────────
  static const LinearGradient bgGradient = LinearGradient(
    colors: [darkBg, darkBgSecondary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFFFF0000)], // Orange to Red
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [glassBg, Color(0x08FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );


  static const LinearGradient glassBorderGradient = LinearGradient(
    colors: [Colors.white24, Colors.white10],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient meshGradient = LinearGradient(
    colors: [Color(0x0DFFFFFF), Color(0x00FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Legacy/Light Mode Support (Redirects) ──────
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightDivider = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextHint = Color(0xFF94A3B8);
}


