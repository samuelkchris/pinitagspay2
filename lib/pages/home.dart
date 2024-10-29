import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../components/appbar.dart';
import '../components/tab.dart';

class HomePage extends StatefulWidget {
  static const String route = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final iconList = <String>[
    'assets/svg/home-svgrepo-com (2).svg',
    'assets/svg/send-svgrepo-com.svg',
    'assets/svg/scan-qr-svgrepo-com.svg',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.withOpacity(0.3),
      bottomNavigationBar: SalomonBottomBar(
        backgroundColor: Colors.white,
        curve: Curves.easeOutExpo,
        margin: const EdgeInsets.all(10),
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: SvgPicture.asset(
              iconList[0],
              height: 30,
              width: 30,
            ),
            title: const Text("Home"),
            selectedColor: Colors.purple,
          ),

          SalomonBottomBarItem(
            icon: SvgPicture.asset(
              iconList[2],
              height: 30,
              width: 30,
            ),
            title: const Text("Scan"),
            selectedColor: Colors.orange,
          ),

          SalomonBottomBarItem(
            icon: SvgPicture.asset(
              iconList[1],
              height: 30,
              width: 30,
            ),
            title: const Text("Search"),
            selectedColor: Colors.pink,
          ),
        ],
      ),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              const CustomSliverAppBar(),
            ];
          },
          body: const TabBarPage(),
        ),
      ),
    );
  }
}
