import 'package:flutter/material.dart';
import 'package:translink/screens/Trip_cancellation/cancel_trip_comfirmation.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});
  static const String id = 'my_trips_screen';

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'My Trips',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.orange,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.orange,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Ongoing'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUpcomingTrips(),
          _buildEmptyState('No ongoing trips'),
          _buildEmptyState('No completed trips'),
        ],
      ),
    );
  }

  Widget _buildUpcomingTrips() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTripCard(
          route: 'Accra to Kumasi',
          departure: 'Departure: 2024-07-20, 10:00 AM',
          vehicle: 'Vehicle: Toyota Hiace, Seat: 2',
          imageUrl: 'assets/yellow_van.jpg',
          color: Colors.yellow.shade700,
        ),
        const SizedBox(height: 16),
        _buildTripCard(
          route: 'Accra to Kumasi',
          departure: 'Departure: 2024-07-20, 10:00 AM',
          vehicle: 'Vehicle: Toyota Hiace, Seat: 2',
          imageUrl: 'assets/teal_van.jpg',
          color: Colors.teal.shade400,
        ),
      ],
    );
  }

  Widget _buildTripCard({
    required String route,
    required String departure,
    required String vehicle,
    required String imageUrl,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    route,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    departure,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    vehicle,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        CancelTripConfirmationScreen.id,
                      );
                      // Navigate to trip details
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Text(
                        'Cancel Trip',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Icon(Icons.directions_bus, size: 60, color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.grey, fontSize: 16),
      ),
    );
  }
}
