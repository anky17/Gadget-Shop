import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:gadgetshop/controllers/sign_up_controller.dart';
import 'package:gadgetshop/views/auth/sign_in_screen.dart';
import 'package:gadgetshop/core/utils/app_constant.dart';
import 'package:gadgetshop/core/utils/snackbar_utils.dart';
import 'package:gadgetshop/widgets/auth/auth_button_widget.dart';
import 'package:gadgetshop/widgets/auth/text_field_widget.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpController signUpController = Get.put(SignUpController());
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Sign Up ",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: AppConstant.appTextColor),
            ),
            backgroundColor: AppConstant.appSecondaryColor,
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: Get.height / 15),
                Text(
                  "Welcome to Gadget Shop",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: Get.height / 40),
                TextFieldWidget(
                  controller: emailController,
                  hintText: 'Enter your email',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFieldWidget(
                  controller: nameController,
                  hintText: 'Enter your name',
                  prefixIcon: Icons.person,
                  keyboardType: TextInputType.name,
                ),
                TextFieldWidget(
                  controller: phoneNoController,
                  hintText: 'Enter your phone number',
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.numberWithOptions(),
                ),
                Obx(
                  () => TextFieldWidget(
                    controller: passwordController,
                    hintText: 'Enter your password',
                    prefixIcon: Icons.lock,
                    obscureText: signUpController.isPasswordVisible.value,
                    keyboardType: TextInputType.text,
                    suffix: GestureDetector(
                      onTap: () {
                        signUpController.isPasswordVisible.toggle();
                      },
                      child: signUpController.isPasswordVisible.value
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                    ),
                  ),
                ),
                AuthButtonWidget(
                  text: "SIGN UP",
                  onPressed: () async {
                    String name = nameController.text.trim();
                    String email = emailController.text.trim();
                    String phone = phoneNoController.text.trim();
                    String password = passwordController.text.trim();
                    String userDeviceToken = '';
                    if (name.isEmpty ||
                        email.isEmpty ||
                        phone.isEmpty ||
                        password.isEmpty) {
                      showCustomSnackbar(
                          title: "Error",
                          message: "Please enter all the field!");
                    } else {
                      UserCredential? userCredential =
                          await signUpController.signUpMethod(
                              email, name, phone, password, userDeviceToken);
                      if (userCredential != null) {
                        showCustomSnackbar(
                            title: "Verification Email Sent",
                            message: "Please check your email!");
                        FirebaseAuth.instance.signOut();
                        Get.offAll(() => SignInScreen());
                      }
                    }
                  },
                ),
                SizedBox(height: Get.width / 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.offAll(() => SignInScreen());
                      },
                      child: Text(
                        'Sign In',
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
          ),
        );
      },
    );
  }
}
