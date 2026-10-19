import 'package:nayab_qist_point_customer/customer_side/auth/services/signup_payload_service.dart';
import 'package:nayab_qist_point_customer/customer_side/login/services/login_payload_service.dart';

class BenchmarkPageSchema {
  final String id;
  final String title;
  final String featureFolder;
  final List<String> targetBoxes;
  final Map<String, dynamic> Function() samplePayload;

  const BenchmarkPageSchema({
    required this.id,
    required this.title,
    required this.featureFolder,
    required this.targetBoxes,
    required this.samplePayload,
  });
}

class BenchmarkBoxMetadata {
  final String boxName;
  final String purpose;
  final List<String> writablePages;
  final List<String> primaryKeys;

  const BenchmarkBoxMetadata({
    required this.boxName,
    required this.purpose,
    required this.writablePages,
    required this.primaryKeys,
  });
}

class BenchmarkRegistryService {
  BenchmarkRegistryService._();

  static List<BenchmarkPageSchema> getRegisteredPages() {
    return [
      BenchmarkPageSchema(
        id: 'AUTH_SIGNUP',
        title: '1. کسٹمر سائن اپ سروس',
        featureFolder: 'customer_side/auth',
        targetBoxes: ['customerBox', 'guarantorBox', 'mediaBox', 'usersBox'],
        samplePayload: () => SignupPayloadService.getBenchmarkPayload(),
      ),
      BenchmarkPageSchema(
        id: 'AUTH_LOGIN',
        title: '2. لاگ ان سیشن سروس',
        featureFolder: 'customer_side/login',
        targetBoxes: ['settingsBox'],
        samplePayload: () => LoginPayloadService.getBenchmarkPayload(),
      ),
      BenchmarkPageSchema(
        id: 'CUSTOMER_PURCHASE_ORDER',
        title: '3. کسٹمر موبائل خریداری آرڈر (Order Receipt)',
        featureFolder: 'customer_side/order_receipt_page',
        targetBoxes: ['installmentsBox', 'customerBox', 'transactionBox'],
        samplePayload: () => {
          'orderId': 'ORD-2026-991',
          'customerPhone': '03001234567',
          'productInfo': {
            'model': 'Infinix Note 40 Pro',
            'imeiList': ['358921102938471'],
            'color': 'Vintage Green',
          },
          'pricing': {
            'totalCashPrice': 62000,
            'installmentPlanMonths': 10,
            'profitRatePercent': 35.0,
            'finalInstallmentPrice': 75600,
            'advancePayment': 10000,
            'monthlyAmount': 6560,
          },
          'approvalStatus': 'PENDING_ADMIN_VERIFICATION',
        },
      ),
      BenchmarkPageSchema(
        id: 'SHOP_STOCK_ENTRY',
        title: '4. دکان موبائل اسٹاک داخلہ سروس',
        featureFolder: 'features/stock_entry',
        targetBoxes: ['stockBox'],
        samplePayload: () => {
          'stockId': 'STK-8821',
          'model': 'Vivo V30 5G',
          'imei': '863920192837482',
          'purchaseCost': 82000,
          'cashSalePrice': 94000,
          'defaultPlanMonths': 12,
          'isAvailable': true,
          'entryDate': DateTime.now().toIso8601String(),
        },
      ),
      BenchmarkPageSchema(
        id: 'TRANSFER_INSTALLMENT',
        title: '5. نقد ایڈوانس سے قسط منتقلی',
        featureFolder: 'features/transfer_to_installment',
        targetBoxes: ['transactionBox', 'installmentsBox', 'customerBox'],
        samplePayload: () => {
          'transactionBox': {
            'docId': 'TX-TRANSFER-SAMPLE',
            'customerPhone': '03001234567',
            'txType': 'TRANSFER_TO_INSTALLMENT',
            'amount': 5000,
            'type': 'DEBIT',
            'status': 'APPROVED',
          },
          'installmentsBox': {
            'installments': [
              {
                'installmentNo': 1,
                'dueAmount': 5000,
                'paidAmount': 5000,
                'remainingAmount': 0,
                'status': 'PAID',
              }
            ],
            'lastAdjustmentNote': 'نقد کھاتے سے قسط میں ایڈجسٹمنٹ',
          },
        },
      ),
      BenchmarkPageSchema(
        id: 'UNIVERSAL_PAYMENT',
        title: '6. یونیورسل ادائیگی رسید سروس',
        featureFolder: 'features/universal_payment_feature',
        targetBoxes: ['transactionBox', 'installmentsBox'],
        samplePayload: () => {
          'receiptNo': 'REC-8841',
          'targetPayable': 7500,
          'paid': 7500,
          'discount': 0,
          'splits': [
            {'source': 'JazzCash', 'amount': 7500}
          ],
          'note': 'آن لائن قسط جمع رسید',
          'hasPhoto': false,
          'hasAudio': false,
        },
      ),
      BenchmarkPageSchema(
        id: 'GROCERY_EXPENSE_ENTRY',
        title: '7. کریانہ / گھریلو سامان ادھار کلیم',
        featureFolder: 'features/grocery_entry',
        targetBoxes: ['transactionBox', 'customerBox'],
        samplePayload: () => {
          'claimId': 'CLM-1029',
          'title': 'ماہانہ راشن اندراج',
          'totalAmount': 8500,
          'txType': 'GROCERY_EXPENSE',
          'items': [
            {'name': 'گھی 5 کلو', 'price': 2850},
            {'name': 'آٹا 20 کلو', 'price': 2100},
          ],
          'verificationStatus': 'VERIFIED',
        },
      ),
    ];
  }

  static List<BenchmarkBoxMetadata> getBoxesMetadata() {
    return const [
      BenchmarkBoxMetadata(
        boxName: 'settingsBox',
        purpose: 'فعال یوزر سیشن، ریممبر می اور ڈیوائس ترجیحات',
        writablePages: ['Login', 'Logout'],
        primaryKeys: ['activePhone', 'isLoggedIn', 'is_remember_me'],
      ),
      BenchmarkBoxMetadata(
        boxName: 'usersBox',
        purpose: 'صارفین کی تصدیق شدہ اسناد، پن کوڈ اور منظوری اسٹیٹس',
        writablePages: ['Signup', 'AdminApproval'],
        primaryKeys: ['phone', 'pin', 'status', 'createdAt'],
      ),
      BenchmarkBoxMetadata(
        boxName: 'stockBox',
        purpose: 'دکان پر موجود اور بک شدہ موبائل فونز کا اسٹاک ریکارڈ',
        writablePages: ['StockEntry', 'OrderReceipt'],
        primaryKeys: ['model', 'imei', 'cashPrice', 'isAvailable'],
      ),
      BenchmarkBoxMetadata(
        boxName: 'appConfigBox',
        purpose: 'دکان کے تصدیق شدہ بینکس، ادائیگی چینلز اور کنفیگریشن',
        writablePages: ['GlobalSync'],
        primaryKeys: ['banks_config', 'discounts_config'],
      ),
      BenchmarkBoxMetadata(
        boxName: 'customerBox',
        purpose: 'کسٹمر کا بنیادی پروفائل، کیش لون بیلنس اور مجموعی بقایا',
        writablePages: ['Signup', 'TransferToInstallment', 'OrderReceipt', 'GroceryEntry'],
        primaryKeys: ['customerPhone', 'cashLoanBalance', 'installmentDueBalance', 'grandNetTotal'],
      ),
      BenchmarkBoxMetadata(
        boxName: 'guarantorBox',
        purpose: 'کسٹمر کے ضامن (گارنٹر) کا ریکارڈ، نام، شناختی کارڈ اور رابطہ',
        writablePages: ['Signup'],
        primaryKeys: ['guarantorPhone', 'guarantorName', 'guarantorCnic', 'relation'],
      ),
      BenchmarkBoxMetadata(
        boxName: 'mediaBox',
        purpose: 'کسٹمر و ضامن کے شناختی کارڈ کی تصاویر اور معاہدہ کی صوتی ریکارڈنگ',
        writablePages: ['Signup'],
        primaryKeys: ['cnicFront', 'cnicBack', 'selfie', 'audioContractPath'],
      ),
      BenchmarkBoxMetadata(
        boxName: 'installmentsBox',
        purpose: 'فعال موبائلز کے اقساط شیڈولز، واٹرفال ادائیگیاں اور بقایا جات',
        writablePages: ['OrderReceipt', 'TransferToInstallment', 'UniversalPayment'],
        primaryKeys: ['docId', 'customerPhone', 'installments', 'monthlyAmount', 'status'],
      ),
      BenchmarkBoxMetadata(
        boxName: 'transactionBox',
        purpose: 'تمام مالی واؤچرز، رسیدیں، اور نقد لین دین کی ہسٹری',
        writablePages: ['UniversalPayment', 'TransferToInstallment', 'OrderReceipt', 'GroceryEntry'],
        primaryKeys: ['docId', 'txId', 'customerPhone', 'amount', 'type', 'status'],
      ),
    ];
  }
}