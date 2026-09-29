import 'package:donguran/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('splash redirects to home and bottom tabs switch pages',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: DonguranApp()));
    await tester.pumpAndSettle();

    expect(find.text('HomePage · Figma SEG4 (914:6938)'), findsOneWidget);

    await tester.tap(find.text('채팅'));
    await tester.pumpAndSettle();
    expect(find.text('ChatPage · Figma SEG3 (870:8926)'), findsOneWidget);

    await tester.tap(find.text('MY'));
    await tester.pumpAndSettle();
    expect(find.text('MyPage · Figma SEG2 (509:5055)'), findsOneWidget);

    await tester.tap(find.text('홈'));
    await tester.pumpAndSettle();
    expect(find.text('HomePage · Figma SEG4 (914:6938)'), findsOneWidget);
  });
}
