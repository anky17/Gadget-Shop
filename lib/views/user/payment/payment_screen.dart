import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gadgetshop/controllers/cart_controller.dart';
import 'package:gadgetshop/core/utils/app_constant.dart';
import 'package:gadgetshop/core/utils/snackbar_utils.dart';
import 'package:gadgetshop/models/order_model.dart';
import 'package:gadgetshop/views/user/home_screen.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String userAddress;
  final String paymentMethod;

  const PaymentScreen({
    super.key,
    required this.amount,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.userAddress,
    required this.paymentMethod,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final CartController cartController = Get.find<CartController>();
  bool isProcessing = false;

  Future<void> _processPayment() async {
    setState(() {
      isProcessing = true;
    });

    EasyLoading.show(status: 'Processing payment...');

    // Simulate payment processing (2 seconds)
    await Future.delayed(const Duration(seconds: 2));

    // Create order after successful payment
    await _createOrder();
  }

  Future<void> _createOrder() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      EasyLoading.dismiss();
      showCustomSnackbar(
          title: 'Error', message: 'Please login to place order');
      return;
    }

    try {
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
        userName: widget.userName,
        userEmail: widget.userEmail,
        userPhone: widget.userPhone,
        userAddress: widget.userAddress,
        items: orderItems,
        totalAmount: widget.amount,
        status: 'pending',
        paymentMethod: widget.paymentMethod,
        paymentStatus: 'paid', // Mark as paid for demo
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

      setState(() {
        isProcessing = false;
      });

      // Show success dialog
      _showSuccessDialog(orderId);
    } catch (e) {
      EasyLoading.dismiss();
      setState(() {
        isProcessing = false;
      });
      showCustomSnackbar(title: 'Error', message: 'Failed to create order: $e');
    }
  }

  void _showSuccessDialog(String orderId) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 30),
            const SizedBox(width: 8),
            const Text('Payment Success!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'Your payment was successful and order has been placed.'),
            const SizedBox(height: 12),
            Text(
              'Order ID: ${orderId.substring(0, 8)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Amount Paid: Rs. ${widget.amount.toStringAsFixed(0)}',
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
              Get.back(); // Close dialog
              Get.offAll(() => const HomeScreen());
            },
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEsewa = widget.paymentMethod.toLowerCase() == 'esewa';
    final paymentColor = isEsewa ? Colors.green : Colors.purple;
    final paymentIcon = isEsewa ? Icons.account_balance_wallet : Icons.payment;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          '${widget.paymentMethod} Payment',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppConstant.appTextColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payment Method Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: paymentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        paymentIcon,
                        color: paymentColor,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pay with ${widget.paymentMethod}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Fast, secure, and convenient',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Payment Details
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppConstant.appMainColor,
                      ),
                    ),
                    const Divider(height: 24),
                    _buildDetailRow('Name', widget.userName),
                    const SizedBox(height: 12),
                    _buildDetailRow('Phone', widget.userPhone),
                    const SizedBox(height: 12),
                    _buildDetailRow('Address', widget.userAddress),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      'Amount',
                      'Rs. ${widget.amount.toStringAsFixed(0)}',
                      isHighlighted: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Demo Notice
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue),
              ),
              child: Row(
                children: [
                  const Icon(Icons.school, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Educational Demo: This simulates payment without real transactions',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Pay Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isProcessing ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: paymentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.payment, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            'Pay Rs. ${widget.amount.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: isProcessing ? null : () => Get.back(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value,
      {bool isHighlighted = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: isHighlighted ? 18 : 14,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
              color: isHighlighted ? AppConstant.appMainColor : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
