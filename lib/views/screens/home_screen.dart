import 'package:flutter/material.dart';

import 'package:multi_grocery_shop/views/screens/widgets/banner.dart';
import 'package:multi_grocery_shop/views/screens/widgets/category_widget.dart';
import 'package:multi_grocery_shop/views/screens/widgets/richTextWidget.dart';
import 'package:multi_grocery_shop/views/screens/widgets/searchWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichTextAndIcon(),
          SearchWidget(),
          BannerWidget(),
          CategoryWidget(),
        ],
      ),
    ));
  }
}
