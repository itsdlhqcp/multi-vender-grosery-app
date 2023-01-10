import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_grocery_shop/services/firebase_service.dart';
import 'package:multi_grocery_shop/vendor/provider/product_vendor.dart';
import 'package:intl/intl.dart';
import 'package:multi_grocery_shop/vendor/tab_screens/attributes_screen.dart';
import 'package:multi_grocery_shop/vendor/tab_screens/general_screen.dart';
import 'package:multi_grocery_shop/vendor/tab_screens/images_screen.dart';
import 'package:multi_grocery_shop/vendor/tab_screens/shipping_screen.dart';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _ProductTabState();
}

class _ProductTabState extends State<AddProductScreen> {
  late String productId;
  final FirebaseService _firebaseService = FirebaseService();

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late String productName;

  late double productPrice;

  DateTime? shippingDate;

  late int quantity;
  late String productDescription;
  String? selectedCategory;

  final List<String> _categoryList = [];

  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<XFile>? imageList = [];
  List<String> imageUrlList = [];
  void pickProductImages() async {
    try {
      final pickedImages = await _picker.pickMultiImage(
          maxHeight: 300, maxWidth: 300, imageQuality: 100);

      setState(() {
        imageList = pickedImages;
      });
    } catch (e) {}
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  getCategories() {
    _firebaseService.categories.get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          _categoryList.add(element['categoryName']);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProductProvder _productProvder = Provider.of<ProductProvder>(context);

    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.yellow.shade900,
            bottom: TabBar(tabs: [
              Tab(
                child: Text('General'),
              ),
              Tab(
                child: Text('Shipping'),
              ),
              Tab(
                child: Text('Attributes'),
              ),
              Tab(
                child: Text('Images'),
              ),
            ]),
          ),
          body: TabBarView(children: [
            GeneralScreen(),
            ShippingScreen(),
            AttributesScreen(),
            ImagesScren()
          ]),
          persistentFooterButtons: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.yellow.shade900,
                    ),
                    onPressed: () async {
                      EasyLoading.show();
                      if (_formKey.currentState!.validate()) {
                        final productId = Uuid().v1();
                        await _firebaseFirestore
                            .collection('products')
                            .doc(productId)
                            .set({
                          'productId': productId,
                          'vendorId': FirebaseAuth.instance.currentUser!.uid,
                          'productname':
                              _productProvder.productData!['productName'],
                          'images': _productProvder.productData!['imagesList'],
                          'category': _productProvder.productData!['category'],
                          'salesPrice':
                              _productProvder.productData!['salesPrice'],
                          'description':
                              _productProvder.productData!['description'],
                          'scheduleDate':
                              _productProvder.productData!['scheduleDate'],
                          'chargeShipping':
                              _productProvder.productData!['chargeShipping'],
                          'shippingCharge':
                              _productProvder.productData!['shippingCharge'],
                          'brand': _productProvder.productData!['brand'],
                          'sizeList': _productProvder.productData!['sizeList'],
                          'quantity': _productProvder.productData!['quantity'],
                          'approved': false,
                        }).whenComplete(() {
                          EasyLoading.dismiss();
                          _productProvder.productData!.clear();
                          _formKey.currentState!.reset();
                        });
                      }
                    },
                    child: Text('Save Product'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
