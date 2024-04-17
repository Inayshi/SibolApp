import 'package:flutter/material.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter/services.dart';

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
    double displayWidth = MediaQuery.of(context).size.width;
    return Container(
      padding:
          EdgeInsets.fromLTRB(displayWidth * .05, 0, displayWidth * .05, 0),
      height: displayWidth * .155,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ListView.builder(
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: displayWidth * .02),
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            widget.onTabSelected(
                index); // Call the onTabSelected function from the parent
            HapticFeedback.lightImpact();
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Stack(
            children: [
              AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.fastLinearToSlowEaseIn,
                width: index == widget.currentIndex
                    ? displayWidth * .32
                    : displayWidth * .18,
                alignment: Alignment.center,
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.fastLinearToSlowEaseIn,
                  height: index == widget.currentIndex ? displayWidth * .12 : 0,
                  width: index == widget.currentIndex ? displayWidth * .32 : 0,
                  decoration: BoxDecoration(
                    color: index == widget.currentIndex
                        ? Colors.greenAccent.withOpacity(.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.fastLinearToSlowEaseIn,
                width: index == widget.currentIndex
                    ? displayWidth * .31
                    : displayWidth * .18,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Row(
                      children: [
                        AnimatedContainer(
                          duration: Duration(seconds: 1),
                          curve: Curves.fastLinearToSlowEaseIn,
                          width: index == widget.currentIndex
                              ? displayWidth * .13
                              : 0,
                        ),
                        AnimatedOpacity(
                          opacity: index == widget.currentIndex ? 1 : 0,
                          duration: Duration(seconds: 1),
                          curve: Curves.fastLinearToSlowEaseIn,
                          child: Text(
                            index == widget.currentIndex
                                ? '${listOfStrings[index]}'
                                : '',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        AnimatedContainer(
                          duration: Duration(seconds: 1),
                          curve: Curves.fastLinearToSlowEaseIn,
                          width: index == widget.currentIndex
                              ? displayWidth * .03
                              : 20,
                        ),
                        Icon(
                          listOfIcons[index],
                          size: displayWidth * .076,
                          color: index == widget.currentIndex
                              ? Colors.green
                              : Colors.black26,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<IconData> listOfIcons = [
    Ionicons.sparkles,
    Ionicons.people,
    Ionicons.rose,
    Icons.settings_rounded,
  ];

  List<String> listOfStrings = [
    'AI Assist',
    'Forum',
    'My Farm',
    'Settings',
  ];
}
