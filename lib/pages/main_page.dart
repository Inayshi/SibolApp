import 'package:flutter/material.dart';
import 'package:urban_farming/ai_assist.dart';
import 'package:urban_farming/components/navbar.dart';
import 'package:urban_farming/pages/forum_page.dart';
import 'package:urban_farming/pages/my_farm.dart';
import 'package:urban_farming/pages/settings.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    AiAssistPage(), //This is temporary, this should direct to AiAssist.dart
    ForumPage(), //This is temporary, this should direct to Forums.dart
    MyFarm(), //This is temporary, this should direct to MyFarm.dart
    SettingsPage(), //This is temporary, this should direct to Settings.dart
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print('the index are: $index');
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
