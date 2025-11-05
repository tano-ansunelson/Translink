import 'package:flutter/material.dart';
import 'package:translink/screens/onboarding_screens/landing_screen.dart';

class TransLinkOnboardingPage extends StatefulWidget {
  const TransLinkOnboardingPage({super.key});
  static const String id = 'passenger_onboarding_page';

  @override
  State<TransLinkOnboardingPage> createState() =>
      _TransLinkOnboardingPageState();
}

class _TransLinkOnboardingPageState extends State<TransLinkOnboardingPage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header with TransLink logo and Skip button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TransLink',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, TransLinkLandingPage.id);
                    },
                    child: Text(
                      'Skip',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFFFA500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // PageView for onboarding screens
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  OnboardingCard(
                    illustration: CargoIllustration(),
                    title: 'Find rides and book\ncargo space',
                    description:
                        'Connect with drivers and senders across\nGhana. Book seats or cargo space with ease.',
                  ),
                  OnboardingCard(
                    illustration: SafetyIllustration(),
                    title: 'Safe and secure\ntransactions',
                    description:
                        'Your safety is our priority. Verified drivers\nand secure payment options for peace of mind.',
                  ),
                  OnboardingCard(
                    illustration: TrackingIllustration(),
                    title: 'Track your journey\nin real-time',
                    description:
                        'Stay updated with live tracking and\nnotifications throughout your trip.',
                  ),
                ],
              ),
            ),
            // Page indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: index == _currentPage ? 28 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: index == _currentPage
                          ? const Color(0xFFFFA500)
                          : const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            // Next button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage == 2) {
                      Navigator.pushNamed(context, TransLinkLandingPage.id);
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text('Onboarding complete!')),
                      // );
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA500),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentPage == 2 ? 'Get Started' : 'Next',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      if (_currentPage != 2)
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingCard extends StatelessWidget {
  final Widget illustration;
  final String title;
  final String description;

  const OnboardingCard({
    super.key,
    required this.illustration,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration container
          Container(
            width: double.infinity,
            height: 320,
            decoration: BoxDecoration(
              color: const Color(0xFF4A9BA8),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: illustration,
          ),
          const SizedBox(height: 40),
          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              color: const Color(0xFF666666),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class CargoIllustration extends StatelessWidget {
  const CargoIllustration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CargoIllustrationPainter(),
      size: Size.infinite,
    );
  }
}

class CargoIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Sky gradient effect
    paint.color = const Color(0xFF5AACB8);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height * 0.4), paint);

    paint.color = const Color(0xFF7ECDD4);
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.4, size.width, size.height * 0.2),
      paint,
    );

    // Clouds
    paint.color = const Color(0xFFFFEDD5).withOpacity(0.9);
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.2), 25, paint);
    canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.15), 35, paint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.2), 28, paint);
    canvas.drawCircle(Offset(size.width * 0.65, size.height * 0.25), 32, paint);
    canvas.drawCircle(Offset(size.width * 0.75, size.height * 0.18), 26, paint);

    // Horizon line
    paint.color = const Color(0xFF4A8A92);
    paint.strokeWidth = 4;
    canvas.drawLine(
      Offset(0, size.height * 0.55),
      Offset(size.width, size.height * 0.55),
      paint,
    );

    // Ground
    paint.color = const Color(0xFF2D5A66);
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.55, size.width, size.height * 0.45),
      paint,
    );

    // Truck platform
    paint.color = const Color(0xFF1A3A44);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.1, size.height * 0.52, size.width * 0.8, 8),
      paint,
    );

    // Truck wheels
    paint.color = Colors.black;
    canvas.drawCircle(Offset(size.width * 0.25, size.height * 0.6), 12, paint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.6), 12, paint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.6), 12, paint);

    // Luggage - Red suitcase
    paint.color = const Color(0xFFE74C3C);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.2, size.height * 0.35, 20, 25),
      paint,
    );
    paint.color = const Color(0xFFC0392B);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.22, size.height * 0.37, 4, 8),
      paint,
    );

    // Luggage - Teal suitcase
    paint.color = const Color(0xFF16A085);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.28, size.height * 0.33, 20, 27),
      paint,
    );
    paint.color = const Color(0xFF117A65);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.3, size.height * 0.35, 4, 8),
      paint,
    );

    // Luggage - Orange suitcase
    paint.color = const Color(0xFFF39C12);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.35, size.height * 0.36, 20, 26),
      paint,
    );

    // Luggage - Red suitcase 2
    paint.color = const Color(0xFFE74C3C);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.25, size.height * 0.42, 18, 12),
      paint,
    );

    // Person 1 (male)
    // Head
    paint.color = const Color(0xFF8B6F47);
    canvas.drawCircle(Offset(size.width * 0.45, size.height * 0.28), 8, paint);
    // Body
    paint.color = const Color(0xFF5D7B6F);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.42, size.height * 0.36, 6, 16),
      paint,
    );
    // Pants
    paint.color = const Color(0xFF3D4A42);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.42, size.height * 0.42, 6, 10),
      paint,
    );

    // Person 2 (female)
    // Head
    paint.color = const Color(0xFF9B7854);
    canvas.drawCircle(Offset(size.width * 0.58, size.height * 0.27), 8, paint);
    // Body
    paint.color = const Color(0xFF1B5E5E);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.55, size.height * 0.35, 6, 18),
      paint,
    );
    // Pants
    paint.color = const Color(0xFF3D4A42);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.55, size.height * 0.43, 6, 9),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SafetyIllustration extends StatelessWidget {
  const SafetyIllustration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SafetyIllustrationPainter(),
      size: Size.infinite,
    );
  }
}

class SafetyIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Background gradient
    paint.color = const Color(0xFF5AACB8);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Shield
    paint.color = const Color(0xFF27AE60);
    final shieldPath = Path();
    shieldPath.moveTo(size.width * 0.5, size.height * 0.2);
    shieldPath.lineTo(size.width * 0.3, size.height * 0.35);
    shieldPath.lineTo(size.width * 0.3, size.height * 0.6);
    shieldPath.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.75,
      size.width * 0.5,
      size.height * 0.75,
    );
    shieldPath.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.75,
      size.width * 0.7,
      size.height * 0.6,
    );
    shieldPath.lineTo(size.width * 0.7, size.height * 0.35);
    shieldPath.close();
    canvas.drawPath(shieldPath, paint);

    // Checkmark
    paint.color = Colors.white;
    paint.strokeWidth = 6;
    paint.style = PaintingStyle.stroke;
    final checkPath = Path();
    checkPath.moveTo(size.width * 0.42, size.height * 0.55);
    checkPath.lineTo(size.width * 0.48, size.height * 0.62);
    checkPath.lineTo(size.width * 0.58, size.height * 0.45);
    canvas.drawPath(checkPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class TrackingIllustration extends StatelessWidget {
  const TrackingIllustration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TrackingIllustrationPainter(),
      size: Size.infinite,
    );
  }
}

class TrackingIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Background
    paint.color = const Color(0xFF5AACB8);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Map pin
    paint.color = const Color(0xFFFFA500);
    final pinPath = Path();
    pinPath.moveTo(size.width * 0.5, size.height * 0.2);
    pinPath.lineTo(size.width * 0.35, size.height * 0.45);
    pinPath.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.55,
      size.width * 0.5,
      size.height * 0.65,
    );
    pinPath.quadraticBezierTo(
      size.width * 0.65,
      size.height * 0.55,
      size.width * 0.65,
      size.height * 0.45,
    );
    pinPath.close();
    canvas.drawPath(pinPath, paint);

    // Inner circle
    paint.color = Colors.white;
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.4), 8, paint);

    // Tracking lines
    paint.color = Colors.white.withOpacity(0.6);
    paint.strokeWidth = 2;
    paint.style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.4), 15, paint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.4), 22, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
