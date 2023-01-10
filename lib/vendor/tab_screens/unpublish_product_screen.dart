import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:multi_grocery_shop/vendor/inner_screens/product_detail_screen.dart';
import 'package:multi_grocery_shop/vendor/tab_screens/publised_products_screen.dart';

class UnpublisedProducts extends StatelessWidget {
  const UnpublisedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
        .collection('products')
        .where('approved', isEqualTo: false)
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _productStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.yellow.shade400,
            ),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No Products\n Unpublised Yet',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                letterSpacing: 10,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }

        return Container(
          height: 150,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                final productData = snapshot.data!.docs[index];

                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Slidable(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return VendorProductDetailScreen(
                                products: productData);
                          }));
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              child: CachedNetworkImage(
                                  imageUrl: productData['images'][0]),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    productData['productname'],
                                  ),
                                  Text(
                                    '\$' +
                                        productData['salesPrice']
                                            .toStringAsFixed(2),
                                    style: TextStyle(
                                        color: Colors.yellow.shade900,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      startActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            // An action can be bigger than the others.
                            flex: 2,
                            onPressed: (context) async {
                              await FirebaseFirestore.instance
                                  .collection('products')
                                  .doc(productData['productId'])
                                  .update({
                                'approved': true,
                              });
                            },
                            backgroundColor: Colors.yellow.shade900,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Publised',
                          ),
                          SlidableAction(
                            flex: 2,
                            onPressed: (context) async {
                              await FirebaseFirestore.instance
                                  .collection('products')
                                  .doc(productData['productId'])
                                  .delete();
                            },
                            backgroundColor: Colors.red.shade900,
                            foregroundColor: Colors.white,
                            icon: Icons.approval,
                            label: 'Delete',
                          ),
                        ],
                      ),
                    ));
              }),
        );
      },
    );
  }
}
