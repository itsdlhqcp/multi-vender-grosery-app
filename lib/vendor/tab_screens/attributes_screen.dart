import 'package:flutter/material.dart';
import 'package:multi_grocery_shop/vendor/provider/product_vendor.dart';
import 'package:provider/provider.dart';

class AttributesScreen extends StatefulWidget {
  @override
  State<AttributesScreen> createState() => _AttributesScreenState();
}

class _AttributesScreenState extends State<AttributesScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool _save = false;

  bool entered = false;
  List<String> _sizeList = [];
  final TextEditingController _Sizecontroller = TextEditingController();
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
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _formField(
                label: 'Brand',
                onChanged: (value) {
                  _productProvider.getFormData(brand: value);
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    child: Container(
                        width: 100,
                        child: TextFormField(
                          controller: _Sizecontroller,
                          decoration: InputDecoration(label: Text('Size')),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                entered = true;
                                _save = false;
                              });
                            }
                          },
                        )),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  entered == true
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.yellow.shade900,
                          ),
                          onPressed: entered == false
                              ? null
                              : () {
                                  setState(() {
                                    _sizeList.add(_Sizecontroller.text);
                                    _Sizecontroller.clear();
                                    entered = false;
                                  });
                                },
                          child: Text('Add'),
                        )
                      : Text(''),
                ],
              ),
              if (_sizeList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 50,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _sizeList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _sizeList.removeAt(index);
                                  _productProvider.getFormData(
                                      sizeList: _sizeList);
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.yellow.shade800,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    _sizeList[index],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.pink,
                ),
                onPressed: () {
                  setState(() {
                    _productProvider.getFormData(sizeList: _sizeList);

                    _save = true;
                  });
                },
                child: _save ? Text('Saved') : Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
