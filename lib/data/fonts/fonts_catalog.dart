import 'package:flutter/material.dart';

/// Only fonts physically bundled with the app are listed here.
/// Each bundled family contains Latin and Arabic glyph coverage.
class FontsCatalog {
  FontsCatalog._();

  static const List<BuiltInFont> fonts = [
    BuiltInFont(
      id: 'dejavu_sans',
      displayName: 'DejaVu Sans',
      displayNameAr: 'ديفاجو سانس',
      family: 'DejaVu Sans',
      assetPath: 'assets/fonts/DejaVuSans.ttf',
      googleFontsId: 'DejaVu Sans',
      language: 'ar-en',
    ),
    BuiltInFont(
      id: 'free_sans',
      displayName: 'FreeSans',
      displayNameAr: 'فري سانس',
      family: 'FreeSans',
      assetPath: 'assets/fonts/FreeSans.otf',
      googleFontsId: 'FreeSans',
      language: 'ar-en',
    ),
    BuiltInFont(
      id: 'free_serif',
      displayName: 'FreeSerif',
      displayNameAr: 'فري سيرف',
      family: 'FreeSerif',
      assetPath: 'assets/fonts/FreeSerif.otf',
      googleFontsId: 'FreeSerif',
      language: 'ar-en',
    ),
    BuiltInFont(
      id: 'dejavu_mono',
      displayName: 'DejaVu Sans Mono',
      displayNameAr: 'ديفاجو أحادي',
      family: 'DejaVu Sans Mono',
      assetPath: 'assets/fonts/DejaVuSansMono.ttf',
      googleFontsId: 'DejaVu Sans Mono',
      language: 'ar-en',
    ),
  ];

  static List<BuiltInFont> get arabicFonts => fonts;
  static List<BuiltInFont> get englishFonts => fonts;

  static List<BuiltInFont> search(String query) {
    if (query.trim().isEmpty) return fonts;
    final q = query.toLowerCase();
    return fonts.where((f) =>
      f.displayName.toLowerCase().contains(q) ||
      f.displayNameAr.contains(q) ||
      f.family.toLowerCase().contains(q)).toList();
  }

  static BuiltInFont? getById(String id) {
    try {
      return fonts.firstWhere((f) => f.id == id || f.family.toLowerCase() == id.toLowerCase());
    } catch (_) {
      return null;
    }
  }
}

class BuiltInFont {
  final String id;
  final String displayName;
  final String displayNameAr;
  final String family;
  final String assetPath;
  final String googleFontsId;
  final String language;
  final FontStyle style;

  const BuiltInFont({
    required this.id,
    required this.displayName,
    required this.displayNameAr,
    required this.family,
    required this.assetPath,
    required this.googleFontsId,
    required this.language,
    this.style = FontStyle.normal,
  });

  bool get isArabic => language == 'ar' || language == 'ar-en';
  bool get isEnglish => language == 'en' || language == 'ar-en';
}
