import 'package:flutter/material.dart';
//import 'package:flutter/material.dart';
import 'package:newspaper_app/screen/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Reader',
      theme: ThemeData(
        primaryColor: Colors.blue, // Define the primary color
        hintColor: Colors.orange, // Define the accent color
        fontFamily: 'Roboto', // Define the default font family
        textTheme: const TextTheme(
          headline6: TextStyle(
            fontSize: 20.0, // Define a default font size for headlines
            fontWeight: FontWeight.bold, // Define the default font weight
          ),
          bodyText2: TextStyle(
            fontSize: 16.0, // Define a default font size for body text
            color: Colors.black, // Define the default text color
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
