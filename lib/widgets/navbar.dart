import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:semar/screens/dashboard.dart';
import 'package:semar/screens/events_screen.dart';
import '../screens/home_screen.dart';
import 'package:semar/screens/profile_screen.dart'; 

class Navbar extends StatefulWidget {
  final int selectedIndex;

  Navbar({this.selectedIndex = 0});

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  static final List<Widget> _pages = [
    HomeScreen(),
    EventsScreen(),
    ProfileScreen(), // Gunakan ProfileScreen di sini
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                  bool isSelected = _selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      _onItemTapped(index);
                    },
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

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Navbar(),
  ));
}
