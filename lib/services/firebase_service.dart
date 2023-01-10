import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class FirebaseService {
  CollectionReference homeBanner = _firestore.collection('homeBanners');

  CollectionReference categories = _firestore.collection('categories');

  // Future<List> uploadImages(
  //     List<XFile>? images, String ref, ProductProvider productProvider) async {
  //   var imagesUrl = await Future.wait(images!.map((_image) {
  //     return uploadFiles(
  //       ref,
  //       File(
  //         _image.path,
  //       ),
  //     );
  //   }));

  //   productProvider.getFormData(imagesUrl: imagesUrl);
  //   return imagesUrl;
  // }

  // Future uploadFiles(
  //   String refImage,
  //   File? image,
  // ) async {
  //   Reference refUpload = _storage.ref().child('ProductImages').child(refImage);

  //   UploadTask uploadTask = refUpload.putFile(image!);

  //   await uploadTask;

  //   return refUpload.getDownloadURL();
  // }
}
