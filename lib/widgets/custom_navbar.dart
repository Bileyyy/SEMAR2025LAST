import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  CustomNavbar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 15, 20, bottomInset + 15),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(3, (index) {
                bool isSelected = selectedIndex == index;
                return GestureDetector(
                  onTap: () => onItemTapped(index),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    width: 70,
                    height: isSelected ? 60 : 40,
                    alignment: Alignment.topCenter,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        if (isSelected)
                          Positioned(
                            top: -20,
                            left: 0,
                            right: 0,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 158, 193, 213),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 50, 158, 221),
                                    blurRadius: 10,
                                    spreadRadius: -2,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  _getIcon(index),
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        if (!isSelected)
                          Icon(
                            _getIcon(index),
                            color: Colors.grey,
                            size: 28,
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(int index) {
    switch (index) {
      case 0:
        return FontAwesomeIcons.home;
      case 1:
        return FontAwesomeIcons.newspaper;
      case 2:
        return FontAwesomeIcons.user;
      default:
        return Icons.circle;
    }
  }
}