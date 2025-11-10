import 'package:flutter/material.dart';

class TransLinkBookRidePage extends StatefulWidget {
  const TransLinkBookRidePage({super.key});
  static const String id = 'book_ride_page';

  @override
  State<TransLinkBookRidePage> createState() => _TransLinkBookRidePageState();
}

class _TransLinkBookRidePageState extends State<TransLinkBookRidePage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _pickupPointController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _seatsController = TextEditingController(
    text: '1',
  );
  String origin = 'Kumasi';
  String destination = 'Accra';
  int price = 0;
  int totalPrice = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // NEW: Retrieve arguments passed from previous screen
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      setState(() {
        origin = args['origin'] ?? 'Kumasi';
        destination = args['destination'] ?? 'Accra';
        price = int.tryParse(args['price'].toString()) ?? 0;
        totalPrice = price;
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _contactNumberController.dispose();
    _pickupPointController.dispose();
    _notesController.dispose();
    _seatsController.dispose();
    super.dispose();
  }

  void _incrementSeats() {
    int currentSeats = int.tryParse(_seatsController.text) ?? 1;
    if (currentSeats < 4) {
      setState(() {
        _seatsController.text = (currentSeats + 1).toString();
        totalPrice = price * (currentSeats + 1);
      });
    }
  }

  void _decrementSeats() {
    int currentSeats = int.tryParse(_seatsController.text) ?? 1;
    if (currentSeats > 1) {
      setState(() {
        _seatsController.text = (currentSeats - 1).toString();
        totalPrice = price * (currentSeats - 1);
      });
    }
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
                      'Book a Ride',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Route Display Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFA500), Color(0xFFFF8C00)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFA500).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.directions_bus,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Route',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                origin,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                destination,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                'GH₵$totalPrice',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              //const SizedBox(height: 32),
              const SizedBox(height: 24),
              // Form fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full Name
                    _buildFormLabel('Full Name'),
                    const SizedBox(height: 8),
                    _buildTextFormField(
                      controller: _fullNameController,
                      hintText: 'Enter your full name',
                    ),
                    const SizedBox(height: 24),
                    // Contact Number
                    _buildFormLabel('Contact Number'),
                    const SizedBox(height: 8),
                    _buildTextFormField(
                      controller: _contactNumberController,
                      hintText: 'e.g. 024 123 4567',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 24),
                    // Pickup Point
                    _buildFormLabel('Pickup Point'),
                    const SizedBox(height: 8),
                    _buildLocationField(
                      controller: _pickupPointController,
                      hintText: 'Search for location',
                    ),
                    const SizedBox(height: 24),

                    // Notes for Driver
                    const SizedBox(height: 8),
                    _buildFormLabel("seat(s)"),
                    _buildSeatsField(),
                    const SizedBox(height: 24),
                    _buildFormLabel('Notes for Driver'),
                    _buildNotesField(
                      controller: _notesController,
                      hintText: 'Any special requests or instructions?',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              // Book Ride button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _validateAndBook,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFA500),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Book Ride',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFFA500), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildLocationField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 14),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 12, right: 8),
          child: Icon(Icons.location_on, color: Color(0xFFCCCCCC), size: 20),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFFA500), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Location picker opened')));
      },
    );
  }

  Widget _buildNotesField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFFA500), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildSeatsField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _decrementSeats,
            icon: Icon(
              Icons.remove_circle_outline_rounded,
              color: Colors.grey.shade400,
              size: 28,
            ),
          ),
          Text(
            _seatsController.text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          IconButton(
            onPressed: _incrementSeats,
            icon: const Icon(
              Icons.add_circle_outline_rounded,
              color: Color(0xFFFFA500),
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  void _validateAndBook() {
    if (_fullNameController.text.isEmpty) {
      _showError('Please enter your full name');
      return;
    }
    if (_contactNumberController.text.isEmpty) {
      _showError('Please enter your contact number');
      return;
    }
    if (_pickupPointController.text.isEmpty) {
      _showError('Please select a pickup point');
      return;
    }

    // All validations passed
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ride booked for ${_fullNameController.text}!'),
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



//'Pay GH₵${totalCost.toStringAsFixed(2)}