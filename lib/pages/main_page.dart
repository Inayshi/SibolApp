import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:urban_farming/ai_assist.dart';
import 'package:urban_farming/components/navbar.dart';
import 'package:urban_farming/services/auth_service.dart';
import 'package:urban_farming/widgets/note_icon_button_outlined.dart';
import '../core/dialogs.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: _selectedIndex,
        onTabSelected: _onItemTapped,
      ),
    );
  }
}
