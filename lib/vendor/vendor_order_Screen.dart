import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:intl/intl.dart';

class VendorOrderScreen extends StatefulWidget {
  const VendorOrderScreen({super.key});

  @override
  State<VendorOrderScreen> createState() => _VendorOrderScreenState();
}

class _VendorOrderScreenState extends State<VendorOrderScreen> {
  DateTime? onWayDate;
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    String formatedDate(date) {
      var outputDateFormate = DateFormat('dd/MM/yyyy');

      var outputDate = outputDateFormate.format(date);

      return outputDate;
    }

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
                  'No Product \n  Shipping yet',
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
            appBar: AppBar(
              backgroundColor: Colors.yellow.shade900,
              elevation: 0,
              title: Text('MY ORDERS'),
            ),
            body: ListView(
              children:
                  snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                return Slidable(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 14,
                            child: documentSnapshot['accepted'] == true
                                ? Icon(Icons.delivery_dining)
                                : Icon(Icons.access_time),
                          ),
                          title: documentSnapshot['accepted'] == true
                              ? Text(
                                  'Accepted',
                                  style: TextStyle(color: Colors.cyan),
                                )
                              : Text(
                                  'Not Accepted',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                          subtitle: Text(
                            formatedDate(
                              documentSnapshot['orderDate'].toDate(),
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                          trailing: Text(
                            'Amount' +
                                " " +
                                documentSnapshot['orderPrice'].toString(),
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.pink,
                            ),
                          ),
                        ),
                        ExpansionTile(
                          title: Text(
                            ' Order Details',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.yellow.shade900,
                            ),
                          ),
                          subtitle: Text('View Order Details'),
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                child: Image.network(
                                  documentSnapshot['orderImage'],
                                ),
                              ),
                              title: Text(documentSnapshot['orderName']),
                              subtitle: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'Quantity',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        documentSnapshot['orderQuantity']
                                            .toString(),
                                        style: TextStyle(
                                          color: Colors.cyan,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                  documentSnapshot['accepted'] == true
                                      ? Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'SCHEDULED DELIVERY DATE',
                                                style: TextStyle(
                                                    color: Colors.cyan),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              formatedDate(
                                                documentSnapshot['scheduleDate']
                                                    .toDate(),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Text(''),
                                  ListTile(
                                    title: Text('BUYER DETAILS'),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          documentSnapshot['fullName'],
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          documentSnapshot['address'],
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          documentSnapshot['phone'],
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
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
                              .collection('orders')
                              .doc(documentSnapshot['orderId'])
                              .update({
                            'accepted': true,
                          });
                        },
                        backgroundColor: Colors.yellow.shade900,
                        foregroundColor: Colors.white,
                        icon: Icons.local_shipping,
                        label: 'Accept',
                      ),
                      SlidableAction(
                        flex: 2,
                        onPressed: (context) async {
                          await FirebaseFirestore.instance
                              .collection('orders')
                              .doc(documentSnapshot['orderId'])
                              .update({
                            'accepted': false,
                          });
                        },
                        backgroundColor: Colors.red.shade900,
                        foregroundColor: Colors.white,
                        icon: Icons.approval,
                        label: 'Reject',
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
