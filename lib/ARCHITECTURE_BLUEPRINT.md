================================================================================
                    FLUTTER REUSABLE FEATURE ARCHITECTURE
================================================================================

1. گلوبل لیول انفراسٹرکچر (Global Infrastructure):
lib/
├── core/
│   └── services/
│       ├── core_services.dart           <-- (بیرل فائل: کیمرہ، آڈیو، زوم، پرمیشن)
│       ├── app_permission_service.dart
│       ├── audio_service.dart
│       ├── local_media_helper.dart
│       ├── media_picker_service.dart
│       └── zoom_handler.dart
├── customer_side/
│   ├── hive_services/
│   │   └── hive_box_manager.dart        <-- (صرف لوکل ڈسک، سیف اوپن اور بیچ رائٹ)
│   └── sync/
│       └── master_sync_hub.dart         <-- (نیٹ ورک سنک، پش، پل، کلاؤڈینیری)


2. اسٹینڈرڈ مین فیچر ٹیمپلیٹ (بمعہ خود مختار سب ویوز):
lib/customer_side/<feature_name>/
│
├── 📄 <feature>_args.dart               <-- آنے والے پیرامیٹرز اور واپسی کا رزلٹ (Navigation Contract)
├── 📄 <feature>_page.dart               <-- مین ویو اور فریم (Scaffold, App Bar, Tabs)
├── 📄 <feature>_controller.dart         <-- اسٹیٹ مینیجمنٹ، ٹیب انڈیکس، یوزر ایکشنز
│
├── 📁 components/                       <-- صرف اس مین پیج کے شیئرڈ UI وزٹس
│   ├── 📄 <feature>_header_card_ui.dart
│   └── 📄 <feature>_action_bar_ui.dart
│
├── 📁 services/                         (اختیاری: اگر مین پیج پر ڈیٹا یا لاجک ہو)
│   ├── 📄 <feature>_calculation_service.dart
│   ├── 📄 <feature>_payload_service.dart
│   └── 📄 <feature>_storage_handler.dart <-- ہائیو بیچ رائٹ اور سنک ٹریگر
│
└── 📁 subviews/                         (اختیاری: اگر پیج میں پیچیدہ ٹیبز ہوں)
    └── 📁 <subview_name>_subview/       <-- ہر سب ویو خود ایک مکمل مائیکرو فیچر ہے
        ├── 📄 <subview>_args.dart       (اگر سب ویو آزاد شیٹ یا ڈائیلاگ کے طور پر کھلے)
        ├── 📄 <subview>_ui.dart         (سب ویو کا اصل ویو/ٹیب مواد)
        ├── 📄 <subview>_controller.dart (سب ویو کی اندرونی اسٹیٹ اور فارم ویلیڈیشن)
        ├── 📁 components/               (سب ویو کے اپنے چھوٹے کارڈز اور ٹیبلز)
        │   └── 📄 <subview>_item_tile_ui.dart
        └── 📁 services/                 (سب ویو کی اپنی کاروباری لاجک اور سیونگ)
            ├── 📄 <subview>_calc_service.dart
            ├── 📄 <subview>_payload_service.dart
            └── 📄 <subview>_storage_handler.dart


3. اسٹینڈرڈ سادہ پیج ٹیمپلیٹ (جہاں سب ویوز نہ ہوں، جیسے لاگ ان یا پیمنٹ):
lib/customer_side/<simple_feature>/
│
├── 📄 <simple_feature>_args.dart
├── 📄 <simple_feature>_page.dart
├── 📄 <simple_feature>_controller.dart
├── 📁 components/
│   ├── 📄 <component_1>_ui.dart
│   └── 📄 <component_2>_ui.dart
└── 📁 services/
    ├── 📄 <simple_feature>_calculation_service.dart
    ├── 📄 <simple_feature>_payload_service.dart
    └── 📄 <simple_feature>_storage_handler.dart
================================================================================