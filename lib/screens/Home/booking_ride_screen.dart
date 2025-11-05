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

  @override
  void dispose() {
    _fullNameController.dispose();
    _contactNumberController.dispose();
    _pickupPointController.dispose();
    _notesController.dispose();
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Back pressed')),
                        );
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
                    _buildFormLabel('Notes for Driver'),
                    const SizedBox(height: 8),
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
