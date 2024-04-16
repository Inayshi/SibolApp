import 'package:flutter/material.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:ionicons/ionicons.dart';

class Navbar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const Navbar(
      {Key? key, required this.currentIndex, required this.onTabSelected})
      : super(key: key);

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return FloatingNavbar(
      onTap: widget.onTabSelected,
      backgroundColor:
          Color(0xFF3C6840), // Set the background color of the navbar
      selectedItemColor: Color.fromARGB(
          255, 15, 39, 17), // Color of the icon and text when item is selected
      unselectedItemColor: Color(
          0xFFF0F0F0), // Color of the icon and text when item is not selected
      selectedBackgroundColor:
          Colors.white.withOpacity(0), // Background color of the selected item
      margin: const EdgeInsets.symmetric(
          horizontal: 8, vertical: 8), // Margin around the navbar
      padding: const EdgeInsets.symmetric(
          horizontal: 5, vertical: 5), // Padding inside the navbar
      borderRadius: 10, // Border radius of the navbar
      elevation: 4.0, // Shadow under the navbar
      itemBorderRadius:
          10, // Border radius of the item's background when selected
      iconSize: 20, // Size of the icons in the navbar
      currentIndex: widget.currentIndex,
      items: [
        FloatingNavbarItem(icon: Ionicons.sparkles_outline, title: 'AI Assist'),
        FloatingNavbarItem(icon: Ionicons.people_outline, title: 'Forums'),
        FloatingNavbarItem(icon: Ionicons.rose_outline, title: 'My Farm'),
        FloatingNavbarItem(icon: Ionicons.settings_outline, title: 'Settings'),
      ],
    );
  }
}
