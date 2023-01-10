import 'package:flutter/material.dart';
import 'package:multi_grocery_shop/vendor/provider/product_vendor.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

class ShippingTab extends StatefulWidget {
  const ShippingTab({super.key});

  @override
  State<ShippingTab> createState() => _ShippingTabState();
}

class _ShippingTabState extends State<ShippingTab> {
  bool _chargeShipping = false;
  DateTime? shippingDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              title: Text(
                'Charge Shipping',
                style: TextStyle(fontSize: 19),
              ),
              value: _chargeShipping,
              onChanged: (value) {
                setState(
                  () {
                    _chargeShipping = value!;
                  },
                );
              },
            ),
            if (_chargeShipping == true)
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Shipping Charge',
                  ),
                  onChanged: (value) {},
                ),
              ),
            TextButton(
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(5000),
                ).then((value) {
                  setState(() {
                    shippingDate = value;
                  });
                });
              },
              child: Text(
                'Set Shipping Date ?',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.yellow.shade900,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            if (shippingDate != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  DateFormat('yyyy-MM-dd').format(shippingDate!).toString(),
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
