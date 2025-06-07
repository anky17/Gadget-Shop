import 'dart:ui';
import 'package:gadgetshop/utils/app_constant.dart';
import 'package:get/get.dart';

void showCustomSnackbar({
  required String title,
  required String message,
  SnackPosition snackPosition = SnackPosition.BOTTOM,
  Color backgroundColor = AppConstant.appSecondaryColor,
  Color textColor = AppConstant.appTextColor,
  Duration duration = const Duration(seconds: 3),
}) {
  Get.snackbar(
    title,
    message,
    snackPosition: snackPosition,
    backgroundColor: backgroundColor,
    colorText: textColor,
    duration: duration,
  );
}
