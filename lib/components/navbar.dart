import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

// You need to create these pages or ensure they exist and are imported correctly.
import 'package:urban_farming/ai_assist.dart';
// import 'package:urban_farming/pages/forums.dart';
import 'package:urban_farming/pages/my_farm.dart';
// import 'package:urban_farming/pages/settings.dart';

// Navbar widget as defined in your reference.
class Navbar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const Navbar({
    Key? key,
    required this.currentIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    return Container(
      padding:
          EdgeInsets.fromLTRB(displayWidth * .02, 0, displayWidth * .02, 0),
      height: displayWidth * .200,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(40.0), // Rounded top corners
        ),
        child: BottomNavigationBar(
          currentIndex: widget.currentIndex,
          onTap: widget.onTabSelected,
          backgroundColor: Colors.green,
          selectedItemColor: Colors.white,
          unselectedItemColor: Color.fromARGB(255, 23, 90, 25),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Ionicons.sparkles),
              label: 'AI Assist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Ionicons.people),
              label: 'Forum',
            ),
            BottomNavigationBarItem(
              icon: Icon(Ionicons.rose),
              label: 'My Farm',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

class ParentWidget extends StatefulWidget {
  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    AiAssistPage(),
    // Forums(),
    MyFarm(),
    // Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Navbar(
        currentIndex: _currentIndex,
        onTabSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
