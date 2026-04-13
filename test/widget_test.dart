import 'package:flutter_test/flutter_test.dart';
import 'package:shopq/app.dart';

void main() {
  testWidgets('ShopQ app renders splash title', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('ShopQ'), findsOneWidget);
  });
}
