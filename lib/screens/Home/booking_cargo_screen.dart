import 'package:flutter/material.dart';

class TransLinkBookCargoPage extends StatefulWidget {
  const TransLinkBookCargoPage({super.key});
  static const String id = 'book_cargo_page';

  @override
  State<TransLinkBookCargoPage> createState() => _TransLinkBookCargoPageState();
}

class _TransLinkBookCargoPageState extends State<TransLinkBookCargoPage> {
  final TextEditingController _senderNameController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _pickupLocationController =
      TextEditingController();
  final TextEditingController _dropoffLocationController =
      TextEditingController();
  final TextEditingController _loadDescriptionController =
      TextEditingController();
  final TextEditingController _weightEstimateController =
      TextEditingController();

  @override
  void dispose() {
    _senderNameController.dispose();
    _contactNumberController.dispose();
    _pickupLocationController.dispose();
    _dropoffLocationController.dispose();
    _loadDescriptionController.dispose();
    _weightEstimateController.dispose();
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
                      'Book Cargo',
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
                    // Sender's Name
                    _buildFormLabel("Sender's Name"),
                    const SizedBox(height: 8),
                    _buildTextFormField(
                      controller: _senderNameController,
                      hintText: 'Enter your name',
                    ),
                    const SizedBox(height: 24),
                    // Contact Number
                    _buildFormLabel('Contact Number'),
                    const SizedBox(height: 8),
                    _buildTextFormField(
                      controller: _contactNumberController,
                      hintText: 'Enter your phone number',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 24),
                    // Pickup Location
                    _buildFormLabel('Pickup Location'),
                    const SizedBox(height: 8),
                    _buildLocationField(
                      controller: _pickupLocationController,
                      hintText: 'Where are you sending from?',
                    ),
                    const SizedBox(height: 24),
                    // Drop-off Location
                    _buildFormLabel('Drop-off Location'),
                    const SizedBox(height: 8),
                    _buildLocationField(
                      controller: _dropoffLocationController,
                      hintText: 'Where are you sending to?',
                    ),
                    const SizedBox(height: 24),
                    // Load Description
                    _buildFormLabel('Load Description'),
                    const SizedBox(height: 8),
                    _buildNotesField(
                      controller: _loadDescriptionController,
                      hintText: 'Describe your goods',
                      maxLines: 4,
                    ),
                    const SizedBox(height: 24),
                    // Weight Estimate
                    // _buildFormLabel('Weight Estimate (kg)'),
                    // const SizedBox(height: 8),
                    // _buildTextFormField(
                    //   controller: _weightEstimateController,
                    //   hintText: 'Approximate weight',
                    //   keyboardType: TextInputType.number,
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Continue button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _validateAndContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFA500),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Book Cargo',
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
    int maxLines = 3,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
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

  void _validateAndContinue() {
    if (_senderNameController.text.isEmpty) {
      _showError("Please enter sender's name");
      return;
    }
    if (_contactNumberController.text.isEmpty) {
      _showError('Please enter your contact number');
      return;
    }
    if (_pickupLocationController.text.isEmpty) {
      _showError('Please select a pickup location');
      return;
    }
    if (_dropoffLocationController.text.isEmpty) {
      _showError('Please select a drop-off location');
      return;
    }
    if (_loadDescriptionController.text.isEmpty) {
      _showError('Please describe your goods');
      return;
    }
    if (_weightEstimateController.text.isEmpty) {
      _showError('Please enter weight estimate');
      return;
    }

    // All validations passed
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Cargo booking for ${_senderNameController.text} created!',
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
