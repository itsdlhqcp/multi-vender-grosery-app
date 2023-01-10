import 'package:flutter/material.dart';

import 'package:multi_grocery_shop/views/screens/customer_tab/cus_delivered.dart';
import 'package:multi_grocery_shop/views/screens/customer_tab/cus_shipping.dart';

class CusMainTab extends StatefulWidget {
  const CusMainTab({super.key});

  @override
  State<CusMainTab> createState() => _CusMainTabState();
}

class _CusMainTabState extends State<CusMainTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('My Orders'),
          backgroundColor: Colors.yellow.shade800,
          bottom: TabBar(tabs: [
            Tab(
              text: 'On Way',
            ),
            Tab(
              text: 'Delivered',
            ),
          ]),
        ),
        body: TabBarView(children: [
          CusShippingScreen(),
          CusDeliveredScreen(),
        ]),
      ),
    );
  }
}
