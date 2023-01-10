// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:multi_grocery_shop/services/firebase_service.dart';
// import 'package:multi_grocery_shop/vendor/provider/product_vendor.dart';
// import 'package:intl/intl.dart';

// import 'package:provider/provider.dart';
// import 'package:uuid/uuid.dart';

// class ProductTab extends StatefulWidget {
//   const ProductTab({super.key});

//   @override
//   State<ProductTab> createState() => _ProductTabState();
// }

// class _ProductTabState extends State<ProductTab> {
//   late String productId;
//   final FirebaseService _firebaseService = FirebaseService();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
//   late String productName;
//   late double productPrice;
//   bool _chargeShipping = false;
//   DateTime? shippingDate;

//   late int quantity;
//   late String productDescription;
//   String? selectedCategory;

//   final List<String> _categoryList = [];

//   final ImagePicker _picker = ImagePicker();
//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   List<XFile>? imageList = [];
//   List<String> imageUrlList = [];
//   void pickProductImages() async {
//     try {
//       final pickedImages = await _picker.pickMultiImage(
//           maxHeight: 300, maxWidth: 300, imageQuality: 100);

//       setState(() {
//         imageList = pickedImages;
//       });
//     } catch (e) {}
//   }

//   @override
//   void initState() {
//     getCategories();
//     super.initState();
//   }

//   getCategories() {
//     _firebaseService.categories.get().then((value) {
//       value.docs.forEach((element) {
//         setState(() {
//           _categoryList.add(element['categoryName']);
//         });
//       });
//     });
//   }

//   Future<void> _uploadImages() async {
//     if (imageList!.isNotEmpty) {
//       try {
//         for (var image in imageList!) {
//           Reference ref =
//               _storage.ref().child('productImages').child(Uuid().v4());

//           await ref.putFile(File(image.path)).whenComplete(() async {
//             await ref.getDownloadURL().then((value) {
//               imageUrlList.add(value);
//             });
//           });
//         }
//       } catch (e) {
//         print(e);
//       }
//     } else {
//       print('Please Pick an Image');
//     }
//   }

//   void uploadData() async {
//     if (imageUrlList.isNotEmpty) {
//       CollectionReference productRef =
//           _firebaseFirestore.collection('products');

//       productId = Uuid().v4();

//       await productRef.doc(productId).set({
//         'productId': productId,
//         'productImage': imageUrlList,
//         'productName': productName,
//         'productPrice': productPrice,
//         'categoryName': selectedCategory,
//         'productDescription': productDescription,
//       }).whenComplete(() {
//         setState(() {
//           imageList = [];
//           imageUrlList = [];
//         });
//       });
//     }
//   }

//   uploadProduct() async {
//     await _uploadImages().whenComplete(() => uploadData());
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ProductProvider _productProvider =
//         Provider.of<ProductProvider>(context);
//     return Scaffold(
//       body: Consumer<ProductProvider>(
//         builder: (BuildContext context, _productProvider, Widget? child) {
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                       'Kindly Fill The Required Fields',
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 50,
//                     ),
//                     TextFormField(
//                       decoration: InputDecoration(
//                         labelText: 'Enter Product Name',
//                       ),
//                       onChanged: (value) {
//                         productName = value;
//                       },
//                     ),
//                     SizedBox(
//                       height: 50,
//                     ),
//                     TextFormField(
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Please Feilds must not be empty';
//                         } else {
//                           return null;
//                         }
//                       },
//                       decoration: InputDecoration(
//                         labelText: 'Enter Product Price',
//                       ),
//                       onChanged: (value) {
//                         productPrice = double.parse(value);
//                       },
//                     ),
//                     SizedBox(
//                       height: 50,
//                     ),
//                     DropdownButtonFormField(
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Please category must not be empty';
//                         } else {
//                           return null;
//                         }
//                       },
//                       hint: Text('Select Category'),
//                       value: selectedCategory,
//                       items: _categoryList.map<DropdownMenuItem<dynamic>>((e) {
//                         return DropdownMenuItem(
//                           child: Text(e),
//                           value: e,
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         setState(
//                           () {
//                             selectedCategory = value;
//                           },
//                         );
//                       },
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     Container(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           CheckboxListTile(
//                             title: Text(
//                               'Charge Shipping',
//                               style: TextStyle(fontSize: 19),
//                             ),
//                             value: _chargeShipping,
//                             onChanged: (value) {
//                               setState(
//                                 () {
//                                   _chargeShipping = value!;
//                                 },
//                               );
//                             },
//                           ),
//                           if (_chargeShipping == true)
//                             Padding(
//                               padding: const EdgeInsets.all(14.0),
//                               child: TextFormField(
//                                 keyboardType: TextInputType.number,
//                                 decoration: InputDecoration(
//                                   labelText: 'Shipping Charge',
//                                 ),
//                                 onChanged: (value) {},
//                               ),
//                             ),
//                           TextButton(
//                             onPressed: () {
//                               showDatePicker(
//                                 context: context,
//                                 initialDate: DateTime.now(),
//                                 firstDate: DateTime.now(),
//                                 lastDate: DateTime(5000),
//                               ).then((value) {
//                                 setState(() {
//                                   shippingDate = value;
//                                 });
//                               });
//                             },
//                             child: Text(
//                               'Set Shipping Date ?',
//                               style: TextStyle(
//                                 fontSize: 22,
//                                 color: Colors.yellow.shade900,
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           if (shippingDate != null)
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 DateFormat('yyyy-MM-dd')
//                                     .format(shippingDate!)
//                                     .toString(),
//                                 style: TextStyle(
//                                   color: Colors.cyan,
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                     Center(
//                       child: TextButton(
//                         onPressed: () {
//                           pickProductImages();
//                         },
//                         child: Text(
//                           'upload Images',
//                           style: TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       height: 100,
//                       child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: imageList!.length,
//                           itemBuilder: (context, index) {
//                             return Center(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(14.0),
//                                 child: Container(
//                                     height: 100,
//                                     child: Center(
//                                         child: Image.file(
//                                             File(imageList![index].path)))),
//                               ),
//                             );
//                           }),
//                     ),
//                     TextFormField(
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Please Feilds must not be empty';
//                         } else {
//                           return null;
//                         }
//                       },
//                       maxLength: 800,
//                       maxLines: 10,
//                       decoration: InputDecoration(
//                         labelText: 'Description',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(
//                             15,
//                           ),
//                         ),
//                       ),
//                       onChanged: (value) {
//                         productDescription = value;
//                       },
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//       bottomSheet: ElevatedButton(
//         child: Text('upload Products'),
//         onPressed: () {
//           uploadProduct();
//           print(imageUrlList);
//         },
//       ),
//     );
//   }
// }
