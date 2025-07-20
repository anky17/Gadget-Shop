import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:gadgetshop/controllers/sign_in_controller.dart';
import 'package:gadgetshop/views/auth/forgot_password_screen.dart';
import 'package:gadgetshop/views/auth/sign_up_screen.dart';
import 'package:gadgetshop/views/user/home_screen.dart';
import 'package:gadgetshop/utils/app_constant.dart';
import 'package:gadgetshop/utils/snackbar_utils.dart';
import 'package:gadgetshop/widgets/auth_button_widget.dart';
import 'package:gadgetshop/widgets/text_field_widget.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final SignInController signInController = Get.put(SignInController());
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Sign In ",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: AppConstant.appTextColor),
            ),
            backgroundColor: AppConstant.appSecondaryColor,
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
                hintText: 'Enter your email',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              Obx(
                () => TextFieldWidget(
                  controller: passwordController,
                  hintText: 'Enter your password',
                  prefixIcon: Icons.lock,
                  obscureText: signInController.isPasswordVisible.value,
                  suffix: GestureDetector(
                      onTap: () {
                        signInController.isPasswordVisible.toggle();
                      },
                      child: signInController.isPasswordVisible.value
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility)),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => ForgotPasswordScreen());
                  },
                  child: Text(
                    "Forgot Password",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppConstant.appSecondaryColor,
                    ),
                  ),
                ),
              ),
              AuthButtonWidget(
                text: 'SIGN IN',
                onPressed: () async {
                  String email = emailController.text.trim();
                  String password = passwordController.text.trim();

                  if (email.isEmpty || password.isEmpty) {
                    showCustomSnackbar(
                        title: "Error",
                        message: "Please enter the valid details");
                  } else {
                    UserCredential? userCredential =
                        await signInController.signInMethod(email, password);
                    if (userCredential != null) {
                      if (userCredential.user!.emailVerified) {
                        showCustomSnackbar(
                            title: "Success", message: "Login Successful");

                        Get.offAll(() => HomeScreen());
                      } else {
                        showCustomSnackbar(
                            title: "Error",
                            message: "Please verify your email before login!");
                      }
                    } else {
                      showCustomSnackbar(
                          title: "Error", message: "Please try again!");
                    }
                  }
                },
              ),
              SizedBox(height: Get.width / 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.offAll(() => SignUpScreen());
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
