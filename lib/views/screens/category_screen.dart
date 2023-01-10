import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:multi_grocery_shop/models/category_models.dart';
import 'package:multi_grocery_shop/views/all_categories_products.dart';

class CategoryScreen extends StatefulWidget {
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String _title = 'Categories';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Colors.grey,
                size: 25,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: IconButton(
              onPressed: () {},
              icon: Icon(
                CupertinoIcons.shopping_cart,
                color: Colors.grey,
                size: 25,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_horiz,
                color: Colors.grey,
                size: 25,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: FirestoreListView<CategoryModels>(
            shrinkWrap: true,
            query: CategoryModelssCollection,
            itemBuilder: (context, snapshot) {
              CategoryModels categoryModels = snapshot.data();

              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AllCategoriesProduct(
                        categoryName: categoryModels.categoryName);
                  }));
                },
                child: Row(
                  children: [
                    SizedBox(
                      height: 150,
                      width: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                              categoryModels.categoryImage,
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      categoryModels.categoryName,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
