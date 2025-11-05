import 'package:flutter/material.dart';
import 'package:translink/screens/Registration_screen/login_screen.dart';
import 'package:translink/screens/Registration_screen/signup_screen.dart';

class TransLinkLandingPage extends StatefulWidget {
  const TransLinkLandingPage({super.key});
  static const String id = 'landing_page';

  @override
  State<TransLinkLandingPage> createState() => _TransLinkLandingPageState();
}

class _TransLinkLandingPageState extends State<TransLinkLandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hero Illustration Section
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [const Color(0xFFFFF8F0), Colors.white],
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 24,
                ),
                child: Column(
                  children: [
                    // Logo/Brand Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFFFA500), Color(0xFFFF8C00)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFA500).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.directions_car_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Illustration Card
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 400),
                      height: 280,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Background gradient
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFFFFF8F0),
                                  const Color(0xFFFFE8D6),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),

                          // Illustration
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: CustomPaint(
                                painter: ModernIllustrationPainter(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Content Section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 40,
                ),
                child: Column(
                  children: [
                    // Brand Name
                    const Text(
                      'TransLink',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFFA500),
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Main Heading
                    const Text(
                      'Connect, Travel, and\nDeliver with Ease',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.3,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Subtitle
                    Text(
                      'Join our community of travelers and drivers.\nYour journey begins here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        height: 1.6,
                      ),
                    ),
                    //const SizedBox(height: 48),

                    // Feature Pills
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     _buildFeaturePill(
                    //       Icons.verified_user_rounded,
                    //       'Secure',
                    //     ),
                    //     const SizedBox(width: 12),
                    //     _buildFeaturePill(Icons.flash_on_rounded, 'Fast'),
                    //     const SizedBox(width: 12),
                    //     _buildFeaturePill(Icons.favorite_rounded, 'Reliable'),
                    //   ],
                    // ),
                    const SizedBox(height: 28),

                    // Sign Up Button
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFA500).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, SignUpScreen.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFA500),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Log In Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, LoginScreen.id);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFFA500),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          side: const BorderSide(
                            color: Color(0xFFFFA500),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Terms & Privacy
                    Text(
                      'By continuing, you agree to our Terms of Service\nand Privacy Policy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildFeaturePill(IconData icon, String label) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFFFF8F0),
  //       borderRadius: BorderRadius.circular(20),
  //       border: Border.all(color: const Color(0xFFFFE8D6), width: 1.5),
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Icon(icon, color: const Color(0xFFFFA500), size: 18),
  //         const SizedBox(width: 6),
  //         Text(
  //           label,
  //           style: const TextStyle(
  //             fontSize: 13,
  //             fontWeight: FontWeight.w600,
  //             color: Color(0xFFFFA500),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class ModernIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Road
    paint.color = Colors.grey.shade300;
    final roadPath = Path();
    roadPath.moveTo(size.width * 0.2, size.height);
    roadPath.lineTo(size.width * 0.35, size.height * 0.5);
    roadPath.lineTo(size.width * 0.65, size.height * 0.5);
    roadPath.lineTo(size.width * 0.8, size.height);
    roadPath.close();
    canvas.drawPath(roadPath, paint);

    // Road markings
    paint.color = Colors.white;
    final dashHeight = size.height * 0.08;
    final dashWidth = 4.0;
    for (double i = 0.6; i < 1.0; i += 0.12) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(size.width * 0.5, size.height * i),
            width: dashWidth,
            height: dashHeight,
          ),
          const Radius.circular(2),
        ),
        paint,
      );
    }

    // Car
    _drawCar(canvas, size.width * 0.5, size.height * 0.55, size);

    // Buildings (left)
    _drawBuilding(
      canvas,
      size.width * 0.15,
      size.height * 0.35,
      size.width * 0.1,
      size.height * 0.25,
      const Color(0xFFE8D5C4),
    );
    _drawBuilding(
      canvas,
      size.width * 0.05,
      size.height * 0.45,
      size.width * 0.08,
      size.height * 0.2,
      const Color(0xFFD4B5A0),
    );

    // Buildings (right)
    _drawBuilding(
      canvas,
      size.width * 0.85,
      size.height * 0.35,
      size.width * 0.1,
      size.height * 0.25,
      const Color(0xFFD4B5A0),
    );
    _drawBuilding(
      canvas,
      size.width * 0.92,
      size.height * 0.45,
      size.width * 0.08,
      size.height * 0.2,
      const Color(0xFFE8D5C4),
    );

    // Trees
    _drawTree(canvas, size.width * 0.25, size.height * 0.55, 15);
    _drawTree(canvas, size.width * 0.75, size.height * 0.55, 15);

    // Sun
    paint.color = const Color(0xFFFFA500).withOpacity(0.3);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.15), 30, paint);
    paint.color = const Color(0xFFFFA500);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.15), 20, paint);
  }

  void _drawCar(Canvas canvas, double x, double y, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Car body
    paint.color = const Color(0xFFFFA500);
    final carBody = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(x, y),
        width: size.width * 0.15,
        height: size.height * 0.08,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(carBody, paint);

    // Car roof
    paint.color = const Color(0xFFFF8C00);
    final carRoof = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(x, y - size.height * 0.05),
        width: size.width * 0.09,
        height: size.height * 0.06,
      ),
      const Radius.circular(6),
    );
    canvas.drawRRect(carRoof, paint);

    // Windows
    paint.color = const Color(0xFF87CEEB).withOpacity(0.7);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(x - size.width * 0.015, y - size.height * 0.05),
          width: size.width * 0.035,
          height: size.height * 0.04,
        ),
        const Radius.circular(3),
      ),
      paint,
    );

    // Wheels
    paint.color = Colors.grey.shade800;
    canvas.drawCircle(
      Offset(x - size.width * 0.05, y + size.height * 0.04),
      8,
      paint,
    );
    canvas.drawCircle(
      Offset(x + size.width * 0.05, y + size.height * 0.04),
      8,
      paint,
    );
  }

  void _drawBuilding(
    Canvas canvas,
    double x,
    double y,
    double width,
    double height,
    Color color,
  ) {
    final paint = Paint()..color = color;

    // Building body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x - width / 2, y, width, height),
        const Radius.circular(4),
      ),
      paint,
    );

    // Windows
    paint.color = Colors.white.withOpacity(0.5);
    final windowSize = width * 0.15;
    //final spacing = width * 0.25;

    for (double row = 0.2; row < 0.8; row += 0.3) {
      for (double col = 0.2; col < 0.9; col += 0.4) {
        canvas.drawRect(
          Rect.fromLTWH(
            x - width / 2 + width * col,
            y + height * row,
            windowSize,
            windowSize * 0.8,
          ),
          paint,
        );
      }
    }
  }

  void _drawTree(Canvas canvas, double x, double y, double size) {
    final paint = Paint();

    // Trunk
    paint.color = const Color(0xFF8B6F47);
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(x, y + size * 0.3),
        width: size * 0.3,
        height: size * 0.6,
      ),
      paint,
    );

    // Foliage
    paint.color = const Color(0xFF4A7C5E);
    canvas.drawCircle(Offset(x, y - size * 0.2), size, paint);
    canvas.drawCircle(Offset(x - size * 0.5, y), size * 0.7, paint);
    canvas.drawCircle(Offset(x + size * 0.5, y), size * 0.7, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
