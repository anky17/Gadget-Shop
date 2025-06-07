import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gadgetshop/widgets/carousel_widget.dart';
import 'package:gadgetshop/widgets/category_slider_widget.dart';
import 'package:gadgetshop/widgets/customer_drawer_widget.dart';
import 'package:gadgetshop/widgets/flash_sale_widget.dart';
import 'package:gadgetshop/widgets/heading_widget.dart';
import 'package:get/get.dart';
import '../../utils/app_constant.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
              onTap: () {},
            ),
            CategorySliderWidget(),
            HeadingWidget(
              headingTitle: 'Flash Sale',
              headingSubtitle: 'According to your budget',
              buttonText: 'See more ->',
              onTap: () {},
            ),
            FlashSaleWidget(),
          ],
        ),
      ),
    );
  }
}
