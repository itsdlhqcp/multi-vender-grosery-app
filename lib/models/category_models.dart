import 'package:multi_grocery_shop/services/firebase_service.dart';

class CategoryModels {
  CategoryModels({required this.categoryName, required this.categoryImage});

  CategoryModels.fromJson(Map<String, Object?> json)
      : this(
          categoryName: json['categoryName']! as String,
          categoryImage: json['categoryImage']! as String,
        );

  final String categoryName;
  final String categoryImage;

  Map<String, Object?> toJson() {
    return {
      'categoryName': categoryName,
      'categoryImage': categoryImage,
    };
  }
}

FirebaseService _service = FirebaseService();

final CategoryModelssCollection = _service.categories
    .where('active', isEqualTo: true)
    .withConverter<CategoryModels>(
      fromFirestore: (snapshot, _) => CategoryModels.fromJson(snapshot.data()!),
      toFirestore: (movie, _) => movie.toJson(),
    );
