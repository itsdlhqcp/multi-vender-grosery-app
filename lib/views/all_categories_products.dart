import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutterfire_ui/firestore.dart';
import 'package:multi_grocery_shop/views/screens/widgets/category_widget.dart';

class AllCategoriesProduct extends StatefulWidget {
  final String categoryName;

  const AllCategoriesProduct({super.key, required this.categoryName});

  @override
  State<AllCategoriesProduct> createState() => _AllCategoriesProductState();
}

class _AllCategoriesProductState extends State<AllCategoriesProduct> {
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
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
            body: Center(
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
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.categoryName,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: snapshot.docs.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 14,
                  crossAxisCount: 2,
                  childAspectRatio: 200 / 300),
              itemBuilder: (context, index) {
                final categoryData = snapshot.docs[index];
                return ReuseProductModel(categoryData: categoryData);
              },
            ),
          ),
        );
      },
    );
  }
}
