/// نصوص وأرقام عربية
class ArabicText {
  ArabicText._();

  // ═══ صفوف لوحة المفاتيح العربية ═══

  static const List<String> row1 = [
    'ض', 'ص', 'ث', 'ق', 'ف', 'غ', 'ع', 'ه', 'خ', 'ح', 'ج',
  ];
  static const List<String> row2 = [
    'ش', 'س', 'ي', 'ب', 'ل', 'ا', 'ت', 'ن', 'م', 'ك', 'ط',
  ];
  static const List<String> row3 = [
    'ئ', 'ء', 'ؤ', 'ر', 'لا', 'ى', 'ة', 'و', 'ز', 'ظ', 'د',
  ];

  static const List<String> arabicIndicNumerals = [
    '٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩',
  ];
  static const List<String> westernNumerals = [
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
  ];

  // ═══ نصوص شائعة ═══

  static const String space = 'مسافة';
  static const String enter = 'إدخال';
  static const String backspace = 'حذف';
  static const String shift = 'تحويل';
  static const String symbols = 'رموز';
  static const String numbers = '?123';
  static const String emoji = 'إيموجي';
  static const String comma = '،';
  static const String period = '.';
  static const String questionMark = '؟';

  // ═══ أرقام ═══

  static String toArabicNumber(int number) {
    return number.toString().split('').map((d) {
      final i = int.tryParse(d);
      if (i == null) return d;
      return arabicIndicNumerals[i];
    }).join();
  }

  static String toWesternNumber(String arabicNumber) {
    String result = arabicNumber;
    for (var i = 0; i < 10; i++) {
      result = result.replaceAll(arabicIndicNumerals[i], westernNumerals[i]);
    }
    return result;
  }

  // ═══ تحقق ═══

  static bool isArabic(String text) {
    final arabicRegex = RegExp(
      r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
    );
    return arabicRegex.hasMatch(text);
  }

  static bool isArabicLetter(String char) {
    if (char.isEmpty) return false;
    final code = char.codeUnitAt(0);
    return (code >= 0x0600 && code <= 0x06FF) ||
        (code >= 0x0750 && code <= 0x077F) ||
        (code >= 0x08A0 && code <= 0x08FF) ||
        (code >= 0xFB50 && code <= 0xFDFF) ||
        (code >= 0xFE70 && code <= 0xFEFF);
  }

  static int countArabicLetters(String text) =>
      text.split('').where(isArabicLetter).length;

  // ═══ تنسيق ═══

  static String removeDiacritics(String text) {
    final diacritics = RegExp(r'[\u064B-\u0652\u0670\u0640]');
    return text.replaceAll(diacritics, '');
  }

  static String normalize(String text) {
    return text
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي')
        .replaceAll('ة', 'ه')
        .replaceAll(RegExp(r'[\u064B-\u0652]'), '');
  }

  // ═══ الكيبورد الكامل ═══

  static List<List<String>> get allRows => [row1, row2, row3];
  static List<String> get allLetters => [...row1, ...row2, ...row3];
  static int get totalKeys => row1.length + row2.length + row3.length;

  // ═══ رسائل ═══

  static const Map<String, String> messages = {
    'save_success': 'تم الحفظ بنجاح',
    'save_failed': 'فشل الحفظ',
    'export_success': 'تم التصدير بنجاح',
    'export_failed': 'فشل التصدير',
    'import_success': 'تم الاستيراد بنجاح',
    'import_failed': 'فشل الاستيراد',
    'delete_confirm': 'هل أنت متأكد من الحذف؟',
    'delete_success': 'تم الحذف',
    'copied': 'تم النسخ',
    'no_projects': 'لا توجد مشاريع محفوظة',
    'loading': 'جارٍ التحميل...',
    'processing': 'جارٍ المعالجة...',
    'please_wait': 'يرجى الانتظار...',
    'fill_required': 'يرجى تعبئة الحقول المطلوبة',
    'invalid_name': 'الاسم غير صالح',
    'unsaved_changes': 'لديك تغييرات غير محفوظة',
    'share': 'مشاركة',
    'cancel': 'إلغاء',
    'confirm': 'تأكيد',
    'delete': 'حذف',
    'edit': 'تعديل',
    'duplicate': 'نسخ',
    'save': 'حفظ',
    'close': 'إغلاق',
    'ok': 'موافق',
    'done': 'تم',
    'add': 'إضافة',
    'remove': 'إزالة',
    'reset': 'إعادة تعيين',
    'apply': 'تطبيق',
    'search': 'بحث',
    'filter': 'تصفية',
    'all': 'الكل',
    'none': 'لا شيء',
  };

  static String msg(String key) => messages[key] ?? key;
}
