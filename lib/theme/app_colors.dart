import 'package:flutter/material.dart';

/// Design tokens for Analyze Pro, taken from the splash and login
/// specifications in `Analyze Pro.docx`. Keep every new colour here rather
/// than hard-coding it at the call site.
class AppColors {
  AppColors._();

  // --- Backgrounds --------------------------------------------------------
  static const white = Color(0xFFFFFFFF);
  static const coolWhite = Color(0xFFF8FCFF);
  static const iceBlue = Color(0xFFEDF7FF);
  static const softBlueBg = Color(0xFFE1F0FF);

  // --- Branding -----------------------------------------------------------
  /// "Analyze", the Login heading and primary headings.
  static const navy = Color(0xFF102F69);

  /// "Pro".
  static const brightBlue = Color(0xFF0785E8);

  /// Andhra Educational Trust.
  static const trustBlue = Color(0xFF173A70);

  // --- Supporting text ----------------------------------------------------
  static const tagline = Color(0xFF80AEE4);
  static const subtitle = Color(0xFF526D91);
  static const placeholder = Color(0xFF667C9E);
  static const fieldIcon = Color(0xFF607696);
  static const fromText = Color(0xFF7894B8);
  static const rule = Color(0xFFB8CCE4);
  static const linkBlue = Color(0xFF087DE3);

  // --- Fields and buttons -------------------------------------------------
  static const fieldBorder = Color(0xFFD8E8F8);
  static const fieldShadow = Color(0xFFE2EFFB);
  static const cardBorder = Color(0xFFE1EEFA);
  static const cardShadow = Color(0xFFD9EAFB);
  static const buttonTop = Color(0xFF36A8F5);
  static const buttonMid = Color(0xFF2398F1);
  static const buttonBottom = Color(0xFF1685EA);
  static const buttonShadow = Color(0xFFC8E5FF);

  /// Leaf mark in the bottom-right corner.
  static const leaf = Color(0xFFA8CDF5);
}
