import 'package:flutter/material.dart';
import 'package:translink/screens/Booking_screen/booking_ride_cargo_screen.dart';

class TransLinkSearchTripsPage extends StatefulWidget {
  const TransLinkSearchTripsPage({super.key});
  static const String id = 'search_trips_page';

  @override
  State<TransLinkSearchTripsPage> createState() =>
      _TransLinkSearchTripsPageState();
}

class _TransLinkSearchTripsPageState extends State<TransLinkSearchTripsPage> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  bool _hasSearched = false;

  final List<Trip> availableTrips = [
    Trip(from: 'Accra', to: 'Kumasi', seatsAvailable: 1, price: 120),
    Trip(from: 'Accra', to: 'Takoradi', seatsAvailable: 2, price: 150),
    Trip(from: 'Accra', to: 'Cape Coast', seatsAvailable: 3, price: 100),
  ];

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              floating: true,
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF2D2D2D)),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              title: const Text(
                'Search Trips',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              centerTitle: true,
            ),

            // Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  // Search Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Plan Your Journey',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D2D2D),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // From field
                          _buildLocationField(
                            controller: _fromController,
                            icon: Icons.trip_origin,
                            hintText: 'Where from?',
                            iconColor: const Color(0xFF4CAF50),
                          ),
                          const SizedBox(height: 16),
                          // Swap button
                          Center(
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFA500).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.swap_vert,
                                color: Color(0xFFFFA500),
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // To field
                          _buildLocationField(
                            controller: _toController,
                            icon: Icons.location_on,
                            hintText: 'Where to?',
                            iconColor: const Color(0xFFF44336),
                          ),
                          const SizedBox(height: 16),
                          // // Date field
                          // _buildDateField(
                          //   controller: _dateController,
                          //   hintText: 'Select Date',
                          // ),
                          // const SizedBox(height: 24),
                          // Search button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _hasSearched = true;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFA500),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                                shadowColor: const Color(
                                  0xFFFFA500,
                                ).withOpacity(0.3),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search, size: 24),
                                  SizedBox(width: 8),
                                  Text(
                                    'Search Trips',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_hasSearched) ...[
                    const SizedBox(height: 32),
                    // Available Trips header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Available Trips',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D2D2D),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFA500).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${availableTrips.length} trips',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFFFA500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Trip cards
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: List.generate(
                          availableTrips.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildTripCard(availableTrips[index]),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.transparent, width: 2),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFFBBBBBB),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color(0xFFF5F6FA),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$hintText location picker opened'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget _buildDateField({
  //   required TextEditingController controller,
  //   required String hintText,
  // }) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFF5F6FA),
  //       borderRadius: BorderRadius.circular(16),
  //     ),
  //     child: TextField(
  //       controller: controller,
  //       decoration: InputDecoration(
  //         hintText: hintText,
  //         hintStyle: const TextStyle(
  //           color: Color(0xFFBBBBBB),
  //           fontSize: 15,
  //           fontWeight: FontWeight.w500,
  //         ),
  //         prefixIcon: Container(
  //           margin: const EdgeInsets.all(12),
  //           padding: const EdgeInsets.all(8),
  //           decoration: BoxDecoration(
  //             color: const Color(0xFF2196F3).withOpacity(0.1),
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //           child: const Icon(
  //             Icons.calendar_today,
  //             color: Color(0xFF2196F3),
  //             size: 20,
  //           ),
  //         ),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(16),
  //           borderSide: BorderSide.none,
  //         ),
  //         filled: true,
  //         fillColor: const Color(0xFFF5F6FA),
  //         contentPadding: const EdgeInsets.symmetric(
  //           horizontal: 16,
  //           vertical: 18,
  //         ),
  //       ),
  //       onTap: () {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text('Date picker opened'),
  //             behavior: SnackBarBehavior.floating,
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _buildTripCard(Trip trip) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Route and image
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.trip_origin,
                                  size: 16,
                                  color: Color(0xFF4CAF50),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  trip.from,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D2D2D),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Container(
                                width: 2,
                                height: 20,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      const Color(0xFF4CAF50).withOpacity(0.5),
                                      const Color(0xFFF44336).withOpacity(0.5),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Color(0xFFF44336),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  trip.to,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D2D2D),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: trip.seatsAvailable <= 2
                                    ? const Color(0xFFFF5722).withOpacity(0.1)
                                    : const Color(0xFF4CAF50).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.event_seat,
                                    size: 14,
                                    color: trip.seatsAvailable <= 2
                                        ? const Color(0xFFFF5722)
                                        : const Color(0xFF4CAF50),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${trip.seatsAvailable} seat${trip.seatsAvailable > 1 ? 's' : ''} left',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: trip.seatsAvailable <= 2
                                          ? const Color(0xFFFF5722)
                                          : const Color(0xFF4CAF50),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF2D2D2D), Color(0xFF1A1A1A)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.directions_bus,
                            color: Color(0xFFFFA500),
                            size: 48,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Price and button row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Price',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF999999),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'GHS ${trip.price}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFA500),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, NewBookingScreen.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Booked: ${trip.from} to ${trip.to}',
                              ),
                              backgroundColor: const Color(0xFFFFA500),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFA500),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          children: [
                            Text(
                              'Book Now',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Trip {
  final String from;
  final String to;
  final int seatsAvailable;
  final int price;

  Trip({
    required this.from,
    required this.to,
    required this.seatsAvailable,
    required this.price,
  });
}
