import 'package:flutter/material.dart';
import 'package:gadgetshop/controllers/admin_order_controller.dart';
import 'package:gadgetshop/core/utils/app_constant.dart';
import 'package:gadgetshop/models/order_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  OrderDetailsScreen({super.key, required this.order});

  final AdminOrderController controller = Get.find<AdminOrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppConstant.appTextColor,
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          'Order Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppConstant.appTextColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID
            _buildSectionTitle('Order Information'),
            _buildInfoRow('Order ID', order.orderId),
            _buildInfoRow('Order Date', _formatDate(order.createdAt)),
            if (order.updatedAt != null)
              _buildInfoRow('Last Updated', _formatDate(order.updatedAt)),

            const SizedBox(height: 24),

            // Customer Information
            _buildSectionTitle('Customer Information'),
            _buildInfoRow('Name', order.userName),
            _buildInfoRow('Email', order.userEmail),
            _buildInfoRow('Phone', order.userPhone),
            _buildInfoRow('Address', order.userAddress),

            const SizedBox(height: 24),

            // Order Status
            _buildSectionTitle('Order Status'),
            _buildStatusSelector(),

            const SizedBox(height: 24),

            // Payment Information
            _buildSectionTitle('Payment Information'),
            _buildInfoRow('Payment Method', order.paymentMethod),
            _buildPaymentStatusSelector(),
            _buildInfoRow(
                'Total Amount', '\$${order.totalAmount.toStringAsFixed(2)}'),

            const SizedBox(height: 24),

            // Order Items
            _buildSectionTitle('Order Items'),
            ...order.items.map((item) => _buildOrderItem(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppConstant.appMainColor,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSelector() {
    final statuses = [
      'pending',
      'processing',
      'shipped',
      'delivered',
      'cancelled'
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Update Status:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: statuses.map((status) {
                final isSelected = order.status == status;
                return ChoiceChip(
                  label: Text(status.toUpperCase()),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected && !isSelected) {
                      _showStatusUpdateConfirmation(status);
                    }
                  },
                  checkmarkColor: Colors.white,
                  selectedColor: AppConstant.appMainColor,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentStatusSelector() {
    final statuses = ['unpaid', 'paid', 'refunded'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Status:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: statuses.map((status) {
                final isSelected = order.paymentStatus == status;
                return ChoiceChip(
                  label: Text(status.toUpperCase()),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected && !isSelected) {
                      controller.updatePaymentStatus(order.orderId, status);
                    }
                  },
                  selectedColor: AppConstant.appMainColor,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.productImage,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Qty: ${item.quantity}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Text(
              '\$${item.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstant.appMainColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusUpdateConfirmation(String newStatus) {
    Get.dialog(
      AlertDialog(
        title: const Text('Update Order Status'),
        content: Text(
          'Are you sure you want to change the order status to "$newStatus"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.updateOrderStatus(order.orderId, newStatus);
            },
            child: Text(
              'Update',
              style: TextStyle(color: AppConstant.appMainColor),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic timestamp) {
    try {
      if (timestamp == null) return 'N/A';
      final date = timestamp.toDate();
      return DateFormat('MMM dd, yyyy hh:mm a').format(date);
    } catch (e) {
      return 'N/A';
    }
  }
}
