import 'package:flutter/material.dart';

void main() {
  runApp(
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
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/WIN_20230306_20_17_49_Pro.jpg'),
            Text("Login Screen"),
            Text("Enter Username"),
            TextField(),
            Text("Enter PAssword"),
            TextField(),
            SizedBox(height: 30),
            MaterialButton(
              onPressed: () {},
              child: Text(
                "Login",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
              color: Colors.deepPurpleAccent,
            ),
          ],
        ),
      ),
    ),
  );
}
