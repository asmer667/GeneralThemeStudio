import 'package:flutter/material.dart';

import '../models/gradient_preset.dart';

/// مكتبة 60+ تدرج جاهز
class GradientsCatalog {
  GradientsCatalog._();

  static List<GradientPreset> get all => [
        // ═══ Neon (10) ═══
        _g('Neon Cyan', ['#16D9F2', '#0A8DA0']),
        _g('Neon Purple', ['#8B5CF6', '#6D3FE0']),
        _g('Neon Pink', ['#FF6B9D', '#E91E63']),
        _g('Neon Green', ['#10E5A0', '#00B894']),
        _g('Neon Blue', ['#3B82F6', '#1E40AF']),
        _g('Neon Orange', ['#FF9500', '#E67E22']),
        _g('Neon Yellow', ['#FFD700', '#F39C12']),
        _g('Neon Red', ['#FF3D5A', '#C0392B']),
        _g('Neon Teal', ['#00BCD4', '#00838F']),
        _g('Neon Lime', ['#CDDC39', '#827717']),

        // ═══ Aurora (8) ═══
        _g3('Aurora', ['#16D9F2', '#8B5CF6', '#FF6B9D']),
        _g3('Cosmic', ['#8B5CF6', '#FF6B9D', '#16D9F2']),
        _g3('Sunset', ['#FF9500', '#FF6B9D', '#8B5CF6']),
        _g3('Ocean', ['#16D9F2', '#3B82F6', '#8B5CF6']),
        _g3('Fire', ['#FFD700', '#FF9500', '#FF3D5A']),
        _g3('Forest', ['#10E5A0', '#16D9F2', '#3B82F6']),
        _g3('Rainbow', ['#FF3D5A', '#FFD700', '#10E5A0', '#3B82F6', '#8B5CF6']),
        _g3('Twilight', ['#1A1A2E', '#16213E', '#0F3460']),

        // ═══ Nature (8) ═══
        _g('Sunrise', ['#FFC371', '#FF5F6D']),
        _g('Dawn', ['#FEB47B', '#FF7E5F']),
        _g('Sky', ['#2196F3', '#64B5F6']),
        _g('Sea', ['#00BCD4', '#0097A7']),
        _g('Leaf', ['#66BB6A', '#388E3C']),
        _g('Grass', ['#A8E063', '#56AB2F']),
        _g('Desert', ['#F6D365', '#FDA085']),
        _g('Mountain', ['#4A6FA5', '#1D3557']),

        // ═══ Pastel (8) ═══
        _g('Pastel Pink', ['#FFB4CE', '#FF8DA1']),
        _g('Pastel Blue', ['#A1C4FD', '#C2E9FB']),
        _g('Pastel Purple', ['#DDA0DD', '#BA55D3']),
        _g('Pastel Green', ['#B5EAD7', '#A8E6CF']),
        _g('Pastel Yellow', ['#FFF4A3', '#FFE066']),
        _g('Pastel Orange', ['#FFDAB9', '#FFB088']),
        _g('Pastel Mint', ['#98FB98', '#7FD1B9']),
        _g('Pastel Lavender', ['#E6E6FA', '#B19CD9']),

        // ═══ Dark (8) ═══
        _g('Night', ['#05070D', '#0A0F1A']),
        _g('Deep Sea', ['#0A1929', '#1A3A5C']),
        _g('Dark Purple', ['#1A0033', '#3D0066']),
        _g('Carbon', ['#1A1A1A', '#333333']),
        _g('Midnight', ['#0F1621', '#1A2536']),
        _g('Obsidian', ['#0B0B0B', '#1C1C1C']),
        _g('Ink', ['#0F1419', '#1E2A38']),
        _g('Space', ['#0B1026', '#2E1A47']),

        // ═══ Food (6) ═══
        _g('Strawberry', ['#FF5E62', '#FF9966']),
        _g('Orange', ['#FFA500', '#FF8C00']),
        _g('Lemon', ['#FFF200', '#FFD700']),
        _g('Watermelon', ['#FF5E62', '#10E5A0']),
        _g('Chocolate', ['#7B3F00', '#4E2A0E']),
        _g('Coffee', ['#6F4E37', '#3E2723']),

        // ═══ Retro (6) ═══
        _g('Retro Wave', ['#FF006E', '#8338EC', '#3A86FF']),
        _g('Synthwave', ['#FF00FF', '#00FFFF']),
        _g('Vaporwave', ['#FF71CE', '#01CDFE', '#05FFA1']),
        _g('Cyberpunk', ['#F72585', '#7209B7', '#3A0CA3']),
        _g('80s Neon', ['#FF1493', '#FFD700']),
        _g('Miami', ['#FF6B9D', '#16D9F2']),

        // ═══ Metal (4) ═══
        _g('Gold', ['#FFD700', '#B8860B']),
        _g('Silver', ['#E0E0E0', '#A0A0A0']),
        _g('Bronze', ['#CD7F32', '#8B4513']),
        _g('Platinum', ['#E5E4E2', '#C0C0C0']),

        // ═══ Radial (2) ═══
        GradientPreset(
          id: 'radial_glow',
          name: 'Glow',
          type: GradientType.radial,
          colors: const [
            Color(0xFF16D9F2),
            Color(0xFF0A8DA0),
            Color(0xFF071426),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        GradientPreset(
          id: 'radial_sun',
          name: 'Sun Burst',
          type: GradientType.radial,
          colors: const [
            Color(0xFFFFD700),
            Color(0xFFFF9500),
            Color(0xFFC0392B),
          ],
        ),
      ];

  static GradientPreset _g(String name, List<String> hexList) {
    return GradientPreset(
      id: 'grad_${name.toLowerCase().replaceAll(" ", "_")}',
      name: name,
      colors: hexList.map(_parseHex).toList(),
      angle: 45,
    );
  }

  static GradientPreset _g3(String name, List<String> hexList) {
    return GradientPreset(
      id: 'grad_${name.toLowerCase().replaceAll(" ", "_")}',
      name: name,
      colors: hexList.map(_parseHex).toList(),
      angle: 135,
    );
  }

  static Color _parseHex(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  /// بحث
  static List<GradientPreset> search(String query) {
    final list = all;
    if (query.trim().isEmpty) return list;
    final q = query.toLowerCase();
    return list.where((g) => g.name.toLowerCase().contains(q)).toList();
  }

  /// عدد الإجمالي
  static int get total => all.length;
}
