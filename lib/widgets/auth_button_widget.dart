import 'package:flutter/material.dart';
import 'package:gadgetshop/utils/app_constant.dart';
import 'package:get/get.dart';

class AuthButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  const AuthButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppConstant.appSecondaryColor,
    this.textColor = AppConstant.appTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        width: Get.width / 1.04,
        height: Get.height / 14,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: AppConstant.appSecondaryColor,
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(fontSize: 19, color: AppConstant.appTextColor),
          ),
        ),
      ),
    );
  }
}
