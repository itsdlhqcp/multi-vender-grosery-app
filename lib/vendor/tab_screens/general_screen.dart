import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:multi_grocery_shop/vendor/provider/product_vendor.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

class GeneralScreen extends StatefulWidget {
  @override
  State<GeneralScreen> createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  String? selectedCategory;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Widget _formField(
      {String? label,
      void Function(String)? onChanged,
      inputType,
      int? minLine,
      int? maxLines}) {
    return TextFormField(
      keyboardType: inputType,
      decoration: InputDecoration(
        label: Text(label!),
      ),
      validator: ((value) {
        if (value!.isEmpty) {
          return label;
        } else {
          return null;
        }
      }),
      onChanged: onChanged,
      maxLines: maxLines,
      minLines: minLine,
    );
  }

  final List<String> _categoryList = [];

  @override
  void initState() {
    _getCategories();
    super.initState();
  }

  _getCategories() {
    return _firestore
        .collection('categories')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _categoryList.add(doc['categoryName']);
        });
      });
    });
  }

  String formatedDate(date) {
    var outputDateFormate = DateFormat('dd/MM/yyyy');

    var outputDate = outputDateFormate.format(date);

    return outputDate;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvder _productProvder = Provider.of<ProductProvder>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _formField(
                inputType: TextInputType.text,
                label: 'Enter Product Name',
                onChanged: (value) {
                  _productProvder.getFormData(productName: value);
                }),
            SizedBox(
              height: 20,
            ),
            _formField(
                label: 'Enter Product Price',
                inputType: TextInputType.number,
                onChanged: (value) {
                  _productProvder.getFormData(salesPrice: double.parse(value));
                }),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            _formField(
                label: 'Enter Product Quantity',
                inputType: TextInputType.number,
                onChanged: (value) {
                  _productProvder.getFormData(quantity: int.parse(value));
                }),
            DropdownButtonFormField(
                value: selectedCategory,
                hint: Text('Select Category'),
                items: _categoryList.map<DropdownMenuItem<String>>((e) {
                  return DropdownMenuItem(
                    child: Text(e),
                    value: e,
                  );
                }).toList(),
                onChanged: (value) {
                  selectedCategory = value;

                  _productProvder.getFormData(category: selectedCategory);
                }),
            SizedBox(
              height: 10,
            ),
            _formField(
                label: 'Enter Product Description',
                inputType: TextInputType.multiline,
                minLine: 3,
                maxLines: 10,
                onChanged: (value) {
                  _productProvder.getFormData(description: value);
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(5000))
                        .then((value) {
                      setState(() {
                        _productProvder.getFormData(scheduleDate: value);
                      });
                    });
                  },
                  child: Text(
                    'Schedule',
                  ),
                ),
                if (_productProvder.productData!['scheduleDate'] != null)
                  Text(
                    formatedDate(_productProvder.productData!['scheduleDate']),
                    style: TextStyle(
                      color: Colors.yellow.shade900,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
