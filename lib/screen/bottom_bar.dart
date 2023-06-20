import 'package:diet_app/screen/blog_screen.dart';
import 'package:diet_app/screen/explore_page.dart';
import 'package:diet_app/screen/home_page.dart';
import 'package:diet_app/screen/settings_page_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[    const HomePage(),    const ExplorePage(), const BlogPage(),    const SettingsPage(),  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override


  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Diet App",
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Diet App"),
          backgroundColor: const Color.fromRGBO(147, 129, 255, 1),
        ),
        body: Container(
          height: double.infinity,
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: GNav(
          haptic: true,
          backgroundColor: const Color.fromRGBO(147, 129, 255, 1),
          color: Colors.white,
          activeColor: const Color.fromRGBO(255, 219, 10, 1.0),
          tabBackgroundColor: const Color.fromRGBO(147, 129, 255, 1),
          curve: Curves.easeInQuad,
          gap: 2,
          iconSize: 24,
          tabMargin: const EdgeInsets.symmetric(vertical: 0),
          selectedIndex: _selectedIndex,
          onTabChange: _onItemTapped,
          style: GnavStyle.oldSchool,
          tabs: const [
            GButton(
              icon: Icons.home_outlined,
              text: 'Home',
            ),
            GButton(
              icon: Icons.explore_outlined,
              text: 'Explore',
            ),
            GButton(
              icon: Icons.library_books,
              text: 'Blogs',
            ),
            GButton(
              icon: Icons.person_2_outlined,
              text: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
