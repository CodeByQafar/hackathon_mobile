import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../pages/home_page.dart';
import '../pages/second_page.dart';
import '../pages/third_page.dart';
import '../setting/screens/setting_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    SecondPage(),
    ReservationPage(),

    SettingView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(icon: Icon(AkarIcons.basket), label: ""),
          BottomNavigationBarItem(icon: Icon(IconlyLight.profile), label: ""),

          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(CarbonIcons.settings_adjust),
            label: "",
          ),
        ],
      ),
    );
  }
}
