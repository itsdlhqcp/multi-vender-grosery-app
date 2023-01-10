import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:multi_grocery_shop/vendor/auth/vendor_login_screen.dart';
import 'package:multi_grocery_shop/vendor/main_vendor_screen.dart';
import 'package:multi_grocery_shop/vendor/register_screen.dart';

import 'models/vendor_models.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionReference _usersStream =
        FirebaseFirestore.instance.collection('vendors');
    return Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
      stream:
          _usersStream.doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Material(
            child: Center(
                child: CircularProgressIndicator(
              color: Colors.cyan,
            )),
          );
        }

        if (!snapshot.data!.exists) {
          return VendorRegisterationScreen();
        }
        VendorUser vendorUser =
            VendorUser.fromJson(snapshot.data!.data()! as Map<String, dynamic>);
        if (vendorUser.aprroved == true) {
          return MainVendorScreen();
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    "${vendorUser.storeImage}",
                    width: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Text(
                  '${vendorUser.bussinessName}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Your application has been sent to shop app admin \Admin we wil get back to you soon ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              TextButton(
                onPressed: () async {
                  FirebaseAuth.instance.signOut().whenComplete(() => {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return VendorLoginScreen();
                        }))
                      });
                },
                child: Text('Sign Out'),
              ),
            ],
          ),
        );
      },
    ));
  }
}
