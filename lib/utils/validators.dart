import 'dart:io';

/// نتيجة التحقق
class FieldValidation {
  final bool isValid;
  final String? error;

  const FieldValidation({required this.isValid, this.error});

  static const FieldValidation valid = FieldValidation(isValid: true);
  static FieldValidation invalid(String message) =>
      FieldValidation(isValid: false, error: message);
}

/// التحقق من المدخلات
class Validators {
  Validators._();

  // ═══ Theme Metadata ═══

  static FieldValidation themeName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return FieldValidation.invalid('اسم الثيم مطلوب');
    }
    if (value.trim().length < 2) {
      return FieldValidation.invalid('الاسم قصير جداً');
    }
    if (value.length > 45) {
      return FieldValidation.invalid('الاسم طويل جداً (45 كحد أقصى)');
    }
    return FieldValidation.valid;
  }

  static FieldValidation authorName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return FieldValidation.invalid('اسم المؤلف مطلوب');
    }
    if (value.length > 45) {
      return FieldValidation.invalid('الاسم طويل جداً');
    }
    return FieldValidation.valid;
  }

  static FieldValidation descriptionCheck(String? value) {
    if (value == null) return FieldValidation.valid;
    if (value.length > 200) {
      return FieldValidation.invalid('الوصف طويل جداً');
    }
    return FieldValidation.valid;
  }

  // ═══ Numeric ═══

  static FieldValidation decimal(String? value, {double? min, double? max}) {
    if (value == null || value.trim().isEmpty) {
      return FieldValidation.invalid('القيمة مطلوبة');
    }
    final parsed = double.tryParse(value);
    if (parsed == null) {
      return FieldValidation.invalid('قيمة رقمية غير صحيحة');
    }
    if (min != null && parsed < min) {
      return FieldValidation.invalid('القيمة يجب أن تكون ≥ $min');
    }
    if (max != null && parsed > max) {
      return FieldValidation.invalid('القيمة يجب أن تكون ≤ $max');
    }
    return FieldValidation.valid;
  }

  static FieldValidation integer(String? value, {int? min, int? max}) {
    if (value == null || value.trim().isEmpty) {
      return FieldValidation.invalid('القيمة مطلوبة');
    }
    final parsed = int.tryParse(value);
    if (parsed == null) {
      return FieldValidation.invalid('رقم صحيح غير صالح');
    }
    if (min != null && parsed < min) {
      return FieldValidation.invalid('القيمة يجب أن تكون ≥ $min');
    }
    if (max != null && parsed > max) {
      return FieldValidation.invalid('القيمة يجب أن تكون ≤ $max');
    }
    return FieldValidation.valid;
  }

  // ═══ HEX ═══

  static FieldValidation hexColor(String? value) {
    if (value == null || value.trim().isEmpty) {
      return FieldValidation.invalid('اللون مطلوب');
    }
    final cleaned = value.replaceAll('#', '').trim();
    if (!RegExp(r'^[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?$').hasMatch(cleaned)) {
      return FieldValidation.invalid('صيغة اللون غير صحيحة');
    }
    return FieldValidation.valid;
  }

  // ═══ Files ═══

  static Future<FieldValidation> fontFile(File file) async {
    if (!await file.exists()) {
      return FieldValidation.invalid('الملف غير موجود');
    }

    final ext = file.path.split('.').last.toLowerCase();
    if (!['ttf', 'otf', 'woff', 'woff2'].contains(ext)) {
      return FieldValidation.invalid('صيغة الخط غير مدعومة');
    }

    final size = await file.length();
    if (size > 8 * 1024 * 1024) {
      return FieldValidation.invalid('حجم الخط كبير جداً (8 MB)');
    }
    if (size < 1024) {
      return FieldValidation.invalid('حجم الخط صغير جداً');
    }

    return FieldValidation.valid;
  }

  static Future<FieldValidation> imageFile(File file) async {
    if (!await file.exists()) {
      return FieldValidation.invalid('الملف غير موجود');
    }

    final ext = file.path.split('.').last.toLowerCase();
    if (!['png', 'jpg', 'jpeg', 'webp', 'svg'].contains(ext)) {
      return FieldValidation.invalid('صيغة الصورة غير مدعومة');
    }

    final size = await file.length();
    if (size > 12 * 1024 * 1024) {
      return FieldValidation.invalid('حجم الصورة كبير جداً (12 MB)');
    }

    return FieldValidation.valid;
  }

  // ═══ Selector ═══

  static FieldValidation selector(String? value) {
    if (value == null || value.trim().isEmpty) {
      return FieldValidation.invalid('الـ selector مطلوب');
    }
    if (!RegExp(r'^[a-z_\-0-9 ]+$').hasMatch(value.trim())) {
      return FieldValidation.invalid('صيغة الـ selector غير صحيحة');
    }
    return FieldValidation.valid;
  }

  // ═══ Composite ═══

  static Map<String, String?> validateProject({
    required String name,
    required String author,
    required String description,
  }) {
    final errors = <String, String?>{};

    final n = themeName(name);
    if (!n.isValid) errors['name'] = n.error;

    final a = authorName(author);
    if (!a.isValid) errors['author'] = a.error;

    final d = descriptionCheck(description);
    if (!d.isValid) errors['description'] = d.error;

    return errors.isEmpty ? {} : errors;
  }

  static bool isNotEmpty(String? value) =>
      value != null && value.trim().isNotEmpty;

  static bool isValidHex(String? value) => hexColor(value).isValid;
}
