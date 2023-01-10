import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:multi_grocery_shop/vendor/provider/cart_provider.dart';
import 'package:multi_grocery_shop/views/detail/product_detail_screen.dart';
import 'package:multi_grocery_shop/views/screens/category_screen.dart';
import 'package:multi_grocery_shop/views/screens/homeProducts.dart';
import 'package:provider/provider.dart';

import '../../../models/category_models.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  String? _selectCategory;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                        child: FirestoreListView<CategoryModels>(
                            scrollDirection: Axis.horizontal,
                            query: CategoryModelssCollection,
                            itemBuilder: (context, snapshot) {
                              CategoryModels categoryModels = snapshot.data();
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ActionChip(
                                  backgroundColor: Colors.yellow.shade900,
                                  onPressed: () {
                                    setState(() {
                                      _selectCategory =
                                          categoryModels.categoryName;
                                    });
                                  },
                                  label: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        categoryModels.categoryName,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })),
                    IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CategoryScreen();
                        }));
                      },
                      icon: Icon(
                        CupertinoIcons.arrow_down,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              if (_selectCategory == null) MainProducts(),
              if (_selectCategory != null)
                HomeProduct(categoryName: _selectCategory!),
            ],
          ),
        ),
      ),
    );
  }
}

class MainProducts extends StatelessWidget {
  const MainProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('approved', isEqualTo: true)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: Colors.yellow.shade900),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Text(
                'No Product Has been\nUpload Yet',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return Container(
          height: 270,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final categoryData = snapshot.data!.docs[index];
                return ReuseProductModel(categoryData: categoryData);
              },
              separatorBuilder: (context, index) => SizedBox(
                    width: 10,
                  ),
              itemCount: snapshot.data!.size),
        );
      },
    );
  }
}

class ReuseProductModel extends StatelessWidget {
  const ReuseProductModel({
    Key? key,
    required this.categoryData,
  }) : super(key: key);

  final dynamic categoryData;

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetailScreen(
            products: categoryData,
          );
        }));
      },
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
          15,
        )),
        child: Container(
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 120,
                width: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    categoryData['images'][0],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      categoryData['productname'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '\$' +
                              " " +
                              categoryData['salesPrice'].toStringAsFixed(2),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow.shade900,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              _cartProvider.addProductToCart(
                                categoryData['productId'],
                                categoryData['productname'],
                                categoryData['images'],
                                categoryData['salesPrice'],
                                categoryData['vendorId'],
                                categoryData['scheduleDate'],
                              );
                            },
                            icon: Icon(
                              _cartProvider.getCartItem
                                      .containsKey(categoryData['productId'])
                                  ? CupertinoIcons.cart_fill_badge_plus
                                  : CupertinoIcons.shopping_cart,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
