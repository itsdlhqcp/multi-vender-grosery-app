import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_grocery_shop/vendor/inner_screens/checout_screen.dart';
import 'package:multi_grocery_shop/vendor/provider/cart_provider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Cart',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.yellow.shade900,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                _cartProvider.clearCart();
              },
              icon: Icon(
                CupertinoIcons.cart_badge_plus,
                size: 35,
              ),
            ),
          ),
        ],
      ),
      body: _cartProvider.getCartItem.isNotEmpty
          ? Consumer<CartProvider>(
              builder: ((context, cart, child) {
                return Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: cart.getCartItem.length,
                      itemBuilder: (context, index) {
                        final cartData =
                            cart.getCartItem.values.toList()[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: SizedBox(
                              height: 170,
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Image.network(
                                      cartData.imageUrls[0],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cartData.productName,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '\$' +
                                              '${cartData.price.toStringAsFixed(2)}',
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 110,
                                              decoration: BoxDecoration(
                                                  color:
                                                      Colors.yellow.shade900),
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      _cartProvider
                                                          .decrement(cartData);
                                                    },
                                                    icon: Icon(
                                                      CupertinoIcons.minus,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    cartData.quantity
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      _cartProvider
                                                          .increment(cartData);
                                                    },
                                                    icon: Icon(
                                                      CupertinoIcons.plus,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {},
                                                icon:
                                                    Icon(CupertinoIcons.delete))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                );
              }),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your Shopping Cart is Empty',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade900,
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'CONTINUE SHOPPING',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: Provider.of<CartProvider>(context, listen: true)
                      .getCartItem
                      .isEmpty
                  ? null
                  : () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CheckoutScreen();
                      }));
                    },
              child: Container(
                width: MediaQuery.of(context).size.width - 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.yellow.shade900,
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: Center(
                  child: Text(
                    'CHECKOUT' +
                        ' ' +
                        '\$' +
                        ' ' +
                        _cartProvider.totalAmount.toStringAsFixed(2),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
