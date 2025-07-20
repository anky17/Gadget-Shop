import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gadgetshop/models/category_model.dart';
import 'package:gadgetshop/views/user/single_category_product_screen.dart';
import 'package:gadgetshop/utils/app_constant.dart';
import 'package:get/route_manager.dart';
import 'package:image_card/image_card.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        title: Text(
          "All Categories",
          style: TextStyle(color: AppConstant.appTextColor),
        ),
        backgroundColor: AppConstant.appMainColor,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection("categories").get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: Get.height / 5,
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No Category found"),
            );
          }

          if (snapshot.data != null) {
            return GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 4,
                  childAspectRatio: 1.19),
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                var doc = snapshot.data!.docs[index];
                CategoryModel categoriesModel = CategoryModel(
                  categoryId: doc['categoryId'],
                  categoryName: doc['categoryName'],
                  categoryImg: doc['categoryImg'],
                  createdAt: doc['createdAt'],
                  updatedAt: doc['updatedAt'],
                );
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(
                        () => SingleCategoryProductScreen(
                            categoryId: categoriesModel.categoryId),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: FillImageCard(
                          borderRadius: 20.0,
                          width: Get.width / 2.3,
                          heightImage: Get.height / 10,
                          imageProvider: CachedNetworkImageProvider(
                              categoriesModel.categoryImg),
                          title:
                              Center(child: Text(categoriesModel.categoryName)),
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
