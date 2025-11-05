import 'package:flutter/material.dart';
import 'package:translink/screens/Bottom_Navigation/bottombar_navigation_screen.dart';

class TripCancelledScreen extends StatelessWidget {
  const TripCancelledScreen({super.key});
  static const String id = 'trip_cancelled_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Success Icon
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1FAE5),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Title
                    const Text(
                      'Your Trip Has Been\nCancelled',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Subtitle
                    Text(
                      'Your trip to Kumasi on October 28th is\nsuccessfully cancelled.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Refund Details Card
                    // Container(
                    //   width: double.infinity,
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(20),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.grey.shade200,
                    //         blurRadius: 15,
                    //         offset: const Offset(0, 5),
                    //       ),
                    //     ],
                    //   ),
                    //   padding: const EdgeInsets.all(24),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       const Text(
                    //         'REFUND DETAILS',
                    //         style: TextStyle(
                    //           fontSize: 13,
                    //           fontWeight: FontWeight.w700,
                    //           color: Color(0xFF1F2937),
                    //           letterSpacing: 0.5,
                    //         ),
                    //       ),
                    //       const SizedBox(height: 24),

                    //       // Refund Amount
                    //       _buildRefundRow(
                    //         icon: Icons.account_balance_wallet_outlined,
                    //         iconColor: const Color(0xFFFFA500),
                    //         label: 'Refund Amount',
                    //         value: 'GH₵ 75.00',
                    //       ),
                    //       const SizedBox(height: 20),

                    //       // Sent To
                    //       _buildRefundRow(
                    //         icon: Icons.credit_card_rounded,
                    //         iconColor: const Color(0xFFFFA500),
                    //         label: 'Sent to',
                    //         value: 'Visa **** 4242',
                    //       ),
                    //       const SizedBox(height: 20),

                    //       // Estimated Time
                    //       _buildRefundRow(
                    //         icon: Icons.hourglass_empty_rounded,
                    //         iconColor: const Color(0xFFFFA500),
                    //         label: 'Estimated Time',
                    //         value: '3-5 business days',
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),

              // Action Buttons
              Column(
                children: [
                  // Find New Trip Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, TransLinkBottomNav.id);
                        // Navigate to booking screen
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF97316),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Find a New Trip',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 42),

                  // // Back to My Trips Button
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: OutlinedButton(
                  //     onPressed: () {
                  //       // Navigate back to trips
                  //       Navigator.pop(context);
                  //     },
                  //     style: OutlinedButton.styleFrom(
                  //       padding: const EdgeInsets.symmetric(vertical: 18),
                  //       side: const BorderSide(
                  //         color: Color(0xFFF97316),
                  //         width: 2,
                  //       ),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(16),
                  //       ),
                  //     ),
                  //     child: const Text(
                  //       'Back to My Trips',
                  //       style: TextStyle(
                  //         fontSize: 17,
                  //         fontWeight: FontWeight.w700,
                  //         color: Color(0xFFF97316),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildRefundRow({
  //   required IconData icon,
  //   required Color iconColor,
  //   required String label,
  //   required String value,
  // }) {
  //   return Row(
  //     children: [
  //       Icon(icon, color: iconColor, size: 24),
  //       const SizedBox(width: 12),
  //       Expanded(
  //         child: Text(
  //           label,
  //           style: TextStyle(
  //             fontSize: 15,
  //             color: Colors.grey.shade700,
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //       ),
  //       Text(
  //         value,
  //         style: const TextStyle(
  //           fontSize: 15,
  //           fontWeight: FontWeight.w600,
  //           color: Color(0xFF1F2937),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
