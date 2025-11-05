import 'package:flutter/material.dart';
import 'package:translink/screens/onboarding_screens/passenger_onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String id = 'splash_screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    // Navigate after splash duration
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                const TransLinkOnboardingPage() /* Replace with your next screen */,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Container
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFA500),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: CustomPaint(painter: TruckIconPainter()),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Title
              const Text(
                'TransLink',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 20),
              // Subtitle
              const Text(
                'Connecting Ghana, One Trip at a Time.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFCCCCCC),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TruckIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Truck cargo box (back part)
    canvas.drawRect(Rect.fromLTWH(centerX - 28, centerY - 12, 28, 16), paint);

    // Truck cabin (front part)
    canvas.drawRect(Rect.fromLTWH(centerX, centerY - 12, 18, 16), paint);

    // Cabin window
    canvas.drawRect(Rect.fromLTWH(centerX + 4, centerY - 8, 10, 6), paint);

    // Front wheel
    canvas.drawCircle(Offset(centerX + 12, centerY + 8), 4, paint);

    // Back wheel
    canvas.drawCircle(Offset(centerX - 20, centerY + 8), 4, paint);

    // Axle line connecting wheels
    canvas.drawLine(
      Offset(centerX - 20, centerY + 8),
      Offset(centerX + 12, centerY + 8),
      paint,
    );
  }

  @override
  bool shouldRepaint(TruckIconPainter oldDelegate) => false;
}
