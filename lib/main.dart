import 'package:flutter/material.dart';
import 'package:urban_farming/components/ai_assist/plant_care.dart';
import 'package:urban_farming/login.dart';
import 'components/navbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'ai_assist.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

Future<void> main() async {
  Gemini.init(
    apiKey: "AIzaSyDSA6LoguOAxvHSkAwfHPJAuI6f1QsPSCY",
  );

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Firebase initialized successfully!");
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
    AiAssistPage(), //This is temporary, this should direct to AiAssist.dart
    Text('Forums'), //This is temporary, this should direct to Forums.dart
    Text('MyFarm'), //This is temporary, this should direct to MyFarm.dart
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
          body: _selectedIndex == 0 ? LoginPage() : AiAssistPage(),
          bottomNavigationBar: _selectedIndex == 0
              ? null
              : Navbar(
                  currentIndex: _selectedIndex,
                  onTabSelected: _onItemTapped,
                ),
        ),
      ),
    );
  }
}
