// import 'dart:core';

// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProductModel {
//   ProductModel({
//     required this.approved,
//     required this.productName,
//     required this.productPrice,
//     required this.categoryName,
//     required this.productDescription,
//     e,
//     required this.shippingDate,
//   });

//   ProductModel.fromJson(Map<String, Object?> json)
//       : this(
//           approved: json['approved']! as bool,
//           productName: json['productName']! as String,
//           productPrice: json['productPrice']! as double,
//           categoryName: json['categoryName']! as String,
//           productDescription: json['productDescription']! as String,
//           shippingDate: json['shippingDate']! as DateTime,
//         );
//   final bool? approved;
//   final String? productName;
//   final double? productPrice;
//   final String? categoryName;
//   final String productDescription;

//   final DateTime? shippingDate;

//   Map<String, Object?> toJson() {
//     return {
//       'approved': approved,
//       'productName': productName,
//       'productPrice': productPrice,
//       'categoryName': categoryName,
//       'productDescription': productDescription,
//       'shippingDate': shippingDate,
//     };
//   }
// }

// productQuery(approved) {
//   return FirebaseFirestore.instance
//       .collection('products')
//       .where(approved, isEqualTo: true)
//       .orderBy('productName')
//       .withConverter<ProductModel>(
//         fromFirestore: (snapshot, _) => ProductModel.fromJson(snapshot.data()!),
//         toFirestore: (productModel, _) => productModel.toJson(),
//       );
// }
