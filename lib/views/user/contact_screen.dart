import 'package:flutter/material.dart';
import 'package:gadgetshop/core/utils/app_constant.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: AppConstant.appTextColor,
          backgroundColor: AppConstant.appMainColor,
          title: Text(
            "Contact Us",
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Text("All Right Reserved @GadgetShop",
                  style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}
