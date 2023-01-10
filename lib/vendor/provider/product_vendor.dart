import 'package:flutter/widgets.dart';

class ProductProvder with ChangeNotifier {
  Map<String, dynamic>? productData = {};

  getFormData({
    String? productName,
    double? salesPrice,
    int? quantity,
    String? category,
    String? description,
    DateTime? scheduleDate,
    bool? chargeShipping,
    int? shippingCharge,
    String? brand,
    List? sizeList,
    List<String>? imagesList,
  }) {
    if (productName != null) {
      productData!['productName'] = productName;
    }
    if (salesPrice != null) {
      productData!['salesPrice'] = salesPrice;
    }
    if (quantity != null) {
      productData!['quantity'] = quantity;
    }
    if (category != null) {
      productData!['category'] = category;
    }
    if (description != null) {
      productData!['description'] = description;
    }

    if (scheduleDate != null) {
      productData!['scheduleDate'] = scheduleDate;
    }

    if (chargeShipping != null) {
      productData!['chargeShipping'] = chargeShipping;
    }

    if (shippingCharge != null) {
      productData!['shippingCharge'] = shippingCharge;
    }

    if (brand != null) {
      productData!['brand'] = brand;
    }
    if (sizeList != null) {
      productData!['sizeList'] = sizeList;
    }

    if (imagesList != null) {
      productData!['imagesList'] = imagesList;
    }

    notifyListeners();
  }
}
