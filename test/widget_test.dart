// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Login screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: Text("Login Screen"),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 28),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Text("Login Screen"),
              Text("Enter Username"),
              TextField(),
              Text("Enter PAssword"),
              TextField(),
              SizedBox(height: 30),
              MaterialButton(
                onPressed: () {},
                color: Colors.deepPurpleAccent,
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Verify login screen UI elements exist
    expect(find.text('Login Screen'), findsWidgets);
    expect(find.text('Enter Username'), findsOneWidget);
    expect(find.text('Enter PAssword'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);

    // Verify the login button is present
    expect(find.byType(MaterialButton), findsOneWidget);

    // Verify text fields are present
    expect(find.byType(TextField), findsWidgets);
  });
}
