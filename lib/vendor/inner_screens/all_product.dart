import 'package:flutter/material.dart';
import 'package:multi_grocery_shop/vendor/tab_screens/publised_products_screen.dart';
import 'package:multi_grocery_shop/vendor/tab_screens/unpublish_product_screen.dart';

class AllProducts extends StatelessWidget {
  const AllProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow.shade900,
          centerTitle: true,
          title: Text(
            'Manage Products',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text('Published'),
              ),
              Tab(
                child: Text('Unpublised'),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          PublisedProducts(),
          UnpublisedProducts(),
        ]),
      ),
    );
  }
}
