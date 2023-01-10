import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:multi_grocery_shop/services/firebase_service.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BannerWidget extends StatefulWidget {
  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final FirebaseService _service = FirebaseService();

  final List _bannerImages = [];

  getBanners() {
    return _service.homeBanner.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _bannerImages.add(doc['image']);
        });
      });
    });
  }

  @override
  void initState() {
    getBanners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: Card(
          elevation: 2,
          child: Container(
            height: 140,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: PageView.builder(
              itemCount: _bannerImages.length,
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: _bannerImages[index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer(
                    duration: Duration(seconds: 3), //Default value
                    interval: Duration(
                        seconds: 5), //Default value: Duration(seconds: 0)
                    color: Colors.grey.shade300, //Default value
                    colorOpacity: 0, //Default value
                    enabled: true, //Default value
                    direction: ShimmerDirection.fromLTRB(), //Default Value
                    child: Container(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
