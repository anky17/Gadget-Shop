import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gadgetshop/models/category_model.dart';
import 'package:gadgetshop/views/user/single_category_product_screen.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

class CategorySliderWidget extends StatelessWidget {
  const CategorySliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
          return SizedBox(
            height: Get.height / 5,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                CategoryModel categoriesModel = CategoryModel(
                  categoryId: snapshot.data!.docs[index]['categoryId'],
                  categoryName: snapshot.data!.docs[index]['categoryName'],
                  categoryImg: snapshot.data!.docs[index]['categoryImg'],
                  createdAt: snapshot.data!.docs[index]['createdAt'],
                  updatedAt: snapshot.data!.docs[index]['updatedAt'],
                );
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(() => SingleCategoryProductScreen(
                            categoryId: categoriesModel.categoryId,
                          )),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: FillImageCard(
                          borderRadius: 20.0,
                          width: Get.width / 3,
                          heightImage: Get.height / 12,
                          imageProvider: CachedNetworkImageProvider(
                              categoriesModel.categoryImg),
                          title:
                              Center(child: Text(categoriesModel.categoryName)),
                          // footer: Text(""),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
