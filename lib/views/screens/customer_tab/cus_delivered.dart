import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uuid/uuid.dart';

class CusDeliveredScreen extends StatefulWidget {
  const CusDeliveredScreen({super.key});

  @override
  State<CusDeliveredScreen> createState() => _CusDeliveredScreenState();
}

class _CusDeliveredScreenState extends State<CusDeliveredScreen> {
  DateTime? onWayDate;
  double rating = 1.0;
  late String reviewId;
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where('cid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('delivered', isEqualTo: true)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _ordersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Material(
            child: Center(
              child: CircularProgressIndicator(color: Colors.yellow.shade900),
            ),
          );
        }
        if (snapshot.data!.docs.isEmpty) {
          return Scaffold(
            body: Center(
              child: Center(
                child: Text(
                  'No Product \n  Delivered yet',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 30,
                    letterSpacing: 7,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }
        return Scaffold(
            body: ListView(
          children:
              snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
            return Container(
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 14,
                      child: Icon(
                        Icons.nordic_walking,
                        size: 18,
                      ),
                    ),
                    title: Text(
                      'Delivered',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    trailing: Text(
                      'Amount' +
                          ' ' +
                          '\$' +
                          documentSnapshot['orderPrice'].toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ExpansionTile(
                    title: Text('Order Details'),
                    subtitle: Text(
                      ' View Order Details',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.deepPurple,
                      ),
                    ),
                    children: [
                      Container(
                        height: 200,
                        child: ListView.builder(
                          itemCount: documentSnapshot['orderQuantity'],
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                child: Image.network(
                                    documentSnapshot['orderImage']),
                              ),
                              title: Text(documentSnapshot['orderName']),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, top: 8, bottom: 8),
                        child: Card(
                          color: Colors.yellow.shade900,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Customer Details :  ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      documentSnapshot['fullName']
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Email Address :  ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      documentSnapshot['email'].toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Country :  ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      documentSnapshot['country'].toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'City :  ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      documentSnapshot['city'].toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'State :  ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      documentSnapshot['state'].toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Delivery Status :  ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    documentSnapshot['delivered'] == true
                                        ? Text(
                                            'Delivered',
                                            style: TextStyle(
                                              color: Colors.deepPurple,
                                              fontSize: 22,
                                            ),
                                          )
                                        : Text(''),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    width: MediaQuery.of(context).size.width - 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.yellow.shade700,
                      ),
                      child: Text(
                        'Write Review',
                        style: TextStyle(
                          letterSpacing: 4,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 800,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(17.0),
                                      child: Text(
                                        'Write A Review',
                                        style: TextStyle(
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                    RatingBar(
                                      filledIcon: Icons.star,
                                      emptyIcon: Icons.star_border,
                                      onRatingChanged: (value) {
                                        setState(() {
                                          rating = value;
                                        });
                                      },
                                      initialRating: rating,
                                      maxRating: 5,
                                      alignment: Alignment.center,
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        EasyLoading.show();
                                        reviewId = Uuid().v1();
                                        CollectionReference collReview =
                                            FirebaseFirestore.instance
                                                .collection('products')
                                                .doc(documentSnapshot[
                                                    'productId'])
                                                .collection('reviews');

                                        await collReview.doc(reviewId).set({
                                          'email': documentSnapshot['email'],
                                          'fullName':
                                              documentSnapshot['fullName'],
                                          'profileImage':
                                              documentSnapshot['profileImage'],
                                          'rating': rating,
                                        }).whenComplete(() {
                                          EasyLoading.dismiss();
                                        });
                                      },
                                      child: Text(
                                        'Submit',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 7,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ));
      },
    );
  }
}
