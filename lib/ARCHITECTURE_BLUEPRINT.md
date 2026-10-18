# 🏛️ FLUTTER REUSABLE FEATURE ARCHITECTURE BLUEPRINT
> **Core Mandate:** Self-Contained, Flat, Batch-Safe, Modular & Repomix-Optimized Standard Architecture.

یہ دستاویز اس پروجیکٹ کے ہر نئے بننے والے یا ری فیکٹر ہونے والے پیج/فیچر کا حتمی آئین (Standard Specification) ہے۔ جب بھی کسی فیچر پر کام کرنا ہو، AI اس مکمل گائیڈ کے مطابق ہی فائلیں بنائے گا، امپورٹس جوڑے گا اور کوڈ کا سائز ہلکا رکھے گا۔

---

## 1. 📂 معیاری ڈائریکٹری اسٹرکچر (Standard Directory Structure)

lib/customer_side/<feature_name>/
│
├── 📄 <feature>_args.dart              <-- [لازمی] روٹ سے ڈیٹا لانا اور واپس بھیجنا (Navigation Contract)
├── 📄 <feature>_page.dart              <-- [لازمی] فل اسکرین ویو فریم ورک (Scaffold, AppBar, UI Tree)
├── 📄 <feature>_controller.dart        <-- [لازمی] اسٹیٹ، فارم ویلیڈیشن اور یوزر ایکشنز (ChangeNotifier)
│
├── 📁 components/                     <-- [لازمی فولڈر] صرف اسی پیج کے اپنے خالص UI وزٹس
│   ├── 📄 <feature>_header_card_ui.dart        <-- [لازمی / ضرورت کے مطابق]
│   ├── 📄 <feature>_input_card_ui.dart         <-- [اختیاری: اگر فارم ان پٹ ہو]
│   ├── 📄 <feature>_table_ui.dart              <-- [اختیاری: اگر ٹیبل ڈیٹا ہو]
│   └── 📄 <feature>_bottom_action_bar_ui.dart  <-- [اختیاری: اگر فکسڈ باٹم بار ہو]
│
└── 📁 services/                       <-- [لازمی فولڈر] کاروباری لاجک، ہائیو سیونگ اور پے لوڈز
    ├── 📄 <feature>_storage_handler.dart       <-- [لازمی] ہائیو کا واحد رابطہ (Safe Read, Listen & WriteBatch)
    ├── 📄 <feature>_payload_service.dart       <-- [اختیاری: اگر ہائیو/کلاؤڈ میں ڈیٹا سیو ہونا ہو]
    ├── 📄 <feature>_calculation_service.dart   <-- [اختیاری: اگر ریاضیاتی فارمولے یا فلٹرز ہوں]
    └── 📁 payload_builders/                   <-- [اختیاری: اگر ایک سے زائد ہائیو باکسز میں رائٹ ہو]
        ├── 📄 <feature>_customer_box_builder.dart
        ├── 📄 <feature>_transaction_box_builder.dart
        └── 📄 <feature>_installments_box_builder.dart

---

## 2. ⚡ ڈیٹا سیونگ اور فنکشن کال پائپ لائن (Execution Flow)

ڈیٹا کے بننے اور کلاؤڈ تک جانے کا راستہ ہمیشہ یک طرفہ (One-Way Pipeline) ہوگا:

[یوزر ایکشن / فارم سبمٹ]
           │
           ▼
[<feature>_page.dart]
           │  (UI بٹن پریس ہوا)
           ▼
[<feature>_controller.dart]
           │  (فارم ڈیٹا ویلیڈیٹ کیا)
           ▼
[<feature>_storage_handler.dart]
           │
           ├───► [<feature>_payload_service.dart]
           │               │
           │               └───► [payload_builders/]  (کسٹمر، ٹرانزیکشن، قسط کے پے لوڈز تیار ہوئے)
           │
           │  (تیار شدہ مکمل Map پے لوڈز واپس ملے)
           ▼
[HiveBoxManager.writeBatch(payloads)] ───► تمام ہائیو باکسز میں بیک وقت محفوظ (Atomic Batch)
           │
           ▼
[MasterSyncHub.triggerSync()] ───────────► فائر بیس / کلاؤڈینیری پر آٹومیٹک پش سنک ٹرگر

---

## 3. 🔗 امپورٹس کا سخت ڈائریکشن گراف (Strict Import & Dependency Rules)

کسی بھی فائل میں امپورٹس کا بہاؤ الٹا یا بائی پاس نہیں ہونا چاہیے:

┌─────────────────────────────────┐
│       <feature>_page.dart       │  ◄── imports: controller.dart, components/, args.dart
└────────────────┬────────────────┘
                 │
                 ▼
┌─────────────────────────────────┐
│    <feature>_controller.dart    │  ◄── imports: storage_handler.dart, args.dart, calculation_service.dart
└────────────────┬────────────────┘      (🚫 NO Hive, NO Builders, NO Widgets)
                 │
                 ▼
┌─────────────────────────────────┐
│   <feature>_storage_handler.dart│  ◄── imports: HiveBoxManager, payload_service.dart
└────────────────┬────────────────┘      (🚫 NO UI Widgets, NO Controllers)
                 │
                 ▼
┌─────────────────────────────────┐
│   <feature>_payload_service.dart│  ◄── imports: payload_builders/
└────────────────┬────────────────┘      (🚫 NO Hive, NO UI Widgets)
                 │
                 ▼
┌─────────────────────────────────┐
│        payload_builders/        │  ◄── خالص Map<String, dynamic> تیار کریں گے
└─────────────────────────────────┘      (🚫 NO Hive, NO External Services)

### 🚫 کیا سختی سے منع ہے؟ (Strictly Forbidden Rules)
1. کنٹرولر میں ہائیو کا براہِ راست استعمال ممنوع: controller.dart کے اندر کبھی بھی HiveBoxManager یا Hive.box() امپورٹ نہیں ہوگا۔ سارا ڈیٹا اور لسنرز صرف storage_handler.dart کے گیٹرز کے ذریعے آئیں گے۔
2. اسٹوریج ہینڈلر میں UI وزٹس ممنوع: storage_handler.dart میں package:flutter/material.dart کا کوئی وزٹ کوڈ نہیں ہوگا، صرف ڈیٹا اور فیوچرز ہوں گے۔
3. بلڈرز کا خود مختار ہونا لازمی: payload_builders/ کے اندر نہ ہائیو امپورٹ ہوگا اور نہ ہی کوئی اور سروس؛ ان کا واحد کام را ڈیٹا لے کر فائر اسٹور/ہائیو فارمیٹ کا میپ لوٹانا ہے۔
4. کراس فیچر ڈائریکٹ امپورٹ ممنوع: ایک فیچر دوسرے فیچر کے کمپوننٹ یا کنٹرولر کو براہِ راست امپورٹ نہیں کرے گا۔ سارا کراس فیچر رابطہ AppRoutes اور Navigator.pushNamed کے ذریعے ہوگا۔

---

## 4. 👂 لائیو ڈیٹا سننے کا طریقہ (Reactive Hive Listening Rule)

جب بھی اسکرین پر کلاؤڈ یا ہائیو کے ڈیٹا کو ری ایکٹیو اور آٹومیٹک اپ ڈیٹ رکھنا ہو:

1. اسٹوریج ہینڈلر (storage_handler.dart):
   static ValueListenable<Box>? get boxListenable =>
       HiveBoxManager.isBoxOpen(HiveBoxManager.customerBoxName)
           ? Hive.box(HiveBoxManager.customerBoxName).listenable()
           : null;

2. کنٹرولر (controller.dart):
   ValueListenable<Box>? get boxListenable => FeatureStorageHandler.boxListenable;

3. پیج (page.dart):
   ValueListenableBuilder<Box>(
     valueListenable: controller.boxListenable,
     builder: (context, box, _) {
       controller.loadData();
       return MyUiComponent(...);
     },
   );

---

## 5. 📜 فائلوں کے فرائض اور چیک لسٹ (File Roles Matrix)

| فائل کی قسم | حیثیت | اصل ذمہ داری | کیا نہیں کرنا؟ |
| :--- | :---: | :--- | :--- |
| *_args.dart | لازمی | روٹ پیرامیٹرز سنبھالنا، toMap اور fromMap۔ | کوئی UI وزٹ یا ہائیو سروس امپورٹ نہ ہو۔ |
| *_page.dart | لازمی | اسکرین اسکیفولڈ، ایپ بار، اور لسن ایبل بلڈرز لگانا۔ | بزنس لاجک یا براہِ راست ڈیٹا بیس کیوری نہ چلائے۔ |
| *_controller.dart | لازمی | اسکرین کی حالت (State)، لوڈنگ فلیگ، اور یوزر ایونٹس ہینڈل کرنا۔ | براہ راست ہائیو باکس میں رائٹ نہ کرے۔ |
| components/ | لازمی | کنٹرولر سے آنے والی ویلیوز کو کارڈز اور ٹیبلز میں دکھانا۔ | اس میں کوئی آزاد نیٹ ورک کال یا ہائیو کیوری نہ ہو۔ |
| storage_handler.dart | لازمی | ہائیو باکس کو سیفلی کھولنا، لسنر دینا، اور بیچ رائٹ کروانا۔ | اس میں کوئی Flutter UI کوڈ نہ ہو۔ |
| payload_service.dart | اختیاری | مختلف باکسز کے پے لوڈز کو جمع کر کے ہینڈلر کو دینا۔ | خود ہائیو میں رائٹ نہ کرے۔ |
| payload_builders/ | اختیاری | را ڈیٹا کو فائر اسٹور/ہائیو کے مخصوص فارمیٹ میں تبدیل کرنا۔ | خود ڈیٹا سیو نہ کرے، صرف میپ واپس کرے۔ |
| calculation_service.dart | اختیاری | خالص ریاضیاتی حساب، تاریخ کی تبدیلی اور فلٹرز۔ | اسٹیٹ مینیجمنٹ نہ کرے۔ |

---

## 6. 🚀 ماڈیولر صفائی اور کارکردگی کے سنہری اصول (Clean Code & Performance Mandates)

1. سنگل رسپانسبلٹی اور مختصر فائلیں (Single Responsibility & 150-200 Lines Limit):
   - کوئی بھی کمپوننٹ، سروس یا کنٹرولر فائل 150 سے 200 لائنوں سے بڑی نہیں ہونی چاہیے۔
   - بڑی فائلز کو چھوٹے کمپوننٹس میں توڑیں تاکہ بگ فکس کرتے وقت صرف مخصوص فائل تبدیل ہو اور باقی سسٹم محفوظ رہے۔
2. غیر متحرک وزٹس پر const کا لازمی استعمال (Zero Lag UI):
   - کمپوننٹس کے اندر تمام اسٹیٹک ویلیوز، ٹیکسٹ، آئیکنز، پیڈنگز اور بارڈرز پر `const` لگانا لازمی ہے تاکہ 60/120 FPS پر بغیر جِٹر اسکرولنگ ملے۔
3. سروسز میں پیور اسٹیٹک فنکشنز (Pure Static Utility Functions):
   - calculation_service اور payload_builders کو ہمیشہ اسٹیٹک میتھڈز کے ساتھ بنائیں تاکہ میموری میں اضافی آبجیکٹس نہ بنیں اور میموری لیکس کا خطرہ صفر رہے۔
4. ہلکا پھلکا کنٹرولر (Slim Controller Pattern):
   - کنٹرولر میں صرف اسکرین اسٹیٹ اور سروس کالز ہوں گی۔ کنٹرولر کے اندر لمبے چوڑے فارمولے یا پے لوڈ میپس بنانا سختی سے منع ہے۔

---

## 7. 🤖 AI اور ریپو مکس گائیڈ لائن (Repomix Context Directive)

جب بھی اس پروجیکٹ کے کسی فیچر پر کام کرنا ہو، ڈویلپر صرف اسی فیچر کا فولڈر ایکسپورٹ کرے گا:
npx repomix --include "lib/customer_side/<feature_name>/**"

AI کے لیے لازمی ہدایات:
- اس بلیو پرنٹ کے قوانین کو 100 فیصد فالو کرنا ہے۔
- کوئی بھی غیر ضروری فائل ڈائریکٹری سے باہر نہیں بنانی۔
- امپورٹس کا رخ ہمیشہ UI ➔ Controller ➔ StorageHandler ➔ PayloadService ➔ HiveBoxManager رہے گا۔
- کوڈ ہمیشہ مکمل (Full Complete Code) فراہم کرنا ہے، ٹکڑوں یا ادھورے سنپٹس میں کوڈ نہیں دینا۔