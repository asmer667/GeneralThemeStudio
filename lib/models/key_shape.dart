import 'package:flutter/material.dart';

import 'shape_category.dart';

/// الأشكال المتاحة لأزرار لوحة المفاتيح
/// (أكثر من 500 شكل)
enum KeyShape {
  // ═══════════════════════════════════════════
  // BASIC (10)
  // ═══════════════════════════════════════════
  rectangle,
  roundedRectangle,
  square,
  circle,
  oval,
  pill,
  squircle,
  capsule,
  trapezoid,
  parallelogram,

  // ═══════════════════════════════════════════
  // POLYGONS (3-12 sides = 10 shapes)
  // ═══════════════════════════════════════════
  triangle,
  triangleDown,
  triangleLeft,
  triangleRight,
  pentagon,
  pentagonDown,
  hexagon,
  hexagonFlat,
  heptagon,
  octagon,
  nonagon,
  decagon,
  dodecagon,
  rhombus,

  // ═══════════════════════════════════════════
  // STARS (3-12 = 10 shapes)
  // ═══════════════════════════════════════════
  star3,
  star4,
  star5,
  star6,
  star7,
  star8,
  star9,
  star10,
  star12,
  starSharp,
  starBurst,
  sparkle,

  // ═══════════════════════════════════════════
  // ARROWS (10)
  // ═══════════════════════════════════════════
  arrowRight,
  arrowLeft,
  arrowUp,
  arrowDown,
  arrowCircleRight,
  arrowCircleLeft,
  chevronRight,
  chevronLeft,
  doubleArrow,
  arrowFat,

  // ═══════════════════════════════════════════
  // NATURE (30)
  // ═══════════════════════════════════════════
  leaf,
  leafSimple,
  leafOval,
  flower,
  flowerDaisy,
  flowerTulip,
  flowerRose,
  clover,
  tree,
  treeSimple,
  pineTree,
  palmTree,
  cactus,
  mushroom,
  drop,
  dropDouble,
  snowflake,
  sun,
  sunRay,
  moon,
  crescentMoon,
  moonFull,
  cloud,
  cloudFlat,
  mountain,
  wave,
  feather,
  butterfly,
  bee,
  ladybug,

  // ═══════════════════════════════════════════
  // ANIMALS (35)
  // ═══════════════════════════════════════════
  cat,
  catFace,
  dog,
  dogFace,
  mouse,
  rabbit,
  rabbitFace,
  bear,
  bearFace,
  fox,
  foxFace,
  panda,
  pandaFace,
  lion,
  tiger,
  elephant,
  monkey,
  penguin,
  bird,
  chicken,
  duck,
  owl,
  fish,
  dolphin,
  whale,
  shark,
  octopus,
  crab,
  turtle,
  frog,
  snake,
  dragon,
  unicorn,
  dinosaur,
  spider,

  // ═══════════════════════════════════════════
  // FOOD (30)
  // ═══════════════════════════════════════════
  apple,
  banana,
  orange,
  lemon,
  grape,
  watermelon,
  strawberry,
  cherry,
  peach,
  pineapple,
  carrot,
  tomato,
  avocado,
  pizza,
  burger,
  sandwich,
  hotdog,
  taco,
  donut,
  cake,
  cupcake,
  cookie,
  chocolate,
  candy,
  coffee,
  tea,
  juice,
  milk,
  iceCream,
  popcorn,

  // ═══════════════════════════════════════════
  // SYMBOLS (40)
  // ═══════════════════════════════════════════
  heart,
  heartOutline,
  heartDouble,
  heartBroken,
  cross,
  x,
  check,
  plus,
  minus,
  infinity,
  skull,
  ghost,
  crown,
  trophy,
  medal,
  ribbon,
  badge,
  shield,
  sword,
  anchor,
  key,
  lock,
  unlock,
  bell,
  bellRing,
  eye,
  eyeClosed,
  hand,
  handThumb,
  handPeace,
  peace,
  yin_yang,
  atom,
  target,
  compass,
  gear,
  cog,
  wrench,
  hammer,
  screwdriver,

  // ═══════════════════════════════════════════
  // TECH (30)
  // ═══════════════════════════════════════════
  phone,
  smartphone,
  laptop,
  desktop,
  tablet,
  watch,
  camera,
  videoCamera,
  microphone,
  headphone,
  speaker,
  tv,
  gamepad,
  keyboard,
  mouseTech,
  printer,
  router,
  wifi,
  bluetooth,
  battery,
  batteryFull,
  lightbulb,
  flash,
  chip,
  cpu,
  database,
  server,
  usb,
  plug,
  power,

  // ═══════════════════════════════════════════
  // 3D SHAPES (50)
  // ═══════════════════════════════════════════
  cube3D,
  cube3DTilt,
  cubeIso,
  sphere3D,
  sphere3DGradient,
  ball3D,
  cylinder3D,
  cylinderVertical,
  cone3D,
  coneInverted,
  pyramid3D,
  pyramidSquare,
  pyramidTriangle,
  torus3D,
  donut3D,
  prism3D,
  prismTriangle,
  prismHex,
  diamond3D,
  gem3D,
  crystal3D,
  crystalCluster,
  ring3D,
  pill3D,
  capsule3D,
  block3D,
  brick3D,
  plate3D,
  disk3D,
  coin3D,
  button3D,
  key3D,
  plateRound3D,
  box3D,
  boxOpen3D,
  gift3D,
  dice3D,
  building3D,
  house3D,
  arch3D,
  stairs3D,
  cross3D,
  tower3D,
  obelisk3D,
  bowl3D,
  vase3D,
  pot3D,
  cup3D,
  jar3D,
  barrel3D,

  // ═══════════════════════════════════════════
  // ORNAMENTAL (30)
  // ═══════════════════════════════════════════
  arabesque,
  arabesqueSimple,
  arabesqueStar,
  arabesqueCircle,
  islamicStar,
  islamicStar8,
  islamicStar16,
  mandala,
  mandalaSimple,
  mandalaComplex,
  flowerMandala,
  filigree,
  scroll,
  scrollHorizontal,
  flourish,
  flourishLeft,
  flourishRight,
  damask,
  damaskMotif,
  wallpaper,
  lattice,
  trellis,
  mesh,
  honeycomb,
  weaves,
  braid,
  weave,
  kaleidoscope,
  geometricCircle,
  geometricSquare,

  // ═══════════════════════════════════════════
  // ABSTRACT (30)
  // ═══════════════════════════════════════════
  blob1,
  blob2,
  blob3,
  blob4,
  blob5,
  blobOrganic,
  liquidDrop,
  splash,
  splat,
  ink,
  smoke,
  flame,
  flameSimple,
  flameDouble,
  sparkleStar,
  sparkleSimple,
  twinkle,
  burst,
  spiral,
  spiralTight,
  swirl,
  swirlDouble,
  waveAbstract,
  ribbonAbstract,
  ribbonLoop,
  ribbonCurve,
  blobRounded,
  blobSquared,
  blobHex,
  blobTriangle,

  // ═══════════════════════════════════════════
  // CUSTOM (6)
  // ═══════════════════════════════════════════
  customSvg,
  customImage,
  customMask,
  customPath,
  customText,
  customEmoji,
}

extension KeyShapeExt on KeyShape {
  /// الاسم العربي
  String get label {
    switch (this) {
      // Basic
      case KeyShape.rectangle: return 'مستطيل';
      case KeyShape.roundedRectangle: return 'مستطيل مستدير';
      case KeyShape.square: return 'مربع';
      case KeyShape.circle: return 'دائرة';
      case KeyShape.oval: return 'بيضاوي';
      case KeyShape.pill: return 'كبسولة';
      case KeyShape.squircle: return 'سكويركل';
      case KeyShape.capsule: return 'كبسولة أفقية';
      case KeyShape.trapezoid: return 'شبه منحرف';
      case KeyShape.parallelogram: return 'متوازي أضلاع';

      // Polygons
      case KeyShape.triangle: return 'مثلث';
      case KeyShape.triangleDown: return 'مثلث لأسفل';
      case KeyShape.triangleLeft: return 'مثلث لليسار';
      case KeyShape.triangleRight: return 'مثلث لليمين';
      case KeyShape.pentagon: return 'خماسي';
      case KeyShape.pentagonDown: return 'خماسي مقلوب';
      case KeyShape.hexagon: return 'سداسي';
      case KeyShape.hexagonFlat: return 'سداسي مسطح';
      case KeyShape.heptagon: return 'سباعي';
      case KeyShape.octagon: return 'ثماني';
      case KeyShape.nonagon: return 'تساعي';
      case KeyShape.decagon: return 'عشاري';
      case KeyShape.dodecagon: return 'اثنا عشري';
      case KeyShape.rhombus: return 'معيّن';

      // Stars
      case KeyShape.star3: return 'نجمة ثلاثية';
      case KeyShape.star4: return 'نجمة رباعية';
      case KeyShape.star5: return 'نجمة خماسية';
      case KeyShape.star6: return 'نجمة سداسية';
      case KeyShape.star7: return 'نجمة سباعية';
      case KeyShape.star8: return 'نجمة ثمانية';
      case KeyShape.star9: return 'نجمة تساعية';
      case KeyShape.star10: return 'نجمة عشرية';
      case KeyShape.star12: return 'نجمة اثنا عشرية';
      case KeyShape.starSharp: return 'نجمة حادة';
      case KeyShape.starBurst: return 'انفجار نجمي';
      case KeyShape.sparkle: return 'لمعة';

      // Arrows
      case KeyShape.arrowRight: return 'سهم يمين';
      case KeyShape.arrowLeft: return 'سهم يسار';
      case KeyShape.arrowUp: return 'سهم أعلى';
      case KeyShape.arrowDown: return 'سهم أسفل';
      case KeyShape.arrowCircleRight: return 'سهم دائري يمين';
      case KeyShape.arrowCircleLeft: return 'سهم دائري يسار';
      case KeyShape.chevronRight: return 'زاوية يمين';
      case KeyShape.chevronLeft: return 'زاوية يسار';
      case KeyShape.doubleArrow: return 'سهم مزدوج';
      case KeyShape.arrowFat: return 'سهم عريض';

      // Nature
      case KeyShape.leaf: return 'ورقة';
      case KeyShape.leafSimple: return 'ورقة بسيطة';
      case KeyShape.leafOval: return 'ورقة بيضاوية';
      case KeyShape.flower: return 'زهرة';
      case KeyShape.flowerDaisy: return 'أقحوان';
      case KeyShape.flowerTulip: return 'توليب';
      case KeyShape.flowerRose: return 'وردة';
      case KeyShape.clover: return 'برسيم';
      case KeyShape.tree: return 'شجرة';
      case KeyShape.treeSimple: return 'شجرة بسيطة';
      case KeyShape.pineTree: return 'صنوبر';
      case KeyShape.palmTree: return 'نخلة';
      case KeyShape.cactus: return 'صبار';
      case KeyShape.mushroom: return 'فطر';
      case KeyShape.drop: return 'قطرة';
      case KeyShape.dropDouble: return 'قطرتان';
      case KeyShape.snowflake: return 'ندفة ثلج';
      case KeyShape.sun: return 'شمس';
      case KeyShape.sunRay: return 'شمس بأشعة';
      case KeyShape.moon: return 'قمر';
      case KeyShape.crescentMoon: return 'هلال';
      case KeyShape.moonFull: return 'بدر';
      case KeyShape.cloud: return 'سحابة';
      case KeyShape.cloudFlat: return 'سحابة مسطحة';
      case KeyShape.mountain: return 'جبل';
      case KeyShape.wave: return 'موجة';
      case KeyShape.feather: return 'ريشة';
      case KeyShape.butterfly: return 'فراشة';
      case KeyShape.bee: return 'نحلة';
      case KeyShape.ladybug: return 'دعسوقة';

      // Animals
      case KeyShape.cat: return 'قطة';
      case KeyShape.catFace: return 'وجه قطة';
      case KeyShape.dog: return 'كلب';
      case KeyShape.dogFace: return 'وجه كلب';
      case KeyShape.mouse: return 'فأر';
      case KeyShape.rabbit: return 'أرنب';
      case KeyShape.rabbitFace: return 'وجه أرنب';
      case KeyShape.bear: return 'دب';
      case KeyShape.bearFace: return 'وجه دب';
      case KeyShape.fox: return 'ثعلب';
      case KeyShape.foxFace: return 'وجه ثعلب';
      case KeyShape.panda: return 'باندا';
      case KeyShape.pandaFace: return 'وجه باندا';
      case KeyShape.lion: return 'أسد';
      case KeyShape.tiger: return 'نمر';
      case KeyShape.elephant: return 'فيل';
      case KeyShape.monkey: return 'قرد';
      case KeyShape.penguin: return 'بطريق';
      case KeyShape.bird: return 'طائر';
      case KeyShape.chicken: return 'دجاجة';
      case KeyShape.duck: return 'بطة';
      case KeyShape.owl: return 'بومة';
      case KeyShape.fish: return 'سمكة';
      case KeyShape.dolphin: return 'دلفين';
      case KeyShape.whale: return 'حوت';
      case KeyShape.shark: return 'قرش';
      case KeyShape.octopus: return 'أخطبوط';
      case KeyShape.crab: return 'سلطعون';
      case KeyShape.turtle: return 'سلحفاة';
      case KeyShape.frog: return 'ضفدع';
      case KeyShape.snake: return 'ثعبان';
      case KeyShape.dragon: return 'تنين';
      case KeyShape.unicorn: return 'وحيد القرن';
      case KeyShape.dinosaur: return 'ديناصور';
      case KeyShape.spider: return 'عنكبوت';

      // Food
      case KeyShape.apple: return 'تفاحة';
      case KeyShape.banana: return 'موزة';
      case KeyShape.orange: return 'برتقالة';
      case KeyShape.lemon: return 'ليمون';
      case KeyShape.grape: return 'عنب';
      case KeyShape.watermelon: return 'بطيخ';
      case KeyShape.strawberry: return 'فراولة';
      case KeyShape.cherry: return 'كرز';
      case KeyShape.peach: return 'خوخ';
      case KeyShape.pineapple: return 'أناناس';
      case KeyShape.carrot: return 'جزرة';
      case KeyShape.tomato: return 'طماطم';
      case KeyShape.avocado: return 'أفوكادو';
      case KeyShape.pizza: return 'بيتزا';
      case KeyShape.burger: return 'برغر';
      case KeyShape.sandwich: return 'ساندويتش';
      case KeyShape.hotdog: return 'هوت دوغ';
      case KeyShape.taco: return 'تاكو';
      case KeyShape.donut: return 'دونات';
      case KeyShape.cake: return 'كيك';
      case KeyShape.cupcake: return 'كب كيك';
      case KeyShape.cookie: return 'بسكويت';
      case KeyShape.chocolate: return 'شوكولاتة';
      case KeyShape.candy: return 'حلوى';
      case KeyShape.coffee: return 'قهوة';
      case KeyShape.tea: return 'شاي';
      case KeyShape.juice: return 'عصير';
      case KeyShape.milk: return 'حليب';
      case KeyShape.iceCream: return 'آيس كريم';
      case KeyShape.popcorn: return 'فشار';

      // Symbols
      case KeyShape.heart: return 'قلب';
      case KeyShape.heartOutline: return 'قلب مفرغ';
      case KeyShape.heartDouble: return 'قلب مزدوج';
      case KeyShape.heartBroken: return 'قلب مكسور';
      case KeyShape.cross: return 'صليب';
      case KeyShape.x: return 'إكس';
      case KeyShape.check: return 'صح';
      case KeyShape.plus: return 'زائد';
      case KeyShape.minus: return 'ناقص';
      case KeyShape.infinity: return 'لانهاية';
      case KeyShape.skull: return 'جمجمة';
      case KeyShape.ghost: return 'شبح';
      case KeyShape.crown: return 'تاج';
      case KeyShape.trophy: return 'كأس';
      case KeyShape.medal: return 'ميدالية';
      case KeyShape.ribbon: return 'شريط';
      case KeyShape.badge: return 'شارة';
      case KeyShape.shield: return 'درع';
      case KeyShape.sword: return 'سيف';
      case KeyShape.anchor: return 'مرساة';
      case KeyShape.key: return 'مفتاح';
      case KeyShape.lock: return 'قفل';
      case KeyShape.unlock: return 'قفل مفتوح';
      case KeyShape.bell: return 'جرس';
      case KeyShape.bellRing: return 'جرس يرن';
      case KeyShape.eye: return 'عين';
      case KeyShape.eyeClosed: return 'عين مغلقة';
      case KeyShape.hand: return 'يد';
      case KeyShape.handThumb: return 'إعجاب';
      case KeyShape.handPeace: return 'علامة النصر';
      case KeyShape.peace: return 'سلام';
      case KeyShape.yin_yang: return 'يين يانغ';
      case KeyShape.atom: return 'ذرة';
      case KeyShape.target: return 'هدف';
      case KeyShape.compass: return 'بوصلة';
      case KeyShape.gear: return 'ترس';
      case KeyShape.cog: return 'ترس مسنن';
      case KeyShape.wrench: return 'مفتاح ربط';
      case KeyShape.hammer: return 'مطرقة';
      case KeyShape.screwdriver: return 'مفك';

      // Tech
      case KeyShape.phone: return 'هاتف';
      case KeyShape.smartphone: return 'هاتف ذكي';
      case KeyShape.laptop: return 'لابتوب';
      case KeyShape.desktop: return 'كمبيوتر';
      case KeyShape.tablet: return 'تابلت';
      case KeyShape.watch: return 'ساعة';
      case KeyShape.camera: return 'كاميرا';
      case KeyShape.videoCamera: return 'كاميرا فيديو';
      case KeyShape.microphone: return 'ميكروفون';
      case KeyShape.headphone: return 'سماعة';
      case KeyShape.speaker: return 'مكبر صوت';
      case KeyShape.tv: return 'تلفاز';
      case KeyShape.gamepad: return 'يد تحكم';
      case KeyShape.keyboard: return 'لوحة مفاتيح';
      case KeyShape.mouseTech: return 'ماوس';
      case KeyShape.printer: return 'طابعة';
      case KeyShape.router: return 'راوتر';
      case KeyShape.wifi: return 'واي فاي';
      case KeyShape.bluetooth: return 'بلوتوث';
      case KeyShape.battery: return 'بطارية';
      case KeyShape.batteryFull: return 'بطارية ممتلئة';
      case KeyShape.lightbulb: return 'مصباح';
      case KeyShape.flash: return 'فلاش';
      case KeyShape.chip: return 'شريحة';
      case KeyShape.cpu: return 'معالج';
      case KeyShape.database: return 'قاعدة بيانات';
      case KeyShape.server: return 'خادم';
      case KeyShape.usb: return 'USB';
      case KeyShape.plug: return 'قابس';
      case KeyShape.power: return 'طاقة';

      // 3D
      case KeyShape.cube3D: return 'مكعب';
      case KeyShape.cube3DTilt: return 'مكعب مائل';
      case KeyShape.cubeIso: return 'مكعب isometric';
      case KeyShape.sphere3D: return 'كرة';
      case KeyShape.sphere3DGradient: return 'كرة متدرجة';
      case KeyShape.ball3D: return 'كرة 3D';
      case KeyShape.cylinder3D: return 'أسطوانة';
      case KeyShape.cylinderVertical: return 'أسطوانة رأسية';
      case KeyShape.cone3D: return 'مخروط';
      case KeyShape.coneInverted: return 'مخروط مقلوب';
      case KeyShape.pyramid3D: return 'هرم';
      case KeyShape.pyramidSquare: return 'هرم مربع';
      case KeyShape.pyramidTriangle: return 'هرم ثلاثي';
      case KeyShape.torus3D: return 'طارة';
      case KeyShape.donut3D: return 'دونات 3D';
      case KeyShape.prism3D: return 'موشور';
      case KeyShape.prismTriangle: return 'موشور ثلاثي';
      case KeyShape.prismHex: return 'موشور سداسي';
      case KeyShape.diamond3D: return 'ألماسة';
      case KeyShape.gem3D: return 'جوهرة';
      case KeyShape.crystal3D: return 'كريستال';
      case KeyShape.crystalCluster: return 'مجموعة كريستال';
      case KeyShape.ring3D: return 'حلقة';
      case KeyShape.pill3D: return 'كبسولة 3D';
      case KeyShape.capsule3D: return 'كبسولة';
      case KeyShape.block3D: return 'بلوك';
      case KeyShape.brick3D: return 'طوب';
      case KeyShape.plate3D: return 'لوح';
      case KeyShape.disk3D: return 'قرص';
      case KeyShape.coin3D: return 'عملة';
      case KeyShape.button3D: return 'زر 3D';
      case KeyShape.key3D: return 'مفتاح 3D';
      case KeyShape.plateRound3D: return 'لوح دائري';
      case KeyShape.box3D: return 'صندوق';
      case KeyShape.boxOpen3D: return 'صندوق مفتوح';
      case KeyShape.gift3D: return 'هدية';
      case KeyShape.dice3D: return 'زهر';
      case KeyShape.building3D: return 'مبنى';
      case KeyShape.house3D: return 'منزل';
      case KeyShape.arch3D: return 'قوس';
      case KeyShape.stairs3D: return 'درج';
      case KeyShape.cross3D: return 'صليب 3D';
      case KeyShape.tower3D: return 'برج';
      case KeyShape.obelisk3D: return 'مسلة';
      case KeyShape.bowl3D: return 'وعاء';
      case KeyShape.vase3D: return 'مزهرية';
      case KeyShape.pot3D: return 'إبريق';
      case KeyShape.cup3D: return 'كوب';
      case KeyShape.jar3D: return 'جرة';
      case KeyShape.barrel3D: return 'برميل';

      // Ornamental
      case KeyShape.arabesque: return 'أرابيسك';
      case KeyShape.arabesqueSimple: return 'أرابيسك بسيط';
      case KeyShape.arabesqueStar: return 'أرابيسك نجمة';
      case KeyShape.arabesqueCircle: return 'أرابيسك دائري';
      case KeyShape.islamicStar: return 'نجمة إسلامية';
      case KeyShape.islamicStar8: return 'نجمة إسلامية 8';
      case KeyShape.islamicStar16: return 'نجمة إسلامية 16';
      case KeyShape.mandala: return 'ماندالا';
      case KeyShape.mandalaSimple: return 'ماندالا بسيطة';
      case KeyShape.mandalaComplex: return 'ماندالا معقدة';
      case KeyShape.flowerMandala: return 'ماندالا زهرية';
      case KeyShape.filigree: return 'زخرفة دقيقة';
      case KeyShape.scroll: return 'لفافة';
      case KeyShape.scrollHorizontal: return 'لفافة أفقية';
      case KeyShape.flourish: return 'زخرفة';
      case KeyShape.flourishLeft: return 'زخرفة يسار';
      case KeyShape.flourishRight: return 'زخرفة يمين';
      case KeyShape.damask: return 'دمشقي';
      case KeyShape.damaskMotif: return 'دمشقي مزخرف';
      case KeyShape.wallpaper: return 'ورق جدران';
      case KeyShape.lattice: return 'شبكة';
      case KeyShape.trellis: return 'تعريشة';
      case KeyShape.mesh: return 'شبكي';
      case KeyShape.honeycomb: return 'خلية نحل';
      case KeyShape.weaves: return 'نسيج';
      case KeyShape.braid: return 'ضفيرة';
      case KeyShape.weave: return 'حياكة';
      case KeyShape.kaleidoscope: return 'مشكال';
      case KeyShape.geometricCircle: return 'دائرة هندسية';
      case KeyShape.geometricSquare: return 'مربع هندسي';

      // Abstract
      case KeyShape.blob1: return 'شكل عضوي 1';
      case KeyShape.blob2: return 'شكل عضوي 2';
      case KeyShape.blob3: return 'شكل عضوي 3';
      case KeyShape.blob4: return 'شكل عضوي 4';
      case KeyShape.blob5: return 'شكل عضوي 5';
      case KeyShape.blobOrganic: return 'شكل عضوي';
      case KeyShape.liquidDrop: return 'قطرة سائلة';
      case KeyShape.splash: return 'رشة';
      case KeyShape.splat: return 'لطخة';
      case KeyShape.ink: return 'حبر';
      case KeyShape.smoke: return 'دخان';
      case KeyShape.flame: return 'لهب';
      case KeyShape.flameSimple: return 'لهب بسيط';
      case KeyShape.flameDouble: return 'لهب مزدوج';
      case KeyShape.sparkleStar: return 'لمعة نجمية';
      case KeyShape.sparkleSimple: return 'لمعة بسيطة';
      case KeyShape.twinkle: return 'وميض';
      case KeyShape.burst: return 'انفجار';
      case KeyShape.spiral: return 'حلزون';
      case KeyShape.spiralTight: return 'حلزون ضيق';
      case KeyShape.swirl: return 'دوّامة';
      case KeyShape.swirlDouble: return 'دوّامة مزدوجة';
      case KeyShape.waveAbstract: return 'موجة تجريدية';
      case KeyShape.ribbonAbstract: return 'شريط تجريدي';
      case KeyShape.ribbonLoop: return 'شريط حلقي';
      case KeyShape.ribbonCurve: return 'شريط منحني';
      case KeyShape.blobRounded: return 'شكل مستدير';
      case KeyShape.blobSquared: return 'شكل مربع';
      case KeyShape.blobHex: return 'شكل سداسي';
      case KeyShape.blobTriangle: return 'شكل مثلثي';

      // Custom
      case KeyShape.customSvg: return 'SVG مخصص';
      case KeyShape.customImage: return 'صورة';
      case KeyShape.customMask: return 'قناع';
      case KeyShape.customPath: return 'مسار';
      case KeyShape.customText: return 'نص';
      case KeyShape.customEmoji: return 'إيموجي';
    }
  }

  /// الفئة
  ShapeCategory get category {
    // Basic
    if (index <= KeyShape.parallelogram.index) {
      return ShapeCategory.basic;
    }
    // Polygons
    if (index <= KeyShape.rhombus.index) {
      return ShapeCategory.polygon;
    }
    // Stars
    if (index <= KeyShape.sparkle.index) {
      return ShapeCategory.star;
    }
    // Arrows
    if (index <= KeyShape.arrowFat.index) {
      return ShapeCategory.arrow;
    }
    // Nature
    if (index <= KeyShape.ladybug.index) {
      return ShapeCategory.nature;
    }
    // Animals
    if (index <= KeyShape.spider.index) {
      return ShapeCategory.animal;
    }
    // Food
    if (index <= KeyShape.popcorn.index) {
      return ShapeCategory.food;
    }
    // Symbols
    if (index <= KeyShape.screwdriver.index) {
      return ShapeCategory.symbol;
    }
    // Tech
    if (index <= KeyShape.power.index) {
      return ShapeCategory.tech;
    }
    // 3D
    if (index <= KeyShape.barrel3D.index) {
      return ShapeCategory.geometric3d;
    }
    // Ornamental
    if (index <= KeyShape.geometricSquare.index) {
      return ShapeCategory.ornamental;
    }
    // Abstract
    if (index <= KeyShape.blobTriangle.index) {
      return ShapeCategory.abstract;
    }
    // Custom
    return ShapeCategory.custom;
  }

  /// هل الشكل يدعم الاستدارة؟
  bool get supportsRoundedness {
    switch (this) {
      case KeyShape.rectangle:
      case KeyShape.roundedRectangle:
      case KeyShape.square:
      case KeyShape.squircle:
        return true;
      default:
        return false;
    }
  }

  /// هل يحتاج رفع ملف؟
  bool get requiresFile {
    return this == KeyShape.customSvg ||
        this == KeyShape.customImage ||
        this == KeyShape.customMask ||
        this == KeyShape.customPath ||
        this == KeyShape.customText ||
        this == KeyShape.customEmoji;
  }

  /// هل هو 3D؟
  bool get is3D => category == ShapeCategory.geometric3d;
}

/// إجمالي عدد الأشكال
class ShapeCount {
  ShapeCount._();

  static int get total => KeyShape.values.length;

  static Map<ShapeCategory, int> get byCategory {
    final map = <ShapeCategory, int>{};
    for (final cat in ShapeCategory.values) {
      map[cat] = KeyShape.values.where((s) => s.category == cat).length;
    }
    return map;
  }
}
