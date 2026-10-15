import 'package:flutter/material.dart';

/// نطاق تطبيق الميزة
enum ApplyTarget {
  // الأزرار
  allKeys,          // كل الأزرار
  lettersRow,       // أزرار الكتابة (normal)
  topRow,           // الصف العلوي (row 1)
  bottomRow,        // الصف السفلي (row 4)
  functionalKeys,   // الأزرار الوظيفية
  deleteKey,        // زر الحذف
  enterKey,         // زر Enter
  emojiKey,         // زر الإيموجي
  spacebar,         // زر المسافة
  shiftKey,         // زر Shift
  symbolsKey,       // زر ?123

  // الخلفيات
  keyboardBackground, // خلف الكيبورد
  keyBackground,      // خلف الأزرار
  screenBackground,   // خلف الشاشة

  // مخصص
  customGroup,        // مجموعة معينة
  customKey,          // زر فردي
}

extension ApplyTargetExt on ApplyTarget {
  /// الاسم العربي
  String get labelAr {
    switch (this) {
      case ApplyTarget.allKeys:
        return 'كل الأزرار';
      case ApplyTarget.lettersRow:
        return 'أزرار الكتابة';
      case ApplyTarget.topRow:
        return 'الصف العلوي';
      case ApplyTarget.bottomRow:
        return 'الصف السفلي';
      case ApplyTarget.functionalKeys:
        return 'الأزرار الوظيفية';
      case ApplyTarget.deleteKey:
        return 'زر الحذف';
      case ApplyTarget.enterKey:
        return 'زر Enter';
      case ApplyTarget.emojiKey:
        return 'زر الإيموجي';
      case ApplyTarget.spacebar:
        return 'زر المسافة';
      case ApplyTarget.shiftKey:
        return 'زر Shift';
      case ApplyTarget.symbolsKey:
        return 'زر ?123';
      case ApplyTarget.keyboardBackground:
        return 'خلف الكيبورد';
      case ApplyTarget.keyBackground:
        return 'خلف الأزرار';
      case ApplyTarget.screenBackground:
        return 'خلف الشاشة';
      case ApplyTarget.customGroup:
        return 'مجموعة مخصصة';
      case ApplyTarget.customKey:
        return 'زر مخصص';
    }
  }

  /// الأيقونة
  IconData get icon {
    switch (this) {
      case ApplyTarget.allKeys:
        return Icons.apps;
      case ApplyTarget.lettersRow:
        return Icons.keyboard;
      case ApplyTarget.topRow:
        return Icons.arrow_upward;
      case ApplyTarget.bottomRow:
        return Icons.arrow_downward;
      case ApplyTarget.functionalKeys:
        return Icons.functions;
      case ApplyTarget.deleteKey:
        return Icons.backspace;
      case ApplyTarget.enterKey:
        return Icons.keyboard_return;
      case ApplyTarget.emojiKey:
        return Icons.emoji_emotions;
      case ApplyTarget.spacebar:
        return Icons.space_bar;
      case ApplyTarget.shiftKey:
        return Icons.keyboard_arrow_up;
      case ApplyTarget.symbolsKey:
        return Icons.numbers;
      case ApplyTarget.keyboardBackground:
        return Icons.wallpaper;
      case ApplyTarget.keyBackground:
        return Icons.crop_square;
      case ApplyTarget.screenBackground:
        return Icons.fullscreen;
      case ApplyTarget.customGroup:
        return Icons.group_work;
      case ApplyTarget.customKey:
        return Icons.touch_app;
    }
  }

  /// التصنيف
  ApplyTargetCategory get category {
    switch (this) {
      case ApplyTarget.allKeys:
      case ApplyTarget.lettersRow:
      case ApplyTarget.topRow:
      case ApplyTarget.bottomRow:
      case ApplyTarget.functionalKeys:
        return ApplyTargetCategory.groups;
      case ApplyTarget.deleteKey:
      case ApplyTarget.enterKey:
      case ApplyTarget.emojiKey:
      case ApplyTarget.spacebar:
      case ApplyTarget.shiftKey:
      case ApplyTarget.symbolsKey:
        return ApplyTargetCategory.singleKeys;
      case ApplyTarget.keyboardBackground:
      case ApplyTarget.keyBackground:
      case ApplyTarget.screenBackground:
        return ApplyTargetCategory.backgrounds;
      case ApplyTarget.customGroup:
      case ApplyTarget.customKey:
        return ApplyTargetCategory.custom;
    }
  }

  /// الـ selector المقابل
  String get selector {
    switch (this) {
      case ApplyTarget.allKeys:
      case ApplyTarget.lettersRow:
        return 'normal';
      case ApplyTarget.topRow:
        return 'normal row 0';
      case ApplyTarget.bottomRow:
        return 'normal row -1';
      case ApplyTarget.functionalKeys:
        return 'functional';
      case ApplyTarget.deleteKey:
        return 'icon delete_key';
      case ApplyTarget.enterKey:
        return 'icon enter_key';
      case ApplyTarget.emojiKey:
        return 'icon action_emoji';
      case ApplyTarget.spacebar:
        return 'spacebar';
      case ApplyTarget.shiftKey:
        return 'icon shift_key';
      case ApplyTarget.symbolsKey:
        return 'functional row -1 col 0';
      case ApplyTarget.keyboardBackground:
      case ApplyTarget.keyBackground:
      case ApplyTarget.screenBackground:
        return 'background';
      case ApplyTarget.customGroup:
      case ApplyTarget.customKey:
        return 'custom';
    }
  }

  /// هل يؤثر على الكيبورد؟
  bool get affectsKeyboard {
    return category != ApplyTargetCategory.backgrounds;
  }

  /// هل يؤثر على الخلفية؟
  bool get affectsBackground {
    return category == ApplyTargetCategory.backgrounds;
  }
}

/// تصنيف النطاقات
enum ApplyTargetCategory {
  groups,
  singleKeys,
  backgrounds,
  custom,
}

extension ApplyTargetCategoryExt on ApplyTargetCategory {
  String get labelAr {
    switch (this) {
      case ApplyTargetCategory.groups:
        return 'المجموعات';
      case ApplyTargetCategory.singleKeys:
        return 'أزرار محددة';
      case ApplyTargetCategory.backgrounds:
        return 'الخلفيات';
      case ApplyTargetCategory.custom:
        return 'مخصص';
    }
  }

  IconData get icon {
    switch (this) {
      case ApplyTargetCategory.groups:
        return Icons.group_work;
      case ApplyTargetCategory.singleKeys:
        return Icons.touch_app;
      case ApplyTargetCategory.backgrounds:
        return Icons.wallpaper;
      case ApplyTargetCategory.custom:
        return Icons.settings;
    }
  }

  Color get color {
    switch (this) {
      case ApplyTargetCategory.groups:
        return const Color(0xFF16D9F2);
      case ApplyTargetCategory.singleKeys:
        return const Color(0xFF8B5CF6);
      case ApplyTargetCategory.backgrounds:
        return const Color(0xFFFF6B9D);
      case ApplyTargetCategory.custom:
        return const Color(0xFF10E5A0);
    }
  }
}

/// نتيجة اختيار
class ApplySelection {
  final ApplyTarget target;
  final String? customGroupId;
  final String? customKeySelector;

  const ApplySelection({
    required this.target,
    this.customGroupId,
    this.customKeySelector,
  });

  String get effectiveSelector {
    if (target == ApplyTarget.customGroup && customGroupId != null) {
      return customGroupId!;
    }
    if (target == ApplyTarget.customKey && customKeySelector != null) {
      return customKeySelector!;
    }
    return target.selector;
  }
}
