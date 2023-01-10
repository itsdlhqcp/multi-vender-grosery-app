import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_grocery_shop/vendor/provider/cart_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic products;

  const ProductDetailScreen({super.key, required this.products});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String formatedDate(date) {
    var outputDateFormate = DateFormat('dd/MM/yyyy');

    var outputDate = outputDateFormate.format(date);

    return outputDate;
  }

  String? _selectedSize;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List productImages = widget.products['images'];
    final List productSize = widget.products['sizeList'];

    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white),
              height: 400,
              child: Stack(
                children: [
                  PageView(
                      children: productImages.map((e) {
                    return Container(
                      child: Image.network(
                        e,
                        fit: BoxFit.cover,
                      ),
                    );
                  }).toList()),
                  Positioned(
                    top: 35,
                    left: 10,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.yellow.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Text(
                '\$' + ' ' + widget.products['salesPrice'].toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 22,
                  letterSpacing: 8,
                  color: Colors.yellow.shade900,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              widget.products['productname'],
              style: TextStyle(
                fontSize: 22,
                letterSpacing: 8,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('View More'),
                  Text(
                    'Product Description',
                    style: TextStyle(
                      color: Colors.cyan,
                    ),
                  ),
                ],
              ),
              children: [
                Text(
                  widget.products['description'],
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Divider(
                color: Colors.grey,
                thickness: 1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'This Product Will Be Shipping on',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan),
                ),
                Text(
                  formatedDate(
                    widget.products['scheduleDate'].toDate(),
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow.shade900,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Divider(
                color: Colors.grey,
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  widget.products['quantity'] == 0
                      ? Text(
                          'Item Not in Stock',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            letterSpacing: 8,
                          ),
                        )
                      : Text(
                          'Item Left',
                          style: TextStyle(fontSize: 18),
                        ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: widget.products['quantity'] == 0
                          ? Text('')
                          : Text(
                              widget.products['quantity'].toString(),
                              style: TextStyle(
                                color: Colors.cyan,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Divider(
                color: Colors.grey,
                thickness: 1,
              ),
            ),
            ExpansionTile(
              title: Text(
                'Available Size',
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: productSize.map((e) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: OutlinedButton(
                            onPressed: () {},
                            child: Center(
                              child: Text(
                                e,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        widget.products['quantity'] != 0
            ? Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.yellow.shade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                      onPressed: () {
                        _cartProvider.addProductToCart(
                            widget.products['productId'],
                            widget.products['productname'],
                            widget.products['images'],
                            widget.products['salesPrice'],
                            widget.products['vendorId'],
                            widget.products['scheduleDate']);
                      },
                      child: Text(
                        'ADD TO CART',
                        style: TextStyle(letterSpacing: 9),
                      ),
                    ),
                  )
                ],
              )
            : Text(''),
      ],
    );
  }
}
