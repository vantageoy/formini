import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'example/app.dart';

void main() {
  testWidgets('it completes the example app form', (tester) async {
    await tester.pumpWidget(ExampleApp());
    await tester.pumpAndSettle();

    final email = find.byKey(Key('email-field'));
    final password = find.byKey(Key('password-field'));

    expectLater(containsText('pristine: true'), findsOneWidget);
    expectLater(containsText('valid: false'), findsOneWidget);

    await tester.enterText(email, '');
    await tester.pumpAndSettle();
    expectLater(containsText('valid: false'), findsOneWidget);
    expectLater(containsText('pristine: false'), findsOneWidget);
    expectLater(containsText('Email is required'), findsOneWidget);

    await tester.enterText(email, 'foo');
    await tester.pumpAndSettle();
    expectLater(containsText('Email is invalid'), findsOneWidget);

    await tester.enterText(email, 'foo@bar.fi');
    await tester.pumpAndSettle();
    expectLater(containsText('Email is invalid'), findsNothing);

    await tester.enterText(password, 'foo');
    await tester.pumpAndSettle();
    expectLater(containsText('Password min length is 5'), findsOneWidget);

    await tester.enterText(password, '');
    await tester.pumpAndSettle();
    expectLater(containsText('Password is required'), findsOneWidget);

    await tester.enterText(password, '123456');
    await tester.pumpAndSettle();
    expectLater(containsText('valid: true'), findsOneWidget);
    expectLater(containsText('password: 123456'), findsOneWidget);
    expectLater(containsText('email: foo@bar.fi'), findsOneWidget);
  });
}

Finder containsText(String text) {
  return find.byWidgetPredicate((widget) {
    return widget is RichText && widget.text.toString().contains(text);
  });
}
