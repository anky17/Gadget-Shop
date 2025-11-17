import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gadgetshop/core/utils/snackbar_utils.dart';
import 'package:gadgetshop/models/order_model.dart';
import 'package:get/get.dart';

class AdminOrderController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<OrderModel> orders = <OrderModel>[].obs;
  RxBool isLoading = false.obs;
  RxString selectedFilter = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  // Fetch all orders
  Future<void> fetchOrders({String? status}) async {
    try {
      isLoading.value = true;
      Query query = _firestore
          .collection('orders')
          .orderBy('createdAt', descending: true);

      if (status != null && status != 'all') {
        query = query.where('status', isEqualTo: status);
      }

      QuerySnapshot querySnapshot = await query.get();

      orders.value = querySnapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      showCustomSnackbar(title: 'Error', message: 'Failed to fetch orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      EasyLoading.show(status: 'Updating order status...');
      await _firestore.collection('orders').doc(orderId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await fetchOrders(
          status: selectedFilter.value == 'all' ? null : selectedFilter.value);
      EasyLoading.dismiss();
      showCustomSnackbar(
          title: 'Success', message: 'Order status updated to $status');
    } catch (e) {
      EasyLoading.dismiss();
      showCustomSnackbar(
          title: 'Error', message: 'Failed to update order status: $e');
    }
  }

  // Update payment status
  Future<void> updatePaymentStatus(String orderId, String paymentStatus) async {
    try {
      EasyLoading.show(status: 'Updating payment status...');
      await _firestore.collection('orders').doc(orderId).update({
        'paymentStatus': paymentStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await fetchOrders(
          status: selectedFilter.value == 'all' ? null : selectedFilter.value);
      EasyLoading.dismiss();
      showCustomSnackbar(title: 'Success', message: 'Payment status updated');
    } catch (e) {
      EasyLoading.dismiss();
      showCustomSnackbar(
          title: 'Error', message: 'Failed to update payment status: $e');
    }
  }

  // Get order statistics
  Map<String, int> getOrderStatistics() {
    return {
      'total': orders.length,
      'pending': orders.where((order) => order.status == 'pending').length,
      'processing':
          orders.where((order) => order.status == 'processing').length,
      'shipped': orders.where((order) => order.status == 'shipped').length,
      'delivered': orders.where((order) => order.status == 'delivered').length,
      'cancelled': orders.where((order) => order.status == 'cancelled').length,
    };
  }

  // Calculate total revenue
  double getTotalRevenue() {
    return orders
        .where((order) =>
            order.paymentStatus == 'paid' && order.status != 'cancelled')
        .fold(0.0, (total, order) => total + order.totalAmount);
  }
}
