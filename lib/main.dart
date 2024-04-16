import 'package:flutter/material.dart';
import 'package:urban_farming/components/ai_assist/chatscreen.dart';
import 'package:urban_farming/my_farm.dart';
import 'components/navbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    ChatScreen(), //This is temporary, this should direct to AiAssist.dart
    Text('Forums'), //This is temporary, this should direct to Forums.dart
    MyFarm(), //This is temporary, this should direct to MyFarm.dart
    Text('Settings'), //This is temporary, this should direct to Settings.dart
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: Navbar(
            currentIndex: _selectedIndex,
            onTabSelected: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
