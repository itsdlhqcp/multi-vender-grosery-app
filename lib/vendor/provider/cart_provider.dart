import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_grocery_shop/vendor/models/cart_attr.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartAttr> _cartItems = {};

  double get totalAmount {
    var total = 0.0;

    _cartItems.forEach((key, value) {
      total += value.price * value.quantity;
    });

    return total;
  }

  Map<String, CartAttr> get getCartItem {
    return _cartItems;
  }

  void addProductToCart(String productId, String productName, List imageUrls,
      double price, String vendorId, Timestamp shippingDate) {
    //add item

    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
        productId,
        (exitingCart) => CartAttr(
          productId: exitingCart.productId,
          productName: exitingCart.productName,
          imageUrls: exitingCart.imageUrls,
          quantity: exitingCart.quantity + 1,
          price: exitingCart.price,
          vendorId: exitingCart.vendorId,
          shippingDate: exitingCart.shippingDate,
        ),
      );
      notifyListeners();
    } else {
      _cartItems.putIfAbsent(
        productId,
        () => CartAttr(
          productId: productId,
          productName: productName,
          imageUrls: imageUrls,
          quantity: 1,
          price: price,
          vendorId: vendorId,
          shippingDate: shippingDate,
        ),
      );
      notifyListeners();
    }
    notifyListeners();
    ;
  }

  void increment(CartAttr cartAttr) {
    cartAttr.increase();
    notifyListeners();
  }

  void decrement(CartAttr cartAttr) {
    cartAttr.decrease();

    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();

    notifyListeners();
  }
}
