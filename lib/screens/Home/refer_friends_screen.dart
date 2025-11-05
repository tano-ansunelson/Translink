import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReferFriendScreen extends StatelessWidget {
  const ReferFriendScreen({super.key});
  static const String id = 'refer_friend_screen';

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
          'Refer a Friend',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8F0),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.group,
                      size: 60,
                      color: Colors.orange[700],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Title
                  const Text(
                    'Invite Friends, Get\nRewards',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Description
                  Text(
                    'Share your code with friends. When they sign up and complete their first trip, you both get a bonus!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Referral Code Section
                  Column(
                    children: [
                      Text(
                        'YOUR REFERRAL CODE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'TLNK2024GH',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 2,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                  const ClipboardData(text: 'TLNK2024GH'),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Code copied to clipboard!'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.content_copy,
                                color: Colors.grey[600],
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  // Share Section
                  Column(
                    children: [
                      Text(
                        'SHARE YOUR LINK',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildShareButton(icon: Icons.message, onTap: () {}),
                          const SizedBox(width: 20),
                          _buildShareButton(icon: Icons.link, onTap: () {}),
                          const SizedBox(width: 20),
                          _buildShareButton(icon: Icons.share, onTap: () {}),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Bottom Button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Invite Friends',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8F0),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFFFF9800), size: 32),
      ),
    );
  }
}
