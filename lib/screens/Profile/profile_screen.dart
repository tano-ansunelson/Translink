import 'package:flutter/material.dart';
import 'package:translink/screens/Profile/edit_profile_screen.dart';

class TransLinkProfilePage extends StatefulWidget {
  const TransLinkProfilePage({super.key});
  static const String id = 'profile_page';

  @override
  State<TransLinkProfilePage> createState() => _TransLinkProfilePageState();
}

class _TransLinkProfilePageState extends State<TransLinkProfilePage> {
  //int _currentIndex = 4;
  //// Profile tab selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with back button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    const Spacer(),
                    Text(
                      'Profile',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Profile section
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  // Avatar
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE8D5C4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: CustomPaint(painter: ProfileAvatarPainter()),
                  ),
                  // Settings badge
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFFA500),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Name
              Text(
                'Kwame Mensah',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              // Location
              Text(
                'Accra, Ghana',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  color: const Color(0xFF999999),
                ),
              ),
              const SizedBox(height: 24),
              // Edit Profile button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, EditProfileScreen.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFE4B5),
                      foregroundColor: const Color(0xFFFFA500),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Edit Profile',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFFFA500),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Vehicle Information section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vehicle Information',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Vehicle Type card
                    _buildVehicleInfoCard(
                      icon: Icons.local_shipping,
                      title: 'Vehicle Type',
                      subtitle: 'Toyota Hilux',
                    ),
                    const SizedBox(height: 12),
                    // License Plate card
                    _buildVehicleInfoCard(
                      icon: Icons.badge,
                      title: 'License Plate',
                      subtitle: 'GR 2345-20',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Rating section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rating',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text(
                              '4.8',
                              style: Theme.of(context).textTheme.displaySmall
                                  ?.copyWith(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: List.generate(
                                5,
                                (index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 2,
                                  ),
                                  child: Icon(
                                    Icons.star,
                                    color: const Color(0xFFFFA500),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '125 reviews',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: const Color(0xFF999999)),
                            ),
                          ],
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: Column(
                            children: [
                              _buildRatingBar(5, 70),
                              const SizedBox(height: 8),
                              _buildRatingBar(4, 20),
                              const SizedBox(height: 8),
                              _buildRatingBar(3, 5),
                              const SizedBox(height: 8),
                              _buildRatingBar(2, 3),
                              const SizedBox(height: 8),
                              _buildRatingBar(1, 2),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Logout tile
                    _buildLogoutTile(),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE4B5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFFFFA500), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int stars, int percentage) {
    return Row(
      children: [
        Text(
          '$stars',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 6,
              backgroundColor: const Color(0xFFE0E0E0),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFFFA500),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$percentage%',
          style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
        ),
      ],
    );
  }

  Widget _buildLogoutTile() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFA500),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFFFA500)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Color(0xFFFFA500),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.logout, color: Colors.red, size: 24),
        ),
        title: const Text(
          'Log Out',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.red,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.black,
        ),
        onTap: () {},
      ),
    );
  }
}

class ProfileAvatarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final center = Offset(size.width / 2, size.height / 2);

    // Skin tone
    paint.color = const Color(0xFFD4A574);
    canvas.drawCircle(center, size.width / 2.2, paint);

    // Head
    paint.color = const Color(0xFFB8926F);
    canvas.drawCircle(Offset(center.dx, center.dy - 5), 28, paint);

    // Hair
    paint.color = const Color(0xFF3D2817);
    canvas.drawCircle(Offset(center.dx - 5, center.dy - 15), 26, paint);
    canvas.drawCircle(Offset(center.dx + 5, center.dy - 18), 24, paint);
    canvas.drawCircle(Offset(center.dx, center.dy - 20), 25, paint);

    // Eyes
    paint.color = const Color(0xFF5C7080);
    canvas.drawCircle(Offset(center.dx - 10, center.dy - 8), 3, paint);
    canvas.drawCircle(Offset(center.dx + 10, center.dy - 8), 3, paint);

    // Eyebrows
    paint.color = const Color(0xFF3D2817);
    paint.strokeWidth = 2;
    paint.style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.dx - 10, center.dy - 12),
        width: 8,
        height: 3,
      ),
      0,
      3.14,
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.dx + 10, center.dy - 12),
        width: 8,
        height: 3,
      ),
      0,
      3.14,
      false,
      paint,
    );

    // Nose
    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xFF9D7A5A);
    canvas.drawCircle(Offset(center.dx, center.dy), 2, paint);

    // Mouth
    paint.color = const Color(0xFF8B5A3C);
    paint.strokeWidth = 1.5;
    paint.style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + 8),
        width: 8,
        height: 4,
      ),
      0,
      3.14,
      false,
      paint,
    );

    // Neck
    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xFFB8926F);
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + 20),
        width: 18,
        height: 12,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
