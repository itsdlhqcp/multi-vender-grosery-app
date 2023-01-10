import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:multi_grocery_shop/vendor/provider/product_vendor.dart';
import 'package:provider/provider.dart';

class ShippingScreen extends StatefulWidget {
  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool? _chargeShipping = false;
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvder _productProvider =
        Provider.of<ProductProvder>(context);
    return Column(
      children: [
        CheckboxListTile(
          title: Text('Charge Shipping'),
          value: _chargeShipping,
          onChanged: (value) {
            setState(() {
              _chargeShipping = value;

              _productProvider.getFormData(chargeShipping: value);
            });
          },
        ),
        if (_chargeShipping == true)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: _formField(
                label: 'Shipping Charge',
                inputType: TextInputType.number,
                onChanged: (value) {
                  _productProvider.getFormData(
                      shippingCharge: int.parse(value));
                }),
          ),
      ],
    );
  }
}
