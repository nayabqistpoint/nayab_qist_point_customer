import '../../payload_services/signup_payload_service.dart';
import '../../payload_services/login_payload_service.dart';

class BenchmarkModule {
  final String id;
  final String title;
  final String serviceClass;
  final Map<String, dynamic> Function() payloadBuilder;

  BenchmarkModule({
    required this.id,
    required this.title,
    required this.serviceClass,
    required this.payloadBuilder,
  });
}

class BenchmarkRegistryService {
  static List<BenchmarkModule> getModules() => [
        BenchmarkModule(
          id: 'AUTH_SIGNUP',
          title: '1. کسٹمر سائن اپ سروس',
          serviceClass: 'SignupPayloadService',
          payloadBuilder: () => SignupPayloadService.getBenchmarkPayload(),
        ),
        BenchmarkModule(
          id: 'AUTH_LOGIN',
          title: '2. لاگ ان سیشن سروس',
          serviceClass: 'LoginPayloadService',
          payloadBuilder: () => LoginPayloadService.getBenchmarkPayload(),
        ),
        BenchmarkModule(
          id: 'PURCHASE_ORDER',
          title: '3. اقساط خریداری سروس',
          serviceClass: 'PurchaseOrderPayloadService',
          payloadBuilder: () => {
            'orderId': 'ORD-2026-991',
            'customerId': 'CUST-0042',
            'productInfo': {
              'model': 'Infinix Note 40 Pro',
              'imeiList': ['358921102938471', '358921102938472'],
              'color': 'Vintage Green',
            },
            'pricing': {
              'totalCashPrice': 62000,
              'installmentPlanMonths': 10,
              'profitRatePercent': 35.0,
              'finalInstallmentPrice': 75600,
              'advancePayment': 0,
              'monthlyAmount': 7560,
            },
            'scheduleSummary': [
              {'installmentNo': 1, 'dueDate': '2026-10-10', 'amount': 7560, 'status': 'DUE'},
              {'installmentNo': 2, 'dueDate': '2026-11-10', 'amount': 7560, 'status': 'UPCOMING'},
            ],
            'approvalStatus': 'PENDING_ADMIN_VERIFICATION',
          },
        ),
        BenchmarkModule(
          id: 'PAYMENT_TRANSACTION',
          title: '4. قسط و کیش ادائیگی سروس',
          serviceClass: 'InstallmentPaymentPayloadService',
          payloadBuilder: () => {
            'receiptNo': 'REC-8841',
            'customerId': 'CUST-0042',
            'targetCategory': 'INSTALLMENT',
            'paymentBreakdown': {
              'targetAccount': 'Infinix Note 40 Pro',
              'installmentIndex': 4,
              'dueAmount': 7560,
              'paidAmount': 7560,
              'discount': 0,
            },
            'paymentTime': DateTime.now().toIso8601String(),
            'isSyncedToHive': true,
          },
        ),
        BenchmarkModule(
          id: 'EXPENSE_SERVICE',
          title: '5. راشن / خرچہ کلیم سروس',
          serviceClass: 'ServiceExpensePayloadService',
          payloadBuilder: () => {
            'claimId': 'CLM-1029',
            'title': 'ماہانہ کریانہ راشن کلیم',
            'totalClaimAmount': 4350.0,
            'linkedLedger': 'قسط کھاتہ: Infinix Note 40 Pro',
            'itemsList': [
              {'name': 'چینی (10 کلو)', 'qty': 10, 'rate': 150, 'total': 1500.0},
              {'name': 'گھی کا ڈبہ (5 لیٹر)', 'qty': 1, 'rate': 2850, 'total': 2850.0},
            ],
            'verificationStatus': 'VERIFIED_BY_BRANCH_MANAGER',
          },
        ),
      ];
}