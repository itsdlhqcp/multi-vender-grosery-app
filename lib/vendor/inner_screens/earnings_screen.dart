import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_grocery_shop/vendor/inner_screens/withdrew_screen.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _orderStream = FirebaseFirestore.instance
        .collection('orders')
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    CollectionReference vendors =
        FirebaseFirestore.instance.collection('vendors');
    return FutureBuilder<DocumentSnapshot>(
      future: vendors.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(color: Colors.black),
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(data['storeImage']),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Hi, " + "${data['bussinessName']}",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: _orderStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.cyan),
                  );
                }
                double totalbalance = 0.0;
                var data = [
                  0.0,
                  0.3,
                  0.2,
                  0.4,
                  0.3,
                  0.2,
                  0.3,
                ];
                for (var item in snapshot.data!.docs) {
                  totalbalance += item['orderQuantity'] * item['orderPrice'];
                }
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade900,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Total Earnings",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '\$' + " " + totalbalance.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  height: 40,
                                  child: Sparkline(
                                    data: data,
                                    lineWidth: 5.0,
                                    lineColor: Colors.yellow.shade900,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade900,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Total Order",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              snapshot.data!.docs.length.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: 40,
                                child: Sparkline(
                                  data: [
                                    0.0,
                                    0.3,
                                    0.4,
                                    0.5,
                                    0.6,
                                    0.2,
                                    0.3,
                                    0.4,
                                    0.5,
                                    0.3,
                                  ],
                                  lineWidth: 5.0,
                                  lineColor: Colors.yellow.shade900,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return WithdrawEarnins();
                            }));
                          },
                          child: Text(
                            'withdraw ' +
                                " " +
                                "\$" +
                                " " +
                                totalbalance.toStringAsFixed(2),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          );
        }

        return Material(
            child: Center(
          child: CircularProgressIndicator(
            color: Colors.yellow.shade900,
          ),
        ));
      },
    );
  }
}
