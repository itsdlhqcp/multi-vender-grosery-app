import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:image_picker/image_picker.dart';
import 'package:multi_grocery_shop/vendor/landing_screen.dart';

import 'package:uuid/uuid.dart';

class VendorRegisterationScreen extends StatefulWidget {
  const VendorRegisterationScreen({super.key});

  @override
  State<VendorRegisterationScreen> createState() =>
      _VendorRegisterationScreenState();
}

class _VendorRegisterationScreenState extends State<VendorRegisterationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String? countryValue;
  String? stateValue;
  String? cityValue;

  late String _bussinessName;
  late String landMark;

  late String phone;
  late String email;
  late String gstNumber;

  String? _taxStatus;

  Uint8List? _image;
  @override
  Widget build(BuildContext context) {
    const List<String> list = <String>[
      'YES',
      'NO',
    ];

    pickImage(ImageSource source) async {
      final ImagePicker _imagePicker = ImagePicker();

      XFile? _file = await _imagePicker.pickImage(source: source);

      if (_file != null) {
        return _file.readAsBytes();
      } else {
        print('No Image Sellected');
      }
    }

    pickImageFromGallery() async {
      Uint8List? im = await pickImage(ImageSource.gallery);
      setState(() {
        _image = im;
      });
    }

    _uploadImageToStorage(Uint8List? image) async {
      Reference ref = _firebaseStorage.ref().child('Vendor').child(Uuid().v4());

      UploadTask uploadTask = ref.putData(image!);
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();

      return downloadUrl;
    }

    vendorRegisterVendor() async {
      EasyLoading.show();
      if (_formKey.currentState!.validate()) {
        if (_image != null) {
          String imageUrl = await _uploadImageToStorage(_image);

          await FirebaseFirestore.instance
              .collection('vendors')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set({
            'storeImage': imageUrl,
            'bussinessName': _bussinessName,
            'mobile': phone,
            'email': email,
            'taxRegistered': _taxStatus,
            'tinNumber': gstNumber,
            'landMark': landMark,
            'country': countryValue,
            'state': stateValue,
            'city': cityValue,
            'aprroved': false,
            'vendorId': FirebaseAuth.instance.currentUser!.uid,
            'date': DateTime.now(),
          }).whenComplete(() {
            EasyLoading.dismiss();
            setState(() {
              EasyLoading.dismiss();
              _formKey.currentState!.reset();

              _image = null;

              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return LandingScreen();
              }));
            });
          });
        } else {
          setState(() {
            EasyLoading.dismiss();
          });
        }
      } else {
        setState(() {
          EasyLoading.dismiss();
        });
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 200,
            flexibleSpace: LayoutBuilder(builder: (context, constraints) {
              return FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.yellow,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: _image != null
                              ? Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.memory(
                                      _image!,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      height: double.infinity,
                                    ),
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    pickImageFromGallery();
                                  },
                                  icon: Icon(
                                    Icons.upload,
                                    size: 35,
                                  ),
                                ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        IconButton(
                          onPressed: () {
                            pickImageFromGallery();
                          },
                          icon: Icon(
                            Icons.upload,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Bussiness Name field must not be empty';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Bussiness Name',
                          hintText: 'Enter Bussiness Name',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _bussinessName = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Phone Number field must not be empty';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          hintText: 'Enter Phone Number',
                        ),
                        onChanged: (value) {
                          setState(() {
                            phone = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email Addresss field must not be empty';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          hintText: 'Enter Email Address',
                        ),
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Tax Registered?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Flexible(
                              child: Container(
                                width: 100,
                                child: DropdownButtonFormField(
                                  hint: Text('Select'),
                                  items: list.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _taxStatus = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_taxStatus == 'YES')
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'GST number field must not be empty';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'GST number',
                            hintText: 'GST number',
                          ),
                          onChanged: (value) {
                            setState(() {
                              gstNumber = value;
                            });
                          },
                        ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Pin Code field must not be empty';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Pin Code',
                          hintText: 'Pin Code',
                        ),
                        onChanged: (value) {
                          setState(() {
                            landMark = value;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SelectState(
                          onCountryChanged: (value) {
                            setState(() {
                              countryValue = value;
                            });
                          },
                          onStateChanged: (value) {
                            setState(() {
                              stateValue = value;
                            });
                          },
                          onCityChanged: (value) {
                            setState(() {
                              cityValue = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  20,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    vendorRegisterVendor();
                  },
                  child: Text(
                    'Reigster',
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
