
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_manager_v2/main.dart';

void main() {
  testWidgets('Welcome screen displays branding', (tester) async {
    await tester.pumpWidget(const ExpenseManagerApp());

    expect(find.text('Expense Manager'), findsOneWidget);
    expect(find.text('Smart Spending, Better Living'), findsOneWidget);
    expect(find.text('— BRAJ MOHAN —'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });

  testWidgets('Get Started opens dashboard', (tester) async {
    await tester.pumpWidget(const ExpenseManagerApp());

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back!'), findsOneWidget);
    expect(find.text('TOTAL BALANCE'), findsOneWidget);
  });
}
