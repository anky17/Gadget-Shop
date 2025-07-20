import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gadgetshop/views/user/all_categories_screen.dart';
import 'package:gadgetshop/views/user/all_flash_sale_screen.dart';
import 'package:gadgetshop/views/user/all_products_screen.dart';
import 'package:gadgetshop/views/user/cart_screen.dart';
import 'package:gadgetshop/widgets/all_products_widget.dart';
import 'package:gadgetshop/widgets/carousel_widget.dart';
import 'package:gadgetshop/widgets/category_slider_widget.dart';
import 'package:gadgetshop/widgets/drawer_widget.dart';
import 'package:gadgetshop/widgets/flash_sale_slider_widget.dart';
import 'package:gadgetshop/widgets/heading_widget.dart';
import 'package:get/get.dart';
import '../../utils/app_constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appStatusBarColor),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppConstant.appSecondaryColor,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          AppConstant.appMainName,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: AppConstant.appTextColor),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Get.to(() => CartScreen()),
            icon: Icon(Icons.shopping_cart_checkout),
          )
        ],
      ),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: Get.height / 90),
            BannerWidget(),
            HeadingWidget(
              headingTitle: 'Categories',
              headingSubtitle: 'According to your budget',
              buttonText: 'See more ->',
              onTap: () => Get.to(() => AllCategoriesScreen()),
            ),
            CategorySliderWidget(),
            HeadingWidget(
              headingTitle: 'Flash Sale',
              headingSubtitle: 'According to your budget',
              buttonText: 'See more ->',
              onTap: () => Get.to(() => AllFlashSaleScreen()),
            ),
            FlashSaleWidget(),
            HeadingWidget(
              headingTitle: 'All Products',
              headingSubtitle: 'According to your budget',
              buttonText: 'See more ->',
              onTap: () => Get.to(() => AllProductsScreen()),
            ),
            AllProductsWidget(),
          ],
        ),
      ),
    );
  }
}
