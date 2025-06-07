import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:gadgetshop/controllers/forgot_password_controller.dart';
import 'package:gadgetshop/utils/app_constant.dart';
import 'package:gadgetshop/utils/snackbar_utils.dart';
import 'package:gadgetshop/widgets/auth_button_widget.dart';
import 'package:gadgetshop/widgets/text_field_widget.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final ForgotPasswordController forgotPasswordController =
      Get.put(ForgotPasswordController());
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppConstant.appSecondaryColor,
            centerTitle: true,
            title: Text(
              "Forgot Password",
              style: TextStyle(
                  color: AppConstant.appTextColor, fontWeight: FontWeight.bold),
            ),
          ),
          body: Column(
            children: [
              isKeyboardVisible
                  ? Text(
                      "Welcome to Gadget Shop",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    )
                  : Column(
                      children: [
                        Lottie.asset("assets/icons/splash-icon.json"),
                      ],
                    ),
              TextFieldWidget(
                controller: emailController,
                hintText: "Enter your email",
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              AuthButtonWidget(
                  text: 'Forgot',
                  onPressed: () {
                    String email = emailController.text.trim();

                    if (email.isEmpty) {
                      showCustomSnackbar(
                          title: "Error",
                          message: "Please enter all the details");
                    } else {
                      String email = emailController.text.trim();
                      forgotPasswordController.forgotPasswordMethod(email);
                    }
                  }),
            ],
          ),
        );
      },
    );
  }
}
