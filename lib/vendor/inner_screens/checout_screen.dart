import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_grocery_shop/vendor/provider/cart_provider.dart';
import 'package:multi_grocery_shop/views/screens/edit_profile_screen.dart';
import 'package:multi_grocery_shop/views/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _payMethod = 1;
  late String orderId;

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    CollectionReference buyers =
        FirebaseFirestore.instance.collection('buyers');

    return FutureBuilder<DocumentSnapshot>(
      future: buyers.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Center(child: Text("Document does not exist"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              title: Text(
                'Checkout',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<CartProvider>(
                    builder: ((context, cart, child) {
                      return Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: cart.getCartItem.length,
                          itemBuilder: (context, index) {
                            final cartData =
                                cart.getCartItem.values.toList()[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: SizedBox(
                                  height: 100,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Image.network(
                                          cartData.imageUrls[0],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cartData.productName,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '\$' +
                                                  '${cartData.price.toStringAsFixed(2)}',
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            bottomSheet: data['address'] == ''
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return EditProfileScreen(
                                userData: data,
                              );
                            })).whenComplete(() {
                              Navigator.pop(context);
                            });
                          },
                          child: Text(
                            'Billing Address',
                            style: TextStyle(letterSpacing: 12, fontSize: 20),
                          )),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () async {
                        if (_payMethod == 1) {
                          EasyLoading.show();

                          _cartProvider.getCartItem.forEach((key, item) async {
                            CollectionReference orderRef =
                                _firestore.collection('orders');

                            orderId = Uuid().v4();

                            await orderRef.doc(orderId).set({
                              'cid': data['buyerId'],
                              'vendorId': item.vendorId,
                              'email': data['email'],
                              'address': data['address'],
                              'fullName': data['fullName'],
                              'state': data['state'],
                              'phone': data['phoneNumber'],
                              'profileImage': data['profileImage'],
                              'productId': item.productId,
                              'orderId': orderId,
                              'orderName': item.productName,
                              'orderImage': item.imageUrls.first,
                              'orderPrice': item.price,
                              'orderQuantity': item.quantity,
                              'scheduleDate': item.shippingDate,
                              'delivered': false,
                              'deliveryStatus': true,
                              'shipping': false,
                              'accepted': false,
                              'orderDate': DateTime.now(),
                            }).whenComplete(() {
                              setState(() {
                                EasyLoading.dismiss();

                                _cartProvider.getCartItem.clear();
                              });
                            }).whenComplete(() {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: ((context) {
                                return MainScreen();
                              })));
                            });
                          });
                        }
                      },
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade900,
                          borderRadius: BorderRadius.circular(
                            15,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'ORDER',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          );
        }

        return Center(
          child: CircularProgressIndicator(
            color: Colors.yellow.shade900,
          ),
        );
      },
    );
  }
}
