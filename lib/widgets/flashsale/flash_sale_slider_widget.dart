import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gadgetshop/models/products_model.dart';
import 'package:gadgetshop/core/utils/app_constant.dart';
import 'package:gadgetshop/views/user/products/products_detail_screen.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

class FlashSaleWidget extends StatelessWidget {
  const FlashSaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("products")
          .where("isSale", isEqualTo: true)
          .get(),
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
            height: Get.height / 5.5,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final productData = snapshot.data!.docs[index];
                ProductModel productsModel = ProductModel(
                  productId: productData['productId'],
                  categoryId: productData["categoryId"],
                  productName: productData["productName"],
                  categoryName: productData["categoryName"],
                  salePrice: productData["salePrice"],
                  fullPrice: productData["fullPrice"],
                  productImages: productData["productImages"],
                  deliveryTime: productData["deliveryTime"],
                  isSale: productData["isSale"],
                  productDescription: productData["productDescription"],
                  createdAt: productData["createdAt"],
                  updatedAt: productData["updatedAt"],
                );
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(() =>
                          ProductsDetailScreen(productModel: productsModel)),
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: FillImageCard(
                          borderRadius: 20.0,
                          width: Get.width / 2,
                          heightImage: Get.height / 10,
                          imageProvider: CachedNetworkImageProvider(
                              productsModel.productImages[0]),
                          title: Center(
                            child: Text(
                              productsModel.productName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          footer: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Rs ${productsModel.salePrice}",
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                              SizedBox(width: 2),
                              Text(
                                "Rs ${productsModel.fullPrice}",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: AppConstant.appSecondaryColor,
                                    decoration: TextDecoration.lineThrough),
                              )
                            ],
                          ),
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
