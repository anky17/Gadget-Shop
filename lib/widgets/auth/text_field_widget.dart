import 'package:flutter/material.dart';
import 'package:gadgetshop/core/utils/app_constant.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffix;
  const TextFieldWidget(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.prefixIcon,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.suffix});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 7, right: 7),
      child: TextFormField(
        controller: controller,
        cursorColor: AppConstant.appMainColor,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(prefixIcon),
            suffix: suffix,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            )),
      ),
    );
  }
}
