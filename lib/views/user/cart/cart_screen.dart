import 'package:flutter/material.dart';
import 'package:gadgetshop/core/utils/app_constant.dart';
import 'package:get/route_manager.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appStatusBarColor),
        backgroundColor: AppConstant.appSecondaryColor,
        title: Text(
          "Cart Screen",
          style: TextStyle(fontSize: 25, color: AppConstant.appTextColor),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: ListView.builder(
          itemCount: 250,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Card(
              color: AppConstant.appTextColor,
              elevation: 5,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red.shade500,
                  child: Text(
                    "G",
                    style: TextStyle(color: AppConstant.appTextColor),
                  ),
                ),
                title: Text("Cart Data Testing"),
                subtitle: Row(
                  children: [
                    Text("Rs. 2000"),
                    SizedBox(width: Get.width / 30),
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.red.shade500,
                      child: Text(
                        "+",
                        style: TextStyle(color: AppConstant.appTextColor),
                      ),
                    ),
                    SizedBox(width: Get.width / 40),
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.red.shade500,
                      child: Text(
                        "-",
                        style: TextStyle(color: AppConstant.appTextColor),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            children: [
              Text(
                "Total",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(width: Get.width / 40),
              Text(
                "Rs.50,000",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(width: Get.width / 3.2),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  backgroundColor: AppConstant.appSecondaryColor,
                  foregroundColor: AppConstant.appTextColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  "Checkout",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
