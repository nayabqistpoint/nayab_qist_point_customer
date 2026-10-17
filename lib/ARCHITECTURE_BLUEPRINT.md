# 🏛️ FLUTTER REUSABLE FEATURE ARCHITECTURE BLUEPRINT
> **Core Philosophy:** Self-Contained, Flat, Contract-Driven & Repomix-Optimized Modules.

یہ بلیو پرنٹ اس پروجیکٹ کے ہر آزاد پیج/فیچر کے لیے سنگِ میل کا درجہ رکھتا ہے۔ اس کا بنیادی مقصد یہ ہے کہ ہر فیچر مکمل طور پر خود کفیل (Self-Contained) ہو، تاکہ کسی ایک فیچر پر کام کرتے وقت صرف اسی کے فولڈر کو Repomix کے ذریعے ایکسپورٹ کیا جا سکے بغیر پورے پروجیکٹ کا بوجھ اٹھائے۔

---

## 1. 📂 معیاری آزاد فیچر کا فولڈر اسٹرکچر (Standard Single-Feature Architecture)

ہر آزاد پیج کا فولڈر اسی یکساں اور طے شدہ فارمیٹ کا پابند ہوگا:

```text
lib/customer_side/<feature_name>/
│
├── 📄 <feature_name>_args.dart        <-- ان پٹ اور آؤٹ پٹ کنٹریکٹ (Navigation Contract)
├── 📄 <feature_name>_page.dart        <-- فل اسکرین اسکیفولڈ ویو (Scaffold, App Bar, Lifecycle)
├── 📄 <feature_name>_controller.dart  <-- اسٹیٹ مینیجمنٹ، فارم ویلیڈیشن اور یوزر ایکشنز
│
├── 📁 components/                     <-- صرف اور صرف اسی پیج کے UI کے ذیلی وزٹس
│   ├── 📄 <feature>_header_card_ui.dart
│   ├── 📄 <feature>_item_tile_ui.dart
│   ├── 📄 <feature>_filter_bar_ui.dart
│   └── 📄 <feature>_empty_state_ui.dart
│
└── 📁 services/                       <-- پیج کی کاروباری لاجک، ہائیو ریڈ/رائٹ اور پے لوڈز
    ├── 📄 <feature>_service.dart      <-- ڈیٹا فیچنگ اور بنیادی بزنس لاجک
    ├── 📄 <feature>_storage_handler.dart <-- ہائیو لسنرز، بیچ رائٹ اور سنک ٹرگرز
    └── 📁 payload_builders/           <-- (اختیاری) اگر فائر بیس/ہائیو کے پیچیدہ پے لوڈز ہوں
        └── 📄 <feature>_box_builder.dart