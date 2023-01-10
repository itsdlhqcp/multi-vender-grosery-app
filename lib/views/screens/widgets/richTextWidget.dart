import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multi_grocery_shop/vendor/provider/cart_provider.dart';
import 'package:provider/provider.dart';

class RichTextAndIcon extends StatelessWidget {
  const RichTextAndIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    return Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: 25,
          right: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Howdy, What Are You\n Looking For',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Brand-Bold',
                    ),
                  ),
                  TextSpan(
                    text: '👀',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                      child: SvgPicture.asset('assets/icons/cart.svg')),
                ),
                Positioned(
                  left: 18,
                  child: _cartProvider.getCartItem.isNotEmpty
                      ? Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade900,
                            shape: BoxShape.circle,
                          ),
                        )
                      : Container(),
                ),
              ],
            )
          ],
        ));
  }
}
