import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const EventFinderApp());
}

class EventFinderApp extends StatelessWidget {
  const EventFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
