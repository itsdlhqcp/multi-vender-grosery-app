import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_grocery_shop/vendor/auth/vendor_login_screen.dart';
import 'package:multi_grocery_shop/vendor/inner_screens/earnings_screen.dart';

class VendorProfileScreen extends StatefulWidget {
  static const String routeName = '/profileScreen';

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('vendors');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(_auth.currentUser!.uid).get(),
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
              body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          child: Image.network(
                            data['storeImage'],
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.deepPurple.withOpacity(0.9),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: 130,
                          right: 20,
                          child: Center(
                            child: Text(
                              '${data['bussinessName']}'.toUpperCase(),
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ListTile(
                      title: Text('Manage'),
                      trailing: Icon(
                        CupertinoIcons.money_dollar,
                        size: 25,
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return EarningsScreen();
                        }));
                      },
                    ),
                    ListTile(
                      title: Text('Notifications'),
                      trailing: Icon(
                        CupertinoIcons.shopping_cart,
                        size: 25,
                      ),
                      onTap: () {},
                    ),
                    ExpansionTile(
                      title: Text(
                        'Email Address',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              data['email'],
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text(
                        'Country',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              data['country'],
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text(
                        'State',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              data['state'],
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text(
                        'City',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              data['city'],
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text(
                        'Tax',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              data['taxRegistered'],
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text(
                        'Support ID',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              data['vendorId'],
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ListTile(
                      title: Text(
                        'Logout',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                      ),
                      onTap: () async {
                        await _auth.signOut().whenComplete(
                          () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return VendorLoginScreen();
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ));
        }

        return Material(
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.deepPurple,
            ),
          ),
        );
      },
    );
  }
}
