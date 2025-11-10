import 'package:cloud_firestore/cloud_firestore.dart';
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  bool _hasSearched = false;
  String _tripType = 'ride'; // 'ride' or 'cargo'
  // ignore: unused_field
  String? _seatsError;
  Stream<QuerySnapshot>? _tripsStream;

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

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
                          const SizedBox(height: 24),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(6),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _tripType = 'ride';
                                        _seatsError = null;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _tripType == 'ride'
                                            ? Colors.white
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: _tripType == 'ride'
                                            ? [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.08),
                                                  blurRadius: 4,
                                                ),
                                              ]
                                            : [],
                                      ),
                                      child: Text(
                                        'Ride-Sharing',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: _tripType == 'ride'
                                              ? Colors.black
                                              : const Color(0xFFCCCCCC),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _tripType = 'cargo';
                                        _seatsError = null;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _tripType == 'cargo'
                                            ? Colors.white
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: _tripType == 'cargo'
                                            ? [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.08),
                                                  blurRadius: 4,
                                                ),
                                              ]
                                            : [],
                                      ),
                                      child: Text(
                                        'Cargo-Sharing',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: _tripType == 'cargo'
                                              ? Colors.black
                                              : const Color(0xFFCCCCCC),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Search button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_fromController.text.isEmpty ||
                                    _toController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please enter origin and destination',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                setState(() {
                                  _hasSearched = true;
                                  _tripsStream = _firestore
                                      .collection('trips')
                                      .where('tripType', isEqualTo: _tripType)
                                      .where('status', isEqualTo: 'active')
                                      .where(
                                        'origin',
                                        isEqualTo: _fromController.text.trim(),
                                      )
                                      .where(
                                        'destination',
                                        isEqualTo: _toController.text.trim(),
                                      )
                                      .snapshots();
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
                    // Available Trips with StreamBuilder
                    StreamBuilder<QuerySnapshot>(
                      stream: _tripsStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: CircularProgressIndicator(
                                color: Color(0xFFFFA500),
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No ${_tripType == 'ride' ? 'rides' : 'cargo trips'} found',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF999999),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Try adjusting your search criteria',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFFCCCCCC),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        final trips = snapshot.data!.docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return Trip(
                            from: _capitalize(data['origin']),
                            to: _capitalize(data['destination']),
                            seatsAvailable: data['seats'],
                            price: (data['price'] as num).toInt(),
                            tripType: data['tripType'],
                          );
                        }).toList();

                        return Column(
                          children: [
                            // Available Trips header
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      color: const Color(
                                        0xFFFFA500,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${trips.length} trip${trips.length != 1 ? 's' : ''}',
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                children: List.generate(
                                  trips.length,
                                  (index) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: _buildTripCard(trips[index]),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 100),
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
        onChanged: (value) {
          final lowercased = value.toLowerCase();
          if (controller.text != lowercased) {
            final cursorPos = controller.selection;
            controller.value = TextEditingValue(
              text: lowercased,
              selection: cursorPos,
            );
          }
          setState(() {});
        },
      ),
    );
  }

  Widget _buildTripCard(Trip trip) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
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
                                color: trip.tripType == 'ride'
                                    ? (trip.seatsAvailable! <= 2
                                          ? const Color(
                                              0xFFFF5722,
                                            ).withOpacity(0.1)
                                          : const Color(
                                              0xFF4CAF50,
                                            ).withOpacity(0.1))
                                    : const Color(0xFF2196F3).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    trip.tripType == 'ride'
                                        ? Icons.event_seat
                                        : Icons.local_shipping,
                                    size: 14,
                                    color: trip.tripType == 'ride'
                                        ? (trip.seatsAvailable! <= 2
                                              ? const Color(0xFFFF5722)
                                              : const Color(0xFF4CAF50))
                                        : const Color(0xFF2196F3),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    trip.tripType == 'ride'
                                        ? '${trip.seatsAvailable} seat${trip.seatsAvailable! > 1 ? 's' : ''} left'
                                        : 'Cargo space available',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: trip.tripType == 'ride'
                                          ? (trip.seatsAvailable! <= 2
                                                ? const Color(0xFFFF5722)
                                                : const Color(0xFF4CAF50))
                                          : const Color(0xFF2196F3),
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
                            trip.tripType == 'ride'
                                ? 'GHS ${trip.price}'
                                : 'GHS ${trip.price}/kg',
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
  final int? seatsAvailable;
  final int price;
  final String tripType;

  Trip({
    required this.from,
    required this.to,
    this.seatsAvailable,
    required this.price,
    required this.tripType,
  });
}
