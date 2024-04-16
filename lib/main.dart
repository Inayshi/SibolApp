import 'package:flutter/material.dart';
import 'components/navbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'ai_assist.dart';
import 'components/ai_assist/chatscreen.dart';
import 'components/ai_assist/farm_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() async {
  Gemini.init(
    apiKey: "AIzaSyDSA6LoguOAxvHSkAwfHPJAuI6f1QsPSCY",
  );
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter binding is initialized
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
    AIAssist(), //This is temporary, this should direct to AiAssist.dart
    Text('Forum'), //This is temporary, this should direct to Settings.dart
    Text('My Farm'), //This is temporary, this should direct to Settings.dart
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
      theme: ThemeData(primaryColor: Colors.green, useMaterial3: true),
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
