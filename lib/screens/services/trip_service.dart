import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TripService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // This function saves trip to Firebase
  Future<void> createTrip({
    required String origin,
    required String destination,
    required String dateTime,
    required String tripType,
    required double price,
    int? seats,
  }) async {
    // Check if user is logged in
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    // Create the trip data
    final tripData = {
      'userId': user.uid,
      'origin': origin.toLowerCase().trim(),
      'destination': destination.toLowerCase().trim(),
      'dateTime': dateTime,
      'tripType': tripType,
      'price': price,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'active',
    };

    // Add seats only if it's ride-sharing
    if (tripType == 'ride' && seats != null) {
      tripData['seats'] = seats;
    }

    // Save to Firebase
    await _firestore.collection('trips').add(tripData);
  }
}
