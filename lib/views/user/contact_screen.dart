import 'package:flutter/material.dart';
import 'package:gadgetshop/core/utils/app_constant.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppConstant.appTextColor,
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          "Contact Us",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppConstant.appTextColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppConstant.appMainColor.withValues(alpha: 0.1),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.headset_mic,
                    size: 80,
                    color: AppConstant.appMainColor,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Get in Touch',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We\'re here to help you',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Contact Information Cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Email Card
                  _buildContactCard(
                    icon: Icons.email,
                    title: 'Email',
                    subtitle: 'support@gadgetshop.com',
                  ),
                  const SizedBox(height: 12),

                  // Phone Card
                  _buildContactCard(
                    icon: Icons.phone,
                    title: 'Phone',
                    subtitle: '+977 1234567890',
                  ),
                  const SizedBox(height: 12),

                  // Location Card
                  _buildContactCard(
                    icon: Icons.location_on,
                    title: 'Address',
                    subtitle: 'Kathmandu, Nepal',
                  ),
                  const SizedBox(height: 12),

                  // Website Card
                  _buildContactCard(
                    icon: Icons.language,
                    title: 'Website',
                    subtitle: 'www.gadgetshop.com',
                  ),
                  const SizedBox(height: 32),

                  // Business Hours
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: AppConstant.appMainColor,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Business Hours',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          _buildHourRow('Monday - Friday', '9:00 AM - 6:00 PM'),
                          const SizedBox(height: 8),
                          _buildHourRow('Saturday', '10:00 AM - 4:00 PM'),
                          const SizedBox(height: 8),
                          _buildHourRow('Sunday', 'Closed'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Social Media
                  const Text(
                    'Follow Us',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(Icons.facebook, Colors.blue[700]!),
                      const SizedBox(width: 16),
                      _buildSocialButton(Icons.camera_alt, Colors.pink),
                      const SizedBox(width: 16),
                      _buildSocialButton(Icons.send, Colors.blue),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Footer
                  Text(
                    "All Rights Reserved © GadgetShop 2025",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppConstant.appMainColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppConstant.appMainColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHourRow(String day, String hours) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        Text(
          hours,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, Color color) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }
}
