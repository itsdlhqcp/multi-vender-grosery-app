import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_grocery_shop/vendor/provider/product_vendor.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ImagesScren extends StatefulWidget {
  @override
  State<ImagesScren> createState() => _ImagesScrenState();
}

class _ImagesScrenState extends State<ImagesScren>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<File> _image = [];

  List<String> _imagesList = [];

  final picker = ImagePicker();

  chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      print('pick image');
    } else {
      setState(() {
        _image.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvder _prodouctProvider =
        Provider.of<ProductProvder>(context);
    return Scaffold(
      body: Form(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: _image.length + 1,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 3 / 3,
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8),
                    itemBuilder: (context, index) {
                      return index == 0
                          ? Center(
                              child: IconButton(
                              icon: Icon(
                                Icons.add,
                              ),
                              onPressed: () {
                                chooseImage();
                              },
                            ))
                          : Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(_image[index - 1]),
                                ),
                              ),
                            );
                    }),
              ),
            ),
            TextButton(
              onPressed: () async {
                EasyLoading.show();
                for (var img in _image) {
                  Reference ref =
                      _storage.ref().child('productImages').child(Uuid().v4());

                  await ref.putFile(img).whenComplete(() async {
                    await ref.getDownloadURL().then((value) {
                      setState(() {
                        _imagesList.add(value);
                        _prodouctProvider.getFormData(imagesList: _imagesList);
                        EasyLoading.dismiss();
                      });
                    });
                  });
                }
              },
              child: Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
