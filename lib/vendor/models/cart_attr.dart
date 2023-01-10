import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class CartAttr with ChangeNotifier {
  String productId;
  String productName;
  List imageUrls;
  int quantity;
  double price;
  String vendorId;

  Timestamp shippingDate;

  CartAttr({
    required this.productId,
    required this.productName,
    required this.imageUrls,
    required this.quantity,
    required this.price,
    required this.vendorId,
    required this.shippingDate,
  });

  void increase() {
    quantity++;
  }

  void decrease() {
    quantity--;
  }
}
