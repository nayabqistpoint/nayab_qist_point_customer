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
        id: 'TRANSFER_INSTALLMENT',
        title: '3. نقد ایڈوانس سے قسط منتقلی',
        featureFolder: 'features/transfer_to_installment',
        targetBoxes: ['transactionBox', 'installmentsBox', 'customerBox'],
        samplePayload: () => {
          'transactionBox': {
            'docId': 'TX-TRANSFER-SAMPLE',
            'customerPhone': '03001234567',
            'txType': 'TRANSFER_TO_INSTALLMENT',
            'amount': 5000,
            'type': 'DEBIT',
            'status': 'PENDING',
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
        title: '4. یونیورسل ادائیگی رسید سروس',
        featureFolder: 'features/universal_payment_feature',
        targetBoxes: ['transactionBox', 'installmentsBox'],
        samplePayload: () => {
          'targetPayable': 7500,
          'paid': 7500,
          'discount': 0,
          'splits': [
            {'source': 'JazzCash', 'amount': 7500}
          ],
          'note': 'آن لائن قسط ڈپازٹ',
          'hasPhoto': false,
          'hasAudio': false,
        },
      ),
      BenchmarkPageSchema(
        id: 'STOCK_ENTRY',
        title: '5. موبائل و اسٹاک پرچیز سروس',
        featureFolder: 'features/stock_entry',
        targetBoxes: ['stockBox', 'transactionBox', 'customerBox'],
        samplePayload: () => {
          'itemName': 'Infinix Note 40 Pro',
          'imeiList': ['358921102938471'],
          'totalMonths': 10,
          'monthlyAmount': 7560,
          'totalContract': 75600,
          'status': 'PENDING',
        },
      ),
      BenchmarkPageSchema(
        id: 'GROCERY_ENTRY',
        title: '6. کریانہ / گھریلو سامان ادھار سروس',
        featureFolder: 'features/grocery_entry',
        targetBoxes: ['transactionBox', 'customerBox'],
        samplePayload: () => {
          'title': 'ماہانہ راشن اندراج',
          'totalAmount': 8500,
          'txType': 'GROCERY_EXPENSE',
          'items': [
            {'name': 'گھی 5 کلو', 'price': 2850},
            {'name': 'آٹا 20 کلو', 'price': 2100},
          ],
        },
      ),
    ];
  }

  static List<BenchmarkBoxMetadata> getBoxesMetadata() {
    return const [
      BenchmarkBoxMetadata(
        boxName: 'customerBox',
        purpose: 'کسٹمر کا بنیادی پروفائل، کیش ادھار بیلنس اور اقساط کا کل بقایا',
        writablePages: ['Signup', 'TransferToInstallment', 'StockEntry', 'GroceryEntry'],
        primaryKeys: ['customerPhone', 'cashLoanBalance', 'installmentDueBalance', 'grandNetTotal'],
      ),
      BenchmarkBoxMetadata(
        boxName: 'installmentsBox',
        purpose: 'تمام فعال اور مکمل موبائلز کے اقساط شیڈولز اور واٹرفال ادائیگیاں',
        writablePages: ['StockEntry', 'TransferToInstallment', 'UniversalPayment'],
        primaryKeys: ['docId', 'customerPhone', 'installments', 'monthlyAmount', 'status'],
      ),
      BenchmarkBoxMetadata(
        boxName: 'transactionBox',
        purpose: 'تمام مالی رسیدیں، اسپلٹ اکاؤنٹس، اور تاریخی ٹرانزیکشن واؤچرز',
        writablePages: ['UniversalPayment', 'TransferToInstallment', 'StockEntry', 'GroceryEntry'],
        primaryKeys: ['docId', 'txId', 'customerPhone', 'amount', 'type', 'verificationStatus'],
      ),
      BenchmarkBoxMetadata(
        boxName: 'stockBox',
        purpose: 'دکان پر دستیاب اور بک شدہ موبائلز اور ڈیوائسز کا ریکارڈ',
        writablePages: ['StockEntry', 'DevicePlanDetail'],
        primaryKeys: ['model', 'cashPrice', 'installmentMonths', 'isAvailable'],
      ),
      BenchmarkBoxMetadata(
        boxName: 'settingsBox',
        purpose: 'فعال یوزر سیشن، ریممبر می اور ڈیوائس پریفرنسز',
        writablePages: ['Login', 'Logout'],
        primaryKeys: ['activePhone', 'isLoggedIn', 'is_remember_me'],
      ),
      BenchmarkBoxMetadata(
        boxName: 'appConfigBox',
        purpose: 'دکان کے تصدیق شدہ بینکس، ادائیگی سورسز اور ڈسکاؤنٹ کیٹیگریز',
        writablePages: ['GlobalSync'],
        primaryKeys: ['banks_config', 'discounts_config'],
      ),
    ];
  }
}