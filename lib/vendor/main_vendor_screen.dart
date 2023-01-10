import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_grocery_shop/vendor/auth/vendor_login_screen.dart';
import 'package:multi_grocery_shop/vendor/inner_screens/add_product_screen.dart';
import 'package:multi_grocery_shop/vendor/inner_screens/all_product.dart';
import 'package:multi_grocery_shop/vendor/inner_screens/earnings_screen.dart';
import 'package:multi_grocery_shop/vendor/logout_screen.dart';

import 'package:multi_grocery_shop/vendor/provider/vendor_provider.dart';
import 'package:multi_grocery_shop/vendor/vendor_order_Screen.dart';

import 'package:provider/provider.dart';

class MainVendorScreen extends StatefulWidget {
  const MainVendorScreen({super.key});

  @override
  State<MainVendorScreen> createState() => _MainVendorScreenState();
}

class _MainVendorScreenState extends State<MainVendorScreen> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final VendorProvider _vendorProvider = Provider.of<VendorProvider>(context);
    if (_vendorProvider.doc == null) {
      _vendorProvider.getVendorData();
    }

    List<Widget> _pages = [
      EarningsScreen(),
      AddProductScreen(),
      AllProducts(),
      VendorOrderScreen(),
      VendorLogoutScreen(),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
        },
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.yellow.shade900,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.money_dollar), label: 'EARNINGS'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.add), label: 'UPLOAD'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'EDIT'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.shopping_cart), label: 'ORDERS'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'LOGOUT'),
        ],
      ),
      body: _pages[pageIndex],
    );
  }
}
