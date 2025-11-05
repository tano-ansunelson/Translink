import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  static const String id = 'notifications_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F5F5),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotificationCard(
            icon: Icons.check_circle_outline,
            iconColor: const Color(0xFFFF9800),
            backgroundColor: const Color(0xFFFFF8F0),
            title: 'Trip Confirmation',
            message: 'Your trip from Accra to Kumasi has been confirmed.',
            isError: false,
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            icon: Icons.local_shipping_outlined,
            iconColor: const Color(0xFFFF9800),
            backgroundColor: const Color(0xFFFFF8F0),
            title: 'Delivery Update',
            message: 'Your package to Tamale has been delivered.',
            isError: false,
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            icon: Icons.account_balance_wallet_outlined,
            iconColor: const Color(0xFFFF9800),
            backgroundColor: const Color(0xFFFFF8F0),
            title: 'Payment Received',
            message: 'Payment received for your trip to Cape Coast.',
            isError: false,
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            icon: Icons.explore_outlined,
            iconColor: const Color(0xFFFF9800),
            backgroundColor: const Color(0xFFFFF8F0),
            title: 'New Trip Available',
            message: 'New trip posted from Takoradi to Sunyani.',
            isError: false,
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            icon: Icons.cancel_outlined,
            iconColor: const Color(0xFFD32F2F),
            backgroundColor: const Color(0xFFFFEBEE),
            title: 'Trip Cancellation',
            message: 'Your trip to Ho has been cancelled.',
            isError: true,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required String message,
    required bool isError,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isError ? const Color(0xFFFFCDD2) : const Color(0xFFFFE0B2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isError ? const Color(0xFFD32F2F) : Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
