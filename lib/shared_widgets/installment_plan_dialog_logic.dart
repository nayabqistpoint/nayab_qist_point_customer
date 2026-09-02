import 'package:hive_flutter/hive_flutter.dart';

class InstallmentRowModel {
  final String label;
  final String day;
  final String monthText;
  final String year;
  final String due;
  final String paid;
  final String short;
  final double progress;
  final bool isOverdue;
  final double amountToPay;

  const InstallmentRowModel({
    required this.label,
    required this.day,
    required this.monthText,
    required this.year,
    required this.due,
    required this.paid,
    required this.short,
    required this.progress,
    required this.isOverdue,
    required this.amountToPay,
  });
}

class InstallmentTableDataModel {
  final String mobileName;
  final String packageName;
  final double totalPrice;
  final double totalOverdueShort;
  final bool isApproved;
  final List<InstallmentRowModel> rows;

  const InstallmentTableDataModel({
    required this.mobileName,
    required this.packageName,
    required this.totalPrice,
    required this.totalOverdueShort,
    required this.isApproved,
    required this.rows,
  });
}

class InstallmentPlanDialogLogic {
  static String getUrduMonth(int month) {
    const months = [
      'جنوری', 'فروری', 'مارچ', 'اپریل', 'مئی', 'جون',
      'جولائی', 'اگست', 'ستمبر', 'اکتوبر', 'نومبر', 'دسمبر'
    ];
    return months[(month - 1) % 12];
  }

  static String sanitizePhone(String phone) {
    return phone.replaceAll(RegExp(r'[^0-9]'), '').trim();
  }

  static double calculateTotalShort(String customerPhone) {
    try {
      if (!Hive.isBoxOpen('packageBox') || !Hive.isBoxOpen('transactionBox')) return 0.0;
      final packageBox = Hive.box('packageBox');
      final transactionBox = Hive.box('transactionBox');

      final data = processInstallmentData(
        customerPhone: customerPhone,
        packageBox: packageBox,
        transactionBox: transactionBox,
      );

      return data?.totalOverdueShort ?? 0.0;
    } catch (_) {
      return 0.0;
    }
  }

  static InstallmentTableDataModel? processInstallmentData({
    required String customerPhone,
    required Box packageBox,
    required Box transactionBox,
  }) {
    final String cleanPhone = sanitizePhone(customerPhone);
    if (cleanPhone.isEmpty) return null;

    // 🎯 ۱۔ کسٹمر کا پے لوڈ (پیکیج) تلاش کرنا (فون نمبر، docId، کی یا اندرونی فیلڈز سے)
    dynamic rawData = packageBox.get(cleanPhone);
    if (rawData == null) {
      for (var key in packageBox.keys) {
        final val = packageBox.get(key);
        if (val is Map) {
          final p = sanitizePhone((val['customerPhone'] ?? val['customerId'] ?? val['phone'] ?? val['docId'] ?? key).toString());
          if (p == cleanPhone) {
            rawData = val;
            break;
          }
        }
      }
    }

    if (rawData == null || rawData is! Map) return null;

    final data = Map<String, dynamic>.from(rawData);

    // 🎯 ۲۔ پیکیج کا اسٹیٹس چیک (یکساں فارمیٹنگ اور ٹرم کے ساتھ)
    String rawStatus = (data['status'] ?? data['pkgStatus'] ?? 'pending').toString().toLowerCase().trim();
    bool isApproved = rawStatus == 'approved';

    String mobileName = data['mobileName'] ?? 'موبائل';
    String packageName = (data['packageName'] ?? '').toString().toUpperCase().trim();
    double monthlyInstallment = double.tryParse(data['monthlyInstallment'].toString()) ?? 0.0;
    double advanceAmount = double.tryParse(data['advanceAmount'].toString()) ?? 0.0;
    double totalPrice = double.tryParse(data['totalPrice'].toString()) ?? 0.0;

    int totalMonths = 6;
    bool isAdvanceType = packageName.contains('A');
    RegExp regExp = RegExp(r'(\d+)');
    var match = regExp.firstMatch(packageName);
    if (match != null) totalMonths = int.tryParse(match.group(1)!) ?? 6;

    String dateStr = (data['createdAt'] ?? data['timestamp'] ?? '').toString();
    DateTime purchaseDate = DateTime.tryParse(dateStr) ?? DateTime.now();
    DateTime now = DateTime.now();

    // 🎯 ۳۔ ٹرانزیکشن باکس سے صرف Approved اور Green رقم کا مجموعہ حساب کرنا
    double totalPaidPool = 0.0;
    for (var txKey in transactionBox.keys) {
      final rawTx = transactionBox.get(txKey);
      if (rawTx is Map) {
        final tx = Map<String, dynamic>.from(rawTx);
        final pPhone = sanitizePhone((tx['customerPhone'] ?? tx['customerId'] ?? tx['phone'] ?? '').toString());
        final txStatus = (tx['status'] ?? '').toString().toLowerCase().trim();
        final txColor = (tx['txColor'] ?? '').toString().toLowerCase().trim();

        // صرف اس کسٹمر کی اپرووڈ گرین ٹرانزیکشنز کاؤنٹ ہوں گی
        if (pPhone == cleanPhone && txStatus == 'approved' && txColor == 'green') {
          double amt = double.tryParse((tx['txAmount'] ?? tx['amount'] ?? 0).toString()) ?? 0.0;
          totalPaidPool += amt.abs();
        }
      }
    }

    List<InstallmentRowModel> rows = [];
    double totalOverdueShort = 0.0;
    double remainingPaidPool = totalPaidPool;

    // 🎯 ۴۔ واٹرفال قسطوں کی تقسیم اور شارٹ کا حساب
    for (int i = 1; i <= totalMonths; i++) {
      String label = (isAdvanceType && i == 1) ? "ایڈوانس (قسط 1)" : "قسط $i";
      double dueAmount = (isAdvanceType && i == 1) ? advanceAmount : monthlyInstallment;

      DateTime dueDate;
      if (i == 1) {
        dueDate = purchaseDate;
      } else {
        int year = purchaseDate.year;
        int month = purchaseDate.month + (isAdvanceType ? i - 1 : i - 1);
        while (month > 12) {
          month -= 12;
          year += 1;
        }
        dueDate = DateTime(year, month, 5);
      }

      // وصولی کی رقم کو قسطوں پر برابری سے ایڈجسٹ کرنا
      double paidForThisRow = 0.0;
      if (remainingPaidPool >= dueAmount) {
        paidForThisRow = dueAmount;
        remainingPaidPool -= dueAmount;
      } else {
        paidForThisRow = remainingPaidPool;
        remainingPaidPool = 0.0;
      }

      double short = (dueAmount - paidForThisRow) > 0 ? (dueAmount - paidForThisRow) : 0.0;
      double progress = dueAmount > 0 ? (paidForThisRow / dueAmount).clamp(0.0, 1.0) : 0.0;

      bool isOverdue = dueDate.isBefore(now) ||
          (dueDate.year == now.year && dueDate.month == now.month && dueDate.day == now.day);

      if (isOverdue && short > 0) {
        totalOverdueShort += short;
      }

      rows.add(InstallmentRowModel(
        label: label,
        day: dueDate.day.toString(),
        monthText: getUrduMonth(dueDate.month),
        year: dueDate.year.toString(),
        due: dueAmount.toStringAsFixed(0),
        paid: paidForThisRow.toStringAsFixed(0),
        short: short.toStringAsFixed(0),
        progress: progress,
        isOverdue: isOverdue,
        amountToPay: short > 0 ? short : dueAmount,
      ));
    }

    return InstallmentTableDataModel(
      mobileName: mobileName,
      packageName: packageName,
      totalPrice: totalPrice,
      totalOverdueShort: totalOverdueShort,
      isApproved: isApproved,
      rows: rows,
    );
  }
}