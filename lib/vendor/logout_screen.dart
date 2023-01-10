import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_grocery_shop/vendor/auth/vendor_login_screen.dart';

class VendorLogoutScreen extends StatelessWidget {
  const VendorLogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () async {
            FirebaseAuth.instance.signOut().whenComplete(() {
              return Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return VendorLoginScreen();
              }));
            });
          },
          child: Text(
            'Sign Out',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 9,
            ),
          ),
        ),
      ),
    );
  }
}
