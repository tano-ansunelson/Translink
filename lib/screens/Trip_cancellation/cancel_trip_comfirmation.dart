import 'package:flutter/material.dart';
import 'package:translink/screens/Trip_cancellation/trip_cancellation_reason_sheet.dart';

class CancelTripConfirmationScreen extends StatelessWidget {
  const CancelTripConfirmationScreen({super.key});
  static const String id = 'cancel_trip_confirmation_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.black, size: 28),
        ),
        title: const Text(
          'Cancel Trip',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Warning Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE8D6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFFFA500),
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Title
                  const Text(
                    'Are you sure you\nwant to cancel?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Trip Details
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                      children: const [
                        TextSpan(
                          text: 'You are about to cancel your trip from\n',
                        ),
                        TextSpan(
                          text: 'Accra',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        TextSpan(text: ' to '),
                        TextSpan(
                          text: 'Kumasi',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        TextSpan(text: ' on 25 Oct.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // // Cancellation Policy Card
                  // Container(
                  //   width: double.infinity,
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(20),
                  //     border: Border.all(color: Colors.grey.shade200, width: 1),
                  //   ),
                  //   padding: const EdgeInsets.all(24),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       const Text(
                  //         'Cancellation Fee May Apply',
                  //         style: TextStyle(
                  //           fontSize: 17,
                  //           fontWeight: FontWeight.bold,
                  //           color: Colors.black87,
                  //         ),
                  //       ),
                  //       const SizedBox(height: 12),
                  //       Text(
                  //         'Cancellations within 24 hours of departure are subject to a fee. Review the full policy for details.',
                  //         style: TextStyle(
                  //           fontSize: 14,
                  //           color: Colors.grey.shade600,
                  //           height: 1.5,
                  //         ),
                  //       ),
                  //       const SizedBox(height: 16),
                  //       GestureDetector(
                  //         onTap: () {
                  //           // Navigate to cancellation policy
                  //         },
                  //         child: Row(
                  //           children: [
                  //             const Text(
                  //               'View Cancellation Policy',
                  //               style: TextStyle(
                  //                 fontSize: 15,
                  //                 fontWeight: FontWeight.w600,
                  //                 color: Color(0xFFFFA500),
                  //               ),
                  //             ),
                  //             const SizedBox(width: 8),
                  //             const Icon(
                  //               Icons.arrow_forward,
                  //               color: Color(0xFFFFA500),
                  //               size: 20,
                  //             ),
                  //           ],
                  //         ),
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
                // Confirm Cancellation Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        TripCancellationReasonSheet.id,
                      );
                      // Show cancellation reason sheet
                      // Then navigate to success screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE53E3E),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Confirm Cancellation',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Go Back Button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Go Back',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
