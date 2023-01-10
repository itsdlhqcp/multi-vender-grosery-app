import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_grocery_shop/views/screens/widgets/category_widget.dart';

class VendorStoreScreen extends StatefulWidget {
  final dynamic vendorId;

  const VendorStoreScreen({super.key, required this.vendorId});

  @override
  State<VendorStoreScreen> createState() => _VendorStoreScreenState();
}

class _VendorStoreScreenState extends State<VendorStoreScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('vendors');

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('vendorId', isEqualTo: widget.vendorId)
        .snapshots();
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.vendorId).get(),
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
              backgroundColor: Colors.yellow.shade900,
              elevation: 0,
              title: Text(
                data['bussinessName'].toUpperCase(),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: _productsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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

                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Center(
                      child: Text(
                        'No Product added for\n  this Store Yet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 30,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.size,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 14,
                        crossAxisCount: 2,
                        childAspectRatio: 200 / 300),
                    itemBuilder: (context, index) {
                      final _productsData = snapshot.data!.docs[index];
                      return ReuseProductModel(categoryData: _productsData);
                    },
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
          ),
        );
      },
    );
  }
}
