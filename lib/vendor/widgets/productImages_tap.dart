// import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:multi_grocery_shop/vendor/provider/product_vendor.dart';
// import 'package:provider/provider.dart';
// import 'package:uuid/uuid.dart';

// class ProductImages extends StatefulWidget {
//   const ProductImages({super.key});

//   @override
//   State<ProductImages> createState() => _ProductImagesState();
// }

// class _ProductImagesState extends State<ProductImages> {
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

//   Future<void> _uploadImages() async {
//     if (imageList!.isNotEmpty) {
//       try {
//         for (var image in imageList!) {
//           Reference ref =
//               _storage.ref().child('productImages').child(Uuid().v4());

//           ref.putFile(File(image.path)).whenComplete(() async {
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ListView(
//           children: [
//             TextButton(
//               onPressed: () {
//                 pickProductImages();
//               },
//               child: Center(
//                 child: Text(
//                   'Upload Product Images',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 50,
//             ),
//             Container(
//               height: 240,
//               child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: imageList!.length,
//                   itemBuilder: (context, index) {
//                     return Center(
//                       child: Padding(
//                         padding: const EdgeInsets.all(14.0),
//                         child: Container(
//                           height: 100,
//                           child: Image.file(
//                             File(imageList![index].path),
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
