import 'package:flutter/material.dart';

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

  String _tripType = 'ride'; // 'ride' or 'cargo'

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _dateTimeController.dispose();
    _seatsController.dispose();
    _priceController.dispose();
    super.dispose();
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
                    ),
                    const SizedBox(height: 16),
                    // Destination
                    _buildLocationField(
                      controller: _destinationController,
                      label: 'Destination',
                      hintText: 'Destination',
                    ),
                    const SizedBox(height: 16),
                    // Date & Time
                    _buildDateTimeField(
                      controller: _dateTimeController,
                      label: 'Date & Time',
                      hintText: 'Date & Time',
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
                    onPressed: _validateAndPostTrip,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFA500),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Post Trip',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
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
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
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
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.black,
          //(0xFFD0D0D0),
          fontSize: 14,
        ),
        suffixIcon: const Padding(
          padding: EdgeInsets.only(right: 12),
          child: Icon(Icons.calendar_month, color: Color(0xFFCCCCCC), size: 20),
        ),
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
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

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
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

  void _validateAndPostTrip() {
    if (_originController.text.isEmpty) {
      _showError('Please enter origin location');
      return;
    }
    if (_destinationController.text.isEmpty) {
      _showError('Please enter destination location');
      return;
    }
    if (_dateTimeController.text.isEmpty) {
      _showError('Please select date & time');
      return;
    }
    if (_tripType == 'ride' && _seatsController.text.isEmpty) {
      _showError('Please enter number of seats');
      return;
    }
    if (_priceController.text.isEmpty) {
      _showError('Please enter price');
      return;
    }

    // All validations passed
    final tripTypeLabel = _tripType == 'ride'
        ? 'Ride-Sharing'
        : 'Cargo-Sharing';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$tripTypeLabel trip posted! ${_originController.text} → ${_destinationController.text}',
        ),
        backgroundColor: const Color(0xFFFFA500),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
