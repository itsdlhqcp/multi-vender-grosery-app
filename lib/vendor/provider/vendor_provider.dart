import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class VendorProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DocumentSnapshot? doc;

  getVendorData() {
    _firestore
        .collection('vendors')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      doc = value;

      notifyListeners();
    });
  }
}
