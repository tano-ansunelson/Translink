import 'package:flutter/material.dart';
import 'package:translink/screens/services/trip_service.dart';

class TransLinkCreateTripPage extends StatefulWidget {
  const TransLinkCreateTripPage({super.key});
  static const String id = 'create_trip_page';

  @override
  State<TransLinkCreateTripPage> createState() =>
      _TransLinkCreateTripPageState();
}

class _TransLinkCreateTripPageState extends State<TransLinkCreateTripPage> {
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _seatsController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  String _tripType = 'ride'; // 'ride' or 'cargo'

  // Error messages for each field
  String? _originError;
  String? _destinationError;
  String? _dateTimeError;
  String? _seatsError;
  String? _priceError;
  final TripService _tripService = TripService();

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _dateTimeController.dispose();
    _seatsController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFFA500),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateTimeController.text =
            '${picked.day} ${_getMonthName(picked.month)}, ${picked.year}';
      });
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Spacer(),
                    Text(
                      'Create Trip',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Form fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Origin
                    _buildLocationField(
                      controller: _originController,
                      label: 'Origin',
                      hintText: 'Origin',
                      errorText: _originError,
                    ),
                    const SizedBox(height: 16),
                    // Destination
                    _buildLocationField(
                      controller: _destinationController,
                      label: 'Destination',
                      hintText: 'Destination',
                      errorText: _destinationError,
                    ),
                    const SizedBox(height: 16),
                    // Date & Time
                    _buildDateTimeField(
                      controller: _dateTimeController,
                      label: 'Date & Time',
                      hintText: 'Date & Time',
                      errorText: _dateTimeError,
                    ),
                    const SizedBox(height: 24),
                    // Trip Type Toggle
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
                                            color: Colors.black.withOpacity(
                                              0.08,
                                            ),
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
                                            color: Colors.black.withOpacity(
                                              0.08,
                                            ),
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
                    const SizedBox(height: 24),
                    // Number of Seats (only show for ride-sharing)
                    if (_tripType == 'ride') ...[
                      _buildTextFormField(
                        controller: _seatsController,
                        label: 'Number of Seats',
                        hintText: 'Number of Seats',
                        keyboardType: TextInputType.number,
                        errorText: _seatsError,
                      ),
                      const SizedBox(height: 16),
                    ],
                    // Price per Seat
                    _buildTextFormField(
                      controller: _priceController,
                      label: _tripType == 'ride'
                          ? 'Price per Seat'
                          : 'Price per kg',
                      hintText: _tripType == 'ride'
                          ? 'Price per Seat'
                          : 'Price per kg',
                      keyboardType: TextInputType.number,
                      errorText: _priceError,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              // Post Trip button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _validateAndPostTrip,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFA500),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.black),
                              //color: Colors.black,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Post Trip',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black, fontSize: 14),
        errorText: errorText,
        errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: errorText != null ? Colors.red : Colors.transparent,
            width: errorText != null ? 1 : 0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: errorText != null ? Colors.red : const Color(0xFFFFA500),
            width: 2,
          ),
        ),
        filled: true,
        fillColor: const Color(0xFFE8E8E8),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildDateTimeField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    String? errorText,
  }) {
    return GestureDetector(
      onTap: _selectDate,
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.black, fontSize: 14),
            errorText: errorText,
            errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
            suffixIcon: const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.calendar_today_rounded,
                color: Color(0xFFCCCCCC),
                size: 20,
              ),
            ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : Colors.transparent,
                width: errorText != null ? 1 : 0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : const Color(0xFFFFA500),
                width: 2,
              ),
            ),
            filled: true,
            fillColor: const Color(0xFFE8E8E8),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black, fontSize: 14),
        errorText: errorText,
        errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: errorText != null ? Colors.red : Colors.transparent,
            width: errorText != null ? 1 : 0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: errorText != null ? Colors.red : const Color(0xFFFFA500),
            width: 2,
          ),
        ),
        filled: true,
        fillColor: const Color(0xFFE8E8E8),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  void _validateAndPostTrip() async {
    setState(() {
      // Clear errors
      _originError = null;
      _destinationError = null;
      _dateTimeError = null;
      _seatsError = null;
      _priceError = null;

      // Check each field
      if (_originController.text.isEmpty) {
        _originError = 'Please enter origin location';
      }
      if (_destinationController.text.isEmpty) {
        _destinationError = 'Please enter destination location';
      }
      if (_dateTimeController.text.isEmpty) {
        _dateTimeError = 'Please select date & time';
      }
      if (_tripType == 'ride' && _seatsController.text.isEmpty) {
        _seatsError = 'Please enter number of seats';
      }
      if (_priceController.text.isEmpty) {
        _priceError = 'Please enter price';
      }
    });

    // Stop if there are errors
    if (_originError != null ||
        _destinationError != null ||
        _dateTimeError != null ||
        _seatsError != null ||
        _priceError != null) {
      return;
    }

    // Show loading
    setState(() {
      _isLoading = true;
    });

    try {
      // Call the TripService to save trip
      await _tripService.createTrip(
        origin: _originController.text.trim(),
        destination: _destinationController.text.trim(),
        dateTime: _dateTimeController.text.trim(),
        tripType: _tripType,
        price: double.parse(_priceController.text.trim()),
        seats: _tripType == 'ride'
            ? int.parse(_seatsController.text.trim())
            : null,
      );

      // Success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Trip posted successfully!'),
            backgroundColor: const Color(0xFFFFA500),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      // Error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // Stop loading
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
