import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gadgetshop/controllers/cart_controller.dart';
import 'package:gadgetshop/core/utils/app_constant.dart';
import 'package:gadgetshop/core/utils/snackbar_utils.dart';
import 'package:gadgetshop/models/order_model.dart';
import 'package:gadgetshop/models/user_model.dart';
import 'package:gadgetshop/views/user/home_screen.dart';
import 'package:gadgetshop/views/user/payment/payment_screen.dart';
import 'package:get/get.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CartController cartController = Get.find<CartController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String selectedPaymentMethod = 'Cash on Delivery';
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (userDoc.exists) {
          currentUser =
              UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
          nameController.text = currentUser!.username;
          phoneController.text = currentUser!.phone;
          addressController.text = currentUser!.userAddress;
          setState(() {});
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user data: $e');
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          'Checkout',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppConstant.appTextColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery Information
              _buildSectionTitle('Delivery Information'),
              const SizedBox(height: 12),

              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Delivery Address',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your delivery address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Payment Method
              _buildSectionTitle('Payment Method'),
              const SizedBox(height: 12),

              Card(
                child: RadioGroup<String>(
                  groupValue: selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value ?? selectedPaymentMethod;
                    });
                  },
                  child: Column(
                    children: [
                      ListTile(
                        leading: Radio<String>(
                          value: 'Cash on Delivery',
                          toggleable: true,
                        ),
                        title: const Text('Cash on Delivery'),
                        subtitle: const Text('Pay when you receive'),
                        onTap: () {
                          setState(() {
                            selectedPaymentMethod = 'Cash on Delivery';
                          });
                        },
                      ),
                      ListTile(
                        leading: Radio<String>(
                          value: 'eSewa',
                          toggleable: true,
                        ),
                        title: const Text('eSewa'),
                        subtitle: const Text('Pay securely with eSewa'),
                        onTap: () {
                          setState(() {
                            selectedPaymentMethod = 'eSewa';
                          });
                        },
                      ),
                      ListTile(
                        leading: Radio<String>(
                          value: 'Khalti',
                          toggleable: true,
                        ),
                        title: const Text('Khalti'),
                        subtitle: const Text('Pay securely with Khalti'),
                        onTap: () {
                          setState(() {
                            selectedPaymentMethod = 'Khalti';
                          });
                        },
                      ),
                      ListTile(
                        leading: Radio<String>(
                          value: 'Bank Transfer',
                          toggleable: true,
                        ),
                        title: const Text('Bank Transfer'),
                        subtitle: const Text('Transfer to our account'),
                        onTap: () {
                          setState(() {
                            selectedPaymentMethod = 'Bank Transfer';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Order Summary
              _buildSectionTitle('Order Summary'),
              const SizedBox(height: 12),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Obx(() => _buildSummaryRow(
                            'Items',
                            '${cartController.totalItemsQuantity}',
                          )),
                      const Divider(height: 24),
                      Obx(() => _buildSummaryRow(
                            'Subtotal',
                            'Rs. ${cartController.totalPrice.value.toStringAsFixed(0)}',
                          )),
                      const SizedBox(height: 8),
                      _buildSummaryRow('Delivery Fee', 'Free'),
                      const Divider(height: 24),
                      Obx(() => _buildSummaryRow(
                            'Total',
                            'Rs. ${cartController.totalPrice.value.toStringAsFixed(0)}',
                            isTotal: true,
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Place Order Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstant.appSecondaryColor,
                    foregroundColor: AppConstant.appTextColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Place Order',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppConstant.appMainColor,
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? AppConstant.appMainColor : Colors.black,
          ),
        ),
      ],
    );
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (cartController.cartItems.isEmpty) {
      showCustomSnackbar(title: 'Error', message: 'Your cart is empty');
      return;
    }

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      showCustomSnackbar(
          title: 'Error', message: 'Please login to place order');
      return;
    }

    // If eSewa or Khalti is selected, navigate to demo payment screen
    if (selectedPaymentMethod == 'eSewa' || selectedPaymentMethod == 'Khalti') {
      EasyLoading.dismiss();
      Get.to(() => PaymentScreen(
            amount: cartController.totalPrice.value,
            paymentMethod: selectedPaymentMethod,
            userName: nameController.text,
            userEmail: currentUser?.email ?? '',
            userPhone: phoneController.text,
            userAddress: addressController.text,
          ));
      return;
    }

    try {
      EasyLoading.show(status: 'Placing order...');

      // Create order ID
      final orderId = FirebaseFirestore.instance.collection('orders').doc().id;

      // Create order items from cart
      List<OrderItem> orderItems = cartController.cartItems.map((cartItem) {
        return OrderItem(
          productId: cartItem.productId,
          productName: cartItem.productName,
          productImage: cartItem.productImages[0],
          price: double.parse(
              cartItem.isSale ? cartItem.salePrice : cartItem.fullPrice),
          quantity: cartItem.productQuantity,
        );
      }).toList();

      // Create order
      OrderModel order = OrderModel(
        orderId: orderId,
        userId: userId,
        userName: nameController.text,
        userEmail: currentUser?.email ?? '',
        userPhone: phoneController.text,
        userAddress: addressController.text,
        items: orderItems,
        totalAmount: cartController.totalPrice.value,
        status: 'pending',
        paymentMethod: selectedPaymentMethod,
        paymentStatus:
            selectedPaymentMethod == 'Cash on Delivery' ? 'unpaid' : 'pending',
        createdAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
      );

      // Save order to Firebase
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .set(order.toMap());

      // Clear cart
      await cartController.clearCart();

      EasyLoading.dismiss();

      // Show success dialog
      Get.dialog(
        AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              const SizedBox(width: 8),
              const Text('Order Placed!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your order has been placed successfully.'),
              const SizedBox(height: 12),
              Text(
                'Order ID: ${orderId.substring(0, 8)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Total: Rs. ${cartController.totalPrice.value.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.appMainColor,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                Get.offAll(() => const HomeScreen());
              },
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      EasyLoading.dismiss();
      showCustomSnackbar(title: 'Error', message: 'Failed to place order: $e');
    }
  }
}
