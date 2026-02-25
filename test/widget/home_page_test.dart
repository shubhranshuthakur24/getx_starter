import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_starter/presentation/pages/home/home_page.dart';

void main() {
  tearDown(() => Get.reset());

  // ── Rendering ──────────────────────────────────────────────────────────────

  group('HomePage rendering', () {
    testWidgets('renders success message', (tester) async {
      await tester.pumpWidget(const GetMaterialApp(home: HomePage()));

      expect(find.text('🎉 Login Successful!'), findsOneWidget);
      expect(find.text('Firebase Auth is working correctly.'), findsOneWidget);
    });

    testWidgets('renders Sign Out button', (tester) async {
      await tester.pumpWidget(const GetMaterialApp(home: HomePage()));

      expect(find.text('Sign Out'), findsOneWidget);
      expect(find.byIcon(Icons.logout_rounded), findsOneWidget);
    });

    testWidgets('renders success icon', (tester) async {
      await tester.pumpWidget(const GetMaterialApp(home: HomePage()));

      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });
  });

  // ── Navigation ─────────────────────────────────────────────────────────────

  group('HomePage navigation', () {
    testWidgets('Sign Out navigates to /login', (tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          getPages: [
            GetPage(name: '/home', page: () => const HomePage()),
            GetPage(
              name: '/login',
              page: () => const Scaffold(body: Text('Login Page')),
            ),
          ],
          initialRoute: '/home',
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign Out'));
      await tester.pumpAndSettle();

      expect(find.text('Login Page'), findsOneWidget);
    });
  });
}
