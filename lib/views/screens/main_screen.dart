import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multi_grocery_shop/utils/const.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 5,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.yellow.shade900,
        currentIndex: _pageIndex,
        onTap: ((value) {
          setState(() {
            _pageIndex = value;
          });
        }),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.home,
              size: 20,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/explore.svg',
              width: 20,
            ),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/cart.svg',
                width: 20,
              ),
              label: 'Cart'),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/account.svg',
              width: 20,
            ),
            label: 'Account',
          ),
        ],
      ),
      body: pages[_pageIndex],
    );
  }
}
