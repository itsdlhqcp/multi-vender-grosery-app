import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_grocery_shop/vendor/inner_screens/vendorStore_screen.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _vendorsStream =
        FirebaseFirestore.instance.collection('vendors').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _vendorsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Material(
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.yellow.shade900,
              ),
            ),
          );
        }

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top: 80, left: 40),
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Store Owners',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  height: 500,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.size,
                    itemBuilder: ((context, index) {
                      final storeData = snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return VendorStoreScreen(
                                vendorId: storeData['vendorId']);
                          }));
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(storeData['storeImage']),
                          ),
                          title: Text(
                            storeData['bussinessName'],
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(storeData['country']),
                        ),
                      );
                    }),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
