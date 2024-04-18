import 'package:flutter/material.dart';
import 'package:urban_farming/components/navbar.dart';
import 'package:urban_farming/login.dart';
import 'package:urban_farming/pages/my_farm.dart';
import 'ai_assist.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return AiAssistPage();
      // case 1:
      //   return Forums();
      case 2:
        return MyFarm();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins', // Set the default font family to Poppins
      ),
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
      },
    );
  }
}
