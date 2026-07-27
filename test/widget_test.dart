import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart';

void main() {
  testWidgets('App should render', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Habit Tracker'), findsOneWidget);
  });
}
