import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:translink/screens/Booking_screen/booking_ride_cargo_screen.dart';
import 'package:translink/screens/Home/booking_cargo_screen.dart';
import 'package:translink/screens/Home/booking_ride_screen.dart';
import 'package:translink/screens/Home/create_trip_screen.dart';
import 'package:translink/screens/Home/search_trip_screen.dart';

class TransLinkHomePage extends StatefulWidget {
  const TransLinkHomePage({super.key});
  static const String id = 'home_page';

  @override
  State<TransLinkHomePage> createState() => _TransLinkHomePageState();
}

class _TransLinkHomePageState extends State<TransLinkHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
  // final List<RideOffer> rides = [
  //   RideOffer(
  //     route: 'Accra to Kumasi',
  //     seatsAvailable: 12,
  //     price: 100,
  //     imageUrl: 'assets/road1.jpg',
  //   ),
  //   RideOffer(
  //     route: 'Accra to Takoradi',
  //     seatsAvailable: 8,
  //     price: 80,
  //     imageUrl: 'assets/road2.jpg',
  //   ),
  //   RideOffer(
  //     route: 'Accra to Tamale',
  //     seatsAvailable: 15,
  //     price: 150,
  //     imageUrl: 'assets/road3.jpg',
  //   ),
  // ];

  // final List<RideOffer> cargo = [
  //   RideOffer(
  //     route: 'Accra to Kumasi',
  //     seatsAvailable: 5,
  //     price: 120,
  //     imageUrl: 'assets/cargo1.jpg',
  //   ),
  //   RideOffer(
  //     route: 'Accra to Cape Coast',
  //     seatsAvailable: 3,
  //     price: 90,
  //     imageUrl: 'assets/cargo2.jpg',
  //   ),
  // ];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Text(
                      'TransLink',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Notifications pressed')),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Rides/Cargo tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: const Color(0xFFFFA500),
                  unselectedLabelColor: const Color(0xFFBBBBBB),
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  indicatorColor: const Color(0xFFFFA500),
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.label,
                  dividerColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  labelPadding: const EdgeInsets.only(right: 32),
                  tabs: const [
                    Tab(text: 'Rides'),
                    Tab(text: 'Cargo'),
                  ],
                ),
              ),
            ),
            // Divider
            const Divider(height: 1, thickness: 1),
            const SizedBox(height: 16),

            // Scrollable content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('trips')
                        .where('tripType', isEqualTo: 'ride')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No rides available'));
                      }
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: snapshot.data!.docs.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _buildRideCard(
                                  RideOffer(
                                    route:
                                        '${_capitalize(data['origin'])} to ${_capitalize(data['destination'])}',
                                    seatsAvailable: data['seats'] ?? 0,
                                    price: data['price'].toInt(),
                                    imageUrl: 'assets/road1.jpg',
                                    tripType: 'ride',
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),

                  StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('trips')
                        .where('tripType', isEqualTo: 'cargo')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No cargo available'));
                      }
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: snapshot.data!.docs.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _buildRideCard(
                                  RideOffer(
                                    route:
                                        '${_capitalize(data['origin'])} to ${_capitalize(data['destination'])}',
                                    seatsAvailable: 0,
                                    price: data['price'].toInt(),
                                    imageUrl: 'assets/cargo1.jpg',
                                    tripType: 'cargo',
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Fixed Action buttons at bottom
            Container(
              color: const Color(0xFFFAFAFA),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          TransLinkCreateTripPage.id,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFA500),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Post Trip',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          TransLinkSearchTripsPage.id,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: BorderSide(
                          color: const Color(0xFFE0E0E0),
                          width: 1,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Find Trip',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRideCard(RideOffer ride) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            width: double.infinity,
            height: 160,
            color: const Color(0xFF4A9BA8),
            child: const Center(
              child: Icon(Icons.image, size: 40, color: Colors.white30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        ride.route,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ride.tripType == 'ride'
                          ? '${ride.seatsAvailable} seats available'
                          : 'Price per Kg',
                      //'${ride.seatsAvailable} seats available',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                    Text(
                      ride.tripType == 'ride'
                          ? '${ride.price} GHS'
                          : '${ride.price} GHS/Kg',
                      // '${ride.price} GHS',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      if (ride.tripType == 'ride') {
                        Navigator.pushNamed(
                          context,
                          TransLinkBookRidePage.id,
                          arguments: {
                            'origin': ride.route.split(' to ')[0],
                            'destination': ride.route.split(' to ')[1],
                            'price': ride.price,
                          },
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Booking Ride..${ride.route}'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else if (ride.tripType == 'cargo') {
                        Navigator.pushNamed(
                          context,
                          TransLinkBookCargoPage.id,
                          arguments: {
                            'origin': ride.route.split(' to ')[0],
                            'destination': ride.route.split(' to ')[1],
                            'price': ride.price,
                          },
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Booking Cargo..${ride.route}'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFE4B5),
                      foregroundColor: const Color(0xFFFFA500),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Book Now',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFFFA500),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RideOffer {
  final String route;
  final int? seatsAvailable;
  final int price;
  final String imageUrl;
  final String tripType;

  RideOffer({
    required this.route,
    required this.seatsAvailable,
    required this.price,
    required this.imageUrl,
    required this.tripType,
  });
}
