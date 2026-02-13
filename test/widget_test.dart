import 'package:flutter_test/flutter_test.dart';
import 'package:shopq/app/shopq_demo/shopq_app.dart';

void main() {
  testWidgets('ShopQ app renders splash title', (WidgetTester tester) async {
    await tester.pumpWidget(const ShopQDemoApp());
    expect(find.text('ShopQ'), findsOneWidget);
  });
}
