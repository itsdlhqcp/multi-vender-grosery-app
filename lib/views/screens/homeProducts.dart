import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:multi_grocery_shop/views/screens/widgets/category_widget.dart';

class HomeProduct extends StatefulWidget {
  final String? categoryName;

  const HomeProduct({super.key, required this.categoryName});

  @override
  State<HomeProduct> createState() => _HomeProductState();
}

class _HomeProductState extends State<HomeProduct> {
  prodcuctQuery({categoryName}) {
    return FirebaseFirestore.instance
        .collection('products')
        .where('approved', isEqualTo: true)
        .where('category', isEqualTo: categoryName);
  }

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<Map<String, dynamic>>(
      query: prodcuctQuery(categoryName: widget.categoryName),
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return Center(child: const CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        }

        if (snapshot.docs.isEmpty) {
          return Center(
            child: Center(
              child: Text(
                'No Product added for\n  this Category yet',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 30,
                  letterSpacing: 4,
                ),
              ),
            ),
          );
        }

        return Container(
          height: 270,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final categoryData = snapshot.docs[index];
                return ReuseProductModel(categoryData: categoryData);
              },
              separatorBuilder: (context, index) => SizedBox(
                    height: 10,
                  ),
              itemCount: snapshot.docs.length),
        );
      },
    );
  }
}
