import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class VendorProductDetailScreen extends StatefulWidget {
  final dynamic products;
  VendorProductDetailScreen({super.key, required this.products});

  @override
  State<VendorProductDetailScreen> createState() =>
      _VendorProductDetailScreenState();
}

class _VendorProductDetailScreenState extends State<VendorProductDetailScreen> {
  final TextEditingController _productname = TextEditingController();
  final TextEditingController _brandName = TextEditingController();
  final TextEditingController _productPrice = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  final TextEditingController _category = TextEditingController();
  final TextEditingController _description = TextEditingController();

  @override
  void initState() {
    setState(() {
      _productname.text = widget.products['productname'];
      _brandName.text = widget.products['brand'];

      _productPrice.text = widget.products['salesPrice'].toString();
      _quantity.text = widget.products['quantity'].toString();
      _category.text = widget.products['category'];
      _description.text = widget.products['description'];
    });
    super.initState();
  }

  int? quantity;

  double? salesPrice;

  @override
  Widget build(BuildContext context) {
    final List productImages = widget.products['images'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade900,
        elevation: 0,
        title: Text(
          widget.products['productname'],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 400,
                width: double.infinity,
                child: PageView(
                  children: productImages.map((e) {
                    return Container(
                      child: Image.network(
                        e,
                        fit: BoxFit.fitHeight,
                      ),
                    );
                  }).toList(),
                ),
              ),
              TextFormField(
                controller: _productname,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                width: 100,
                child: TextFormField(
                  controller: _brandName,
                  decoration: InputDecoration(
                    labelText: 'Brand Name',
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Container(
                    width: 100,
                    child: Flexible(
                      child: TextFormField(
                        controller: _productPrice,
                        decoration: InputDecoration(
                          labelText: 'Product Price',
                        ),
                        onSaved: (value) {
                          salesPrice = double.parse(value!);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 100,
                    child: Flexible(
                      child: TextFormField(
                        controller: _quantity,
                        decoration: InputDecoration(
                          labelText: 'Quantity',
                        ),
                        onSaved: (value) {
                          quantity = int.parse(value!);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 100,
                    child: Flexible(
                      child: TextFormField(
                        enabled: false,
                        controller: _category,
                        decoration: InputDecoration(
                          labelText: 'Category',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              TextFormField(
                maxLines: 5,
                maxLength: 800,
                controller: _description,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () async {
                    EasyLoading.show(status: 'UPDATING');
                    await FirebaseFirestore.instance
                        .collection('products')
                        .doc(widget.products['productId'])
                        .update({
                      'productname': _productname.text,
                      'brand': _brandName.text,
                      // 'salesPrice': salesPrice,
                      // 'quantity': _quantity.text,
                    }).whenComplete(() {
                      EasyLoading.dismiss();
                    });
                  },
                  child: Text(
                    'Update',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
