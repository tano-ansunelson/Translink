// //

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:translink/screens/services/provider/driver_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  static const String id = 'edit_profile_screen';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Personal Info Controllers
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _professionController = TextEditingController();

  // Driver Info Controllers
  final _driverNameController = TextEditingController();
  final _licensePlateController = TextEditingController();
  final _vehicleTypeController = TextEditingController();
  bool _isDriverVerified = false;

  bool _isPersonalInfo = true;
  bool _isLoading = true;

  // Driver images
  File? _carExteriorImage;
  File? _driverLicenseImage;
  String? _carImageUrl;
  String? _licenseImageUrl;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _professionController.dispose();
    _driverNameController.dispose();
    _licensePlateController.dispose();
    _vehicleTypeController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      // Fetch personal info from users collection
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
        _fullNameController.text = userData['fullName'] ?? '';
        _phoneController.text = userData['phone'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _professionController.text = userData['profession'] ?? '';
        _isDriverVerified = userData['isDriverVerified'] ?? false;
      }

      // Fetch driver verification info
      await _fetchDriverData();

      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch user info: $e')),
        );
      }
    }
  }

  Future<void> _fetchDriverData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('driver_verifications')
          .doc(uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _driverNameController.text = data['fullName'] ?? '';
          _licensePlateController.text = data['licensePlate'] ?? '';
          _vehicleTypeController.text = data['vehicleType'] ?? '';
          // _carImageUrl = data['carImageUrl'];
          //_licenseImageUrl = data['licenseImageUrl'];
        });
        final driverProvider = Provider.of<DriverProvider>(
          context,
          listen: false,
        );

        driverProvider.setDriverInfo(
          fullName: data['fullName'],
          licensePlate: data['licensePlate'],
          vehicleType: data['vehicleType'],
          carImageUrl: data['carImageUrl'],
          licenseImageUrl: data['licenseImageUrl'],
          isVerified: data['isVerified'] ?? false,
        );
      }
    } catch (e) {
      debugPrint('Error fetching driver data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch driver info: $e')),
        );
      }
    }
  }

  Future<void> _pickImage(ImageSource source, String type) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1700,
        maxHeight: 1700,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          if (type == 'car') {
            _carExteriorImage = File(image.path);
          } else if (type == 'license') {
            _driverLicenseImage = File(image.path);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  void _showImageSourceDialog(String type) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFFFFA500)),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera, type);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: Color(0xFFFFA500),
              ),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery, type);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _uploadImage(File image, String path) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  // ========== SAVE PERSONAL INFO TO FIREBASE ==========
  Future<void> _savePersonalInfo() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not logged in')));
      return;
    }

    try {
      setState(() => _isLoading = true);

      // Update personal info in 'users' collection
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'fullName': _fullNameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'profession': _professionController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Personal information updated successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error saving personal info: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ========== SAVE DRIVER INFO TO FIREBASE ==========
  Future<void> _saveDriverInfo() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not logged in')));
      return;
    }

    try {
      setState(() => _isLoading = true);

      String? carImageUrl = _carImageUrl;
      String? licenseImageUrl = _licenseImageUrl;

      // Upload new car image if user selected one
      if (_carExteriorImage != null) {
        carImageUrl = await _uploadImage(
          _carExteriorImage!,
          'driver_verifications/$uid/car_exterior.jpg',
        );
        if (carImageUrl == null) {
          throw Exception('Failed to upload car image');
        }
      }

      // Upload new license image if user selected one
      if (_driverLicenseImage != null) {
        licenseImageUrl = await _uploadImage(
          _driverLicenseImage!,
          'driver_verifications/$uid/driver_license.jpg',
        );
        if (licenseImageUrl == null) {
          throw Exception('Failed to upload license image');
        }
      }

      // Save all driver info to 'driver_verifications' collection
      await FirebaseFirestore.instance
          .collection('driver_verifications')
          .doc(uid)
          .set(
            {
              'fullName': _driverNameController.text.trim(),
              'licensePlate': _licensePlateController.text.trim().toUpperCase(),
              'vehicleType': _vehicleTypeController.text.trim(),
              'carImageUrl': carImageUrl,
              'licenseImageUrl': licenseImageUrl,
              'updatedAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          ); // merge: true ensures we don't overwrite other fields

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Driver information updated successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }

      // Refresh the driver data to show updated info
      await _fetchDriverData();

      // Clear the local image files after successful upload
      setState(() {
        _carExteriorImage = null;
        _driverLicenseImage = null;
      });
    } catch (e) {
      debugPrint('Error saving driver info: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFA500)),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Profile Picture
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFE8D5C4),
                          border: Border.all(
                            color: const Color(0xFFD4B5A0),
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/profile_avatar.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                size: 80,
                                color: Color(0xFF8B7355),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFA500),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              // Handle profile picture change
                            },
                            icon: const Icon(
                              Icons.edit_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Tab Selector
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isPersonalInfo = true;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: _isPersonalInfo
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(26),
                                  boxShadow: _isPersonalInfo
                                      ? [
                                          BoxShadow(
                                            color: Colors.grey.shade300,
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Text(
                                  'Personal Info',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: _isPersonalInfo
                                        ? const Color(0xFFFFA500)
                                        : Colors.grey.shade600,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: _isDriverVerified
                                  ? () {
                                      setState(() {
                                        _isPersonalInfo = false;
                                      });
                                    }
                                  : () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'You must be verified to access Driver Info',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    },
                              child: Opacity(
                                opacity: _isDriverVerified
                                    ? 1.0
                                    : 0.5, // visually dim if not verified
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: !_isPersonalInfo
                                        ? Colors.white
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(26),
                                    boxShadow: !_isPersonalInfo
                                        ? [
                                            BoxShadow(
                                              color: Colors.grey.shade300,
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Text(
                                    'Driver Info',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _isDriverVerified
                                          ? (!_isPersonalInfo
                                                ? const Color(0xFFFFA500)
                                                : Colors.grey.shade600)
                                          : Colors.grey.shade400,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Content based on selected tab
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _isPersonalInfo
                        ? _buildPersonalInfoForm()
                        : _buildDriverInfoForm(),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildPersonalInfoForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          label: 'Full Name',
          controller: TextEditingController(
            text: _fullNameController.text.toUpperCase(),
          ),
        ),
        const SizedBox(height: 20),
        _buildTextField(label: 'Phone Number', controller: _phoneController),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'Email Address',
          controller: TextEditingController(text: _emailController.text),
          isLocked: true,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'Profession',
          controller: TextEditingController(
            text: _professionController.text.toUpperCase(),
          ),
        ),
        const SizedBox(height: 40),

        // Save Changes Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _savePersonalInfo,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFA500),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Save Changes',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildDriverInfoForm() {
    return Opacity(
      opacity: _isDriverVerified ? 1.0 : 0.5,
      child: IgnorePointer(
        ignoring: !_isDriverVerified,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              label: 'Full Name',
              controller: TextEditingController(
                text: _driverNameController.text.toUpperCase(),
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'License Plate',
              controller: TextEditingController(
                text: _licensePlateController.text.toUpperCase(),
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Vehicle Type',
              controller: TextEditingController(
                text: _vehicleTypeController.text.toUpperCase(),
              ),
            ),
            const SizedBox(height: 30),

            // Car Exterior Image Section
            const Text(
              'Car Exterior',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => _showImageSourceDialog('car'),
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
                child: _carExteriorImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(
                          _carExteriorImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : _carImageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(_carImageUrl!, fit: BoxFit.cover),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.directions_car,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Tap to Upload Car Photo',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Clear exterior view of vehicle',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // Driver License Image Section
            const Text(
              'Driver\'s License',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => _showImageSourceDialog('license'),
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
                child: _driverLicenseImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(
                          _driverLicenseImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : _licenseImageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          _licenseImageUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.badge_outlined,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Tap to Upload License',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Front side, clear and readable',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 40),

            // Save Changes Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveDriverInfo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA500),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isLocked = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          readOnly: isLocked,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Color(0xFFFFA500), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 18,
            ),
            suffixIcon: isLocked
                ? Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.lock_outline_rounded,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({super.key});
//   static const String id = 'edit_profile_screen';

//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   // Personal Info Controllers
//   final _fullNameController = TextEditingController(text: 'Kofi Mensah');
//   final _phoneController = TextEditingController(text: '+233 24 123 4567');
//   final _emailController = TextEditingController(text: 'k.mensah@email.com');
//   final _professionController = TextEditingController(text: 'Trader');
//   final _vehicleTypeController = TextEditingController(text: 'Sedan');

//   // Driver Info Controllers
//   final _driverNameController = TextEditingController(text: 'Kofi Mensah');
//   final _licensePlateController = TextEditingController(text: 'GR 1234-21');

//   bool _isPersonalInfo = true;

//   // Driver images
//   File? _carExteriorImage;
//   File? _driverLicenseImage;
//   final ImagePicker _picker = ImagePicker();

//   @override
//   void dispose() {
//     _fullNameController.dispose();
//     _phoneController.dispose();
//     _emailController.dispose();
//     _professionController.dispose();
//     _driverNameController.dispose();
//     _licensePlateController.dispose();
//     super.dispose();
//   }

//   initializeState() {
//     super.initState();
//     _fetchDriverData();
//   }

//   Future<void> _fetchDriverData() async {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;

//     try {
//       final doc = await FirebaseFirestore.instance
//           .collection('driver_verifications')
//           .doc(uid)
//           .get();

//       if (doc.exists) {
//         final data = doc.data()!;
//         setState(() {
//           _driverNameController.text = data['fullName'] ?? '';
//           _licensePlateController.text = data['licensePlate'] ?? '';
//           _vehicleTypeController.text = data['vehicleType'] ?? '';
//           if (data['carImageUrl'] != null) {
//             _carExteriorImage = File(''); // placeholder
//             //  _carImageUrl = data['carImageUrl'];
//           }
//           if (data['licenseImageUrl'] != null) {
//             _driverLicenseImage = File(''); // placeholder
//             //  _licenseImageUrl = data['licenseImageUrl'];
//           }
//         });
//       }
//     } catch (e) {
//       debugPrint('Error fetching driver data: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to fetch driver info: $e')),
//       );
//     }
//   }

//   Future<void> _pickImage(ImageSource source, String type) async {
//     try {
//       final XFile? image = await _picker.pickImage(
//         source: source,
//         maxWidth: 1700,
//         maxHeight: 1700,
//         imageQuality: 85,
//       );

//       if (image != null) {
//         setState(() {
//           if (type == 'car') {
//             _carExteriorImage = File(image.path);
//           } else if (type == 'license') {
//             _driverLicenseImage = File(image.path);
//           }
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
//     }
//   }

//   void _showImageSourceDialog(String type) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.camera_alt, color: Color(0xFFFFA500)),
//               title: const Text('Camera'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickImage(ImageSource.camera, type);
//               },
//             ),
//             ListTile(
//               leading: const Icon(
//                 Icons.photo_library,
//                 color: Color(0xFFFFA500),
//               ),
//               title: const Text('Gallery'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickImage(ImageSource.gallery, type);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//         ),
//         title: const Text(
//           'Edit Profile',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 20),

//             // Profile Picture
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 Container(
//                   width: 150,
//                   height: 150,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: const Color(0xFFE8D5C4),
//                     border: Border.all(
//                       color: const Color(0xFFD4B5A0),
//                       width: 3,
//                     ),
//                   ),
//                   child: ClipOval(
//                     child: Image.asset(
//                       'assets/profile_avatar.png',
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return const Icon(
//                           Icons.person,
//                           size: 80,
//                           color: Color(0xFF8B7355),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   right: 0,
//                   child: Container(
//                     width: 45,
//                     height: 45,
//                     decoration: const BoxDecoration(
//                       color: Color(0xFFFFA500),
//                       shape: BoxShape.circle,
//                     ),
//                     child: IconButton(
//                       onPressed: () {
//                         // Handle profile picture change
//                       },
//                       icon: const Icon(
//                         Icons.edit_rounded,
//                         color: Colors.white,
//                         size: 22,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),

//             // Tab Selector
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 padding: const EdgeInsets.all(4),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             _isPersonalInfo = true;
//                           });
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           decoration: BoxDecoration(
//                             color: _isPersonalInfo
//                                 ? Colors.white
//                                 : Colors.transparent,
//                             borderRadius: BorderRadius.circular(26),
//                             boxShadow: _isPersonalInfo
//                                 ? [
//                                     BoxShadow(
//                                       color: Colors.grey.shade300,
//                                       blurRadius: 8,
//                                       offset: const Offset(0, 2),
//                                     ),
//                                   ]
//                                 : null,
//                           ),
//                           child: Text(
//                             'Personal Info',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: _isPersonalInfo
//                                   ? const Color(0xFFFFA500)
//                                   : Colors.grey.shade600,
//                               fontWeight: FontWeight.w600,
//                               fontSize: 15,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             _isPersonalInfo = false;
//                           });
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           decoration: BoxDecoration(
//                             color: !_isPersonalInfo
//                                 ? Colors.white
//                                 : Colors.transparent,
//                             borderRadius: BorderRadius.circular(26),
//                             boxShadow: !_isPersonalInfo
//                                 ? [
//                                     BoxShadow(
//                                       color: Colors.grey.shade300,
//                                       blurRadius: 8,
//                                       offset: const Offset(0, 2),
//                                     ),
//                                   ]
//                                 : null,
//                           ),
//                           child: Text(
//                             'Driver Info',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: !_isPersonalInfo
//                                   ? const Color(0xFFFFA500)
//                                   : Colors.grey.shade600,
//                               fontWeight: FontWeight.w600,
//                               fontSize: 15,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30),

//             // Content based on selected tab
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: _isPersonalInfo
//                   ? _buildPersonalInfoForm()
//                   : _buildDriverInfoForm(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPersonalInfoForm() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildTextField(label: 'Full Name', controller: _fullNameController),
//         const SizedBox(height: 20),
//         _buildTextField(label: 'Phone Number', controller: _phoneController),
//         const SizedBox(height: 20),
//         _buildTextField(
//           label: 'Email Address',
//           controller: _emailController,
//           isLocked: true,
//         ),
//         const SizedBox(height: 20),
//         _buildTextField(label: 'Profession', controller: _professionController),
//         const SizedBox(height: 40),

//         // Save Changes Button
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             onPressed: () {
//               // Handle save personal info changes
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFFFFA500),
//               elevation: 0,
//               padding: const EdgeInsets.symmetric(vertical: 18),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//             ),
//             child: const Text(
//               'Save Changes',
//               style: TextStyle(
//                 fontSize: 17,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 30),
//       ],
//     );
//   }

//   Widget _buildDriverInfoForm() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildTextField(label: 'Full Name', controller: _driverNameController),
//         const SizedBox(height: 20),
//         _buildTextField(
//           label: 'License Plate',
//           controller: _licensePlateController,
//         ),
//         const SizedBox(height: 30),

//         // Car Exterior Image Section
//         const Text(
//           'Car Exterior',
//           style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 10),
//         InkWell(
//           onTap: () => _showImageSourceDialog('car'),
//           child: Container(
//             width: double.infinity,
//             height: 180,
//             decoration: BoxDecoration(
//               color: Colors.grey.shade50,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.grey.shade300, width: 2),
//             ),
//             child: _carExteriorImage != null
//                 ? ClipRRect(
//                     borderRadius: BorderRadius.circular(14),
//                     child: Image.file(_carExteriorImage!, fit: BoxFit.cover),
//                   )
//                 : Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.directions_car,
//                         size: 48,
//                         color: Colors.grey.shade400,
//                       ),
//                       const SizedBox(height: 12),
//                       Text(
//                         'Tap to Upload Car Photo',
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.grey.shade600,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Clear exterior view of vehicle',
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey.shade500,
//                         ),
//                       ),
//                     ],
//                   ),
//           ),
//         ),
//         const SizedBox(height: 20),

//         // Driver License Image Section
//         const Text(
//           'Driver\'s License',
//           style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 10),
//         InkWell(
//           onTap: () => _showImageSourceDialog('license'),
//           child: Container(
//             width: double.infinity,
//             height: 180,
//             decoration: BoxDecoration(
//               color: Colors.grey.shade50,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.grey.shade300, width: 2),
//             ),
//             child: _driverLicenseImage != null
//                 ? ClipRRect(
//                     borderRadius: BorderRadius.circular(14),
//                     child: Image.file(_driverLicenseImage!, fit: BoxFit.cover),
//                   )
//                 : Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.badge_outlined,
//                         size: 48,
//                         color: Colors.grey.shade400,
//                       ),
//                       const SizedBox(height: 12),
//                       Text(
//                         'Tap to Upload License',
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.grey.shade600,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Front side, clear and readable',
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey.shade500,
//                         ),
//                       ),
//                     ],
//                   ),
//           ),
//         ),
//         const SizedBox(height: 40),

//         // Save Changes Button
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             onPressed: () {
//               // Handle save driver info changes
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Driver information updated successfully!'),
//                   backgroundColor: Colors.green,
//                 ),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFFFFA500),
//               elevation: 0,
//               padding: const EdgeInsets.symmetric(vertical: 18),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//             ),
//             child: const Text(
//               'Save Changes',
//               style: TextStyle(
//                 fontSize: 17,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 30),
//       ],
//     );
//   }

//   Widget _buildTextField({
//     required String label,
//     required TextEditingController controller,
//     bool isLocked = false,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 10),
//         TextField(
//           controller: controller,
//           readOnly: isLocked,
//           style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: Colors.grey.shade50,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(30),
//               borderSide: BorderSide(color: Colors.grey.shade200),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(30),
//               borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(30),
//               borderSide: const BorderSide(color: Color(0xFFFFA500), width: 2),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 24,
//               vertical: 18,
//             ),
//             suffixIcon: isLocked
//                 ? Padding(
//                     padding: const EdgeInsets.only(right: 16),
//                     child: Icon(
//                       Icons.lock_outline_rounded,
//                       color: Colors.grey.shade400,
//                       size: 20,
//                     ),
//                   )
//                 : null,
//           ),
//         ),
//       ],
//     );
//   }
// }
