import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gadgetshop/models/products_model.dart';
import 'package:gadgetshop/views/user/products/products_detail_screen.dart';
import 'package:gadgetshop/core/utils/app_constant.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

class AllFlashSaleScreen extends StatefulWidget {
  const AllFlashSaleScreen({super.key});

  @override
  State<AllFlashSaleScreen> createState() => _AllFlashSaleScreenState();
}

class _AllFlashSaleScreenState extends State<AllFlashSaleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        title: Text(
          "All Flash Sale Products",
          style: TextStyle(color: AppConstant.appTextColor),
        ),
        backgroundColor: AppConstant.appMainColor,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("products")
            .where('isSale', isEqualTo: true)
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
                        padding: EdgeInsets.all(8.0),
                        child: FillImageCard(
                          borderRadius: 20.0,
                          width: Get.width / 2.3,
                          heightImage: Get.height / 10,
                          imageProvider: CachedNetworkImageProvider(
                              productsModel.productImages[0]),
                          title: Center(child: Text(productsModel.productName)),
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
