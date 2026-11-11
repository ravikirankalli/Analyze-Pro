import 'package:analyze_pro/screens/login_screen.dart';
import 'package:analyze_pro/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() => WidgetController.hitTestWarningShouldBeFatal = true);

  group('splash', () {
    testWidgets('it shows the branding and lays out without throwing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SplashScreen(autoAdvance: false)),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      // The wordmark is one RichText with two coloured spans.
      expect(find.textContaining('Analyze', findRichText: true), findsWidgets);
      expect(find.textContaining('Pro', findRichText: true), findsWidgets);
      expect(find.text('Student Progress Insights for Parents'), findsOneWidget);
      expect(find.text('A Brighter'), findsOneWidget);
      expect(find.text('Tomorrow'), findsOneWidget);
      expect(find.text('Together'), findsOneWidget);
      expect(find.text('From'), findsOneWidget);
      expect(find.text('Andhra Educational Trust'), findsOneWidget);
    });

    testWidgets('it lays out on a short screen', (tester) async {
      tester.view.physicalSize = const Size(360, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(home: SplashScreen(autoAdvance: false)),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('it hands over to the login screen', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashScreen(hold: Duration(milliseconds: 50)),
        ),
      );
      await tester.pump();
      expect(find.byType(LoginScreen), findsNothing);

      await tester.pump(const Duration(milliseconds: 60));
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.text('Login'), findsWidgets);
    });
  });

  group('login', () {
    Widget host({Future<String?> Function(String, String)? onLogin}) =>
        MaterialApp(home: LoginScreen(onLogin: onLogin));

    testWidgets('it shows the card, both fields and the branding', (tester) async {
      await tester.pumpWidget(host());
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('Login'), findsWidgets);
      expect(find.text('Coordinator Code'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text('Andhra Educational Trust'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(
        find.descendant(
          of: find.byType(LoginScreen),
          matching: find.byType(SingleChildScrollView),
        ),
        findsNothing,
        reason: 'the card is sized to fit, so nothing scrolls',
      );
    });

    testWidgets('the password is hidden until the eye is tapped', (tester) async {
      await tester.pumpWidget(host());
      await tester.pump();

      TextField passwordField() => tester.widgetList<TextField>(find.byType(TextField)).last;
      expect(passwordField().obscureText, isTrue);

      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump();

      expect(passwordField().obscureText, isFalse);
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets('it asks for a code before anything else', (tester) async {
      var called = false;
      await tester.pumpWidget(host(onLogin: (_, _) async {
        called = true;
        return null;
      }));
      await tester.pump();

      await tester.tap(find.widgetWithText(InkWell, 'Login'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Please enter your Coordinator Code.'), findsOneWidget);
      expect(called, isFalse);
    });

    testWidgets('it asks for a password once the code is in', (tester) async {
      await tester.pumpWidget(host(onLogin: (_, _) async => null));
      await tester.pump();

      await tester.enterText(find.byType(TextField).first, 'CO-123');
      await tester.tap(find.widgetWithText(InkWell, 'Login'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Please enter your password.'), findsOneWidget);
    });

    testWidgets('it passes the credentials on and reports a rejection', (tester) async {
      String? gotCode;
      String? gotPassword;

      await tester.pumpWidget(host(onLogin: (code, password) async {
        gotCode = code;
        gotPassword = password;
        return 'That code and password do not match.';
      }));
      await tester.pump();

      await tester.enterText(find.byType(TextField).first, '  CO-123  ');
      await tester.enterText(find.byType(TextField).last, 'secret');
      await tester.tap(find.widgetWithText(InkWell, 'Login'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(gotCode, 'CO-123', reason: 'the code is trimmed');
      expect(gotPassword, 'secret');
      expect(find.text('That code and password do not match.'), findsOneWidget);
    });

    testWidgets('with no backend wired it says so rather than pretending', (tester) async {
      await tester.pumpWidget(host());
      await tester.pump();

      await tester.enterText(find.byType(TextField).first, 'CO-123');
      await tester.enterText(find.byType(TextField).last, 'secret');
      await tester.tap(find.widgetWithText(InkWell, 'Login'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.textContaining('not connected to the server yet'), findsOneWidget);
    });
  });
}
