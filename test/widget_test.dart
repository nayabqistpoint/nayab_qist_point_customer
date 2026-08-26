import 'package:flutter_test/flutter_test.dart';
import 'package:nayab_qist_point_customer/main.dart';

void main() {
  testWidgets('CustomerApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CustomerApp());
  });
}