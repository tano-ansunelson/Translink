import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:translink/screens/Home/create_trip_screen.dart';

class DriverVerificationScreen extends StatefulWidget {
  const DriverVerificationScreen({super.key});
  static const String id = 'driver_verification_screen';

  @override
  State<DriverVerificationScreen> createState() =>
      _DriverVerificationScreenState();
}

class _DriverVerificationScreenState extends State<DriverVerificationScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _licensePlateController = TextEditingController();
  final _vehicleTypeController = TextEditingController();

  // Image files
  File? _carExteriorImage;
  File? _driverLicenseImage;
  File? _profileImage;

  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _licensePlateController.dispose();
    _vehicleTypeController.dispose();
    super.dispose();
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
          } else if (type == 'profile') {
            _profileImage = File(image.path);
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

  void _nextStep() {
    if (_currentStep == 0) {
      if (_formKey.currentState!.validate()) {
        setState(() => _currentStep++);
      }
    } else if (_currentStep == 1) {
      if (_vehicleTypeController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter vehicle type')),
        );
        return;
      }
      setState(() => _currentStep++);
    } else if (_currentStep == 2) {
      if (_carExteriorImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload car exterior image')),
        );
        return;
      }
      setState(() => _currentStep++);
    } else if (_currentStep == 3) {
      if (_licensePlateController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter license plate number')),
        );
        return;
      }
      setState(() => _currentStep++);
    } else if (_currentStep == 4) {
      if (_driverLicenseImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload driver\'s license')),
        );
        return;
      }
      //_submitVerification();
      setState(() => _currentStep++);
    } else if (_currentStep == 5) {
      if (_profileImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload profile picture')),
        );
        return;
      }
      _submitVerification();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  // Future<String?> _uploadImageToStorage(File imageFile, String path) async {
  //   try {
  //     final ref = _storage.ref().child(path);
  //     final uploadTask = await ref.putFile(imageFile);
  //     final downloadUrl = await uploadTask.ref.getDownloadURL();
  //     return downloadUrl;
  //   } catch (e) {
  //     print('Error uploading image: $e');
  //     return null;
  //   }
  // }

  Future<void> _submitVerification() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Color(0xFFFFA500)),
                  SizedBox(height: 16),
                  Text('Submitting verification...'),
                ],
              ),
            ),
          ),
        ),
      );

      // Upload images to Firebase Storage (commented out for now)
      // String? carExteriorUrl;
      // String? driverLicenseUrl;
      // String? profileImageUrl;

      // if (_carExteriorImage != null) {
      //   carExteriorUrl = await _uploadImageToStorage(
      //     _carExteriorImage!,
      //     'driver_verification/${user.uid}/car_exterior.jpg',
      //   );
      // }

      // if (_driverLicenseImage != null) {
      //   driverLicenseUrl = await _uploadImageToStorage(
      //     _driverLicenseImage!,
      //     'driver_verification/${user.uid}/driver_license.jpg',
      //   );
      // }

      // if (_profileImage != null) {
      //   profileImageUrl = await _uploadImageToStorage(
      //     _profileImage!,
      //     'driver_verification/${user.uid}/profile_image.jpg',
      //   );
      // }

      // Create driver verification document
      final verificationData = {
        'userId': user.uid,
        'fullName': _nameController.text.trim().toLowerCase(),
        'licensePlate': _licensePlateController.text
            .trim()
            .toUpperCase()
            .toLowerCase(),
        'vehicleType': _vehicleTypeController.text.trim().toLowerCase(),
        // 'carExteriorImageUrl': carExteriorUrl,
        // 'driverLicenseImageUrl': driverLicenseUrl,
        // 'profileImageUrl': profileImageUrl,
        'status': 'pending', // pending, approved, rejected
        'submittedAt': FieldValue.serverTimestamp(),
        'verifiedAt': null,
      };

      // Save to driver_verifications collection
      await _firestore
          .collection('driver_verifications')
          .doc(user.uid)
          .set(verificationData);

      // Update user document with isDriverVerified flag
      await _firestore.collection('users').doc(user.uid).update({
        'isDriverVerified': true,
        'fullName': _nameController.text.trim().toLowerCase(),
        // Set to false until admin approves
        //'verificationStatus': 'pending',
        // 'verificationSubmittedAt': FieldValue.serverTimestamp(),
      });

      // Close loading dialog
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification submitted successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      // Close loading dialog
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit verification: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
    if (Navigator.canPop(context)) {
      Navigator.pop(context); // closes the dialog
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
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context); // closes the dialog
            }
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Driver Verification',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress Indicator
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step ${_currentStep + 1} of 6',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(6, (index) {
                    return Expanded(
                      child: Container(
                        height: 5,
                        margin: EdgeInsets.only(right: index < 5 ? 8 : 0),
                        decoration: BoxDecoration(
                          color: index <= _currentStep
                              ? const Color(0xFFFFA500)
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildStepContent(),
            ),
          ),

          // Bottom Buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        side: const BorderSide(color: Color(0xFFFFA500)),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFFA500),
                        ),
                      ),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 12),
                Expanded(
                  flex: _currentStep > 0 ? 1 : 2,
                  child: ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFA500),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      _currentStep == 5
                          ? 'Submit for Verification'
                          : 'Continue',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
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

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildNameStep();
      case 1:
        return _buildVehicleType();
      case 2:
        return _buildCarExteriorStep();
      case 3:
        return _buildLicensePlateStep();
      case 4:
        return _buildDriverLicenseStep();
      case 5:
        return _buildProfilePictureStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildNameStep() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What\'s your name?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Please enter your full legal name as it appears on your driver\'s license.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          TextFormField(
            controller: _nameController,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: 'Full Name',
              hintText: 'John Doe',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFFFFA500),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              if (value.trim().split(' ').length < 2) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleType() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What\'s your vehicle type?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Please specify the type of vehicle you will be using for rides.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          TextFormField(
            controller: _vehicleTypeController,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: 'Vehicle Type',
              hintText: 'Sedan, SUV, Truck, etc.',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFFFFA500),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your vehicle type';
              }
              if (value.trim().split(' ').length < 2) {
                return 'Please enter your full vehicle type';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCarExteriorStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Car Exterior',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'For your safety and the community\'s trust, please upload a photo of your vehicle.',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade600,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.lock_outline, size: 16, color: Colors.grey.shade500),
            const SizedBox(width: 8),
            Text(
              'Your information is encrypted and secure.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFA500).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.directions_car,
                        color: Color(0xFFFFA500),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Car Exterior',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Capture all four sides of your vehicle.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => _showImageSourceDialog('car'),
                child: Container(
                  margin: const EdgeInsets.all(16),
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                  ),
                  child: _carExteriorImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _carExteriorImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo_outlined,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Tap to Upload',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildProfilePictureStep() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         'Profile Picture',
  //         style: TextStyle(
  //           fontSize: 24,
  //           fontWeight: FontWeight.bold,
  //           color: Colors.black87,
  //         ),
  //       ),
  //       const SizedBox(height: 12),
  //       Text(
  //         'Upload a clear photo of yourself. This helps riders and other users recognize you.',
  //         style: TextStyle(
  //           fontSize: 15,
  //           color: Colors.grey.shade600,
  //           height: 1.5,
  //         ),
  //       ),
  //       const SizedBox(height: 8),
  //       Row(
  //         children: [
  //           Icon(Icons.lock_outline, size: 16, color: Colors.grey.shade500),
  //           const SizedBox(width: 8),
  //           Text(
  //             'Your photo is private and securely stored.',
  //             style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 40),
  //       Container(
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(16),
  //           border: Border.all(color: Colors.grey.shade200),
  //         ),
  //         child: Column(
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.all(16),
  //               child: Row(
  //                 children: [
  //                   Container(
  //                     padding: const EdgeInsets.all(12),
  //                     decoration: BoxDecoration(
  //                       color: Colors.blue.withOpacity(0.1),
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                     child: const Icon(
  //                       Icons.person,
  //                       color: Colors.blue,
  //                       size: 24,
  //                     ),
  //                   ),
  //                   const SizedBox(width: 12),
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         const Text(
  //                           'Profile Photo',
  //                           style: TextStyle(
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.w600,
  //                             color: Colors.black87,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 4),
  //                         Text(
  //                           'Make sure your face is visible and clear.',
  //                           style: TextStyle(
  //                             fontSize: 13,
  //                             color: Colors.grey.shade600,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             InkWell(
  //               onTap: () => _showImageSourceDialog('profile'),
  //               child: Container(
  //                 margin: const EdgeInsets.all(16),
  //                 height: 200,
  //                 width: 300,
  //                 decoration: BoxDecoration(
  //                   color: Colors.grey.shade50,
  //                   borderRadius: BorderRadius.circular(12),
  //                   border: Border.all(color: Colors.grey.shade300, width: 2),
  //                 ),
  //                 child: _profileImage != null
  //                     ? ClipRRect(
  //                         borderRadius: BorderRadius.circular(10),
  //                         child: Image.file(_profileImage!, fit: BoxFit.cover),
  //                       )
  //                     : Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           Icon(
  //                             Icons.add_a_photo_outlined,
  //                             size: 48,
  //                             color: Colors.grey.shade400,
  //                           ),
  //                           const SizedBox(height: 12),
  //                           Text(
  //                             'Tap to Upload',
  //                             style: TextStyle(
  //                               fontSize: 15,
  //                               color: Colors.grey.shade600,
  //                               fontWeight: FontWeight.w500,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }
  Widget _buildProfilePictureStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profile Picture',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Upload a clear photo of yourself. This helps riders and other users recognize you.',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade600,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.lock_outline, size: 16, color: Colors.grey.shade500),
            const SizedBox(width: 8),
            Text(
              'Your photo is private and securely stored.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Center(
          child: InkWell(
            onTap: () => _showImageSourceDialog('profile'),
            child: CircleAvatar(
              radius: 160, // Controls the size of the circle
              backgroundColor: Colors.grey.shade50,
              child: _profileImage != null
                  ? ClipOval(
                      child: Image.file(
                        _profileImage!,
                        width: 160,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_outlined,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap to Upload',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLicensePlateStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'License Plate',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Enter your vehicle\'s license plate number.',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade600,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 40),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFA500).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.pin_outlined,
                        color: Color(0xFFFFA500),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'License Plate',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ensure the number is clear and readable.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: TextField(
                      controller: _licensePlateController,
                      textAlign: TextAlign.center,
                      textCapitalization: TextCapitalization.characters,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                        color: Colors.black87,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'ABC 1234',
                        hintStyle: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                          color: Colors.black26,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDriverLicenseStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Driver\'s License',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'For your safety and the community\'s trust, please upload your driver\'s license.',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade600,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.lock_outline, size: 16, color: Colors.grey.shade500),
            const SizedBox(width: 8),
            Text(
              'Your information is encrypted and secure.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFA500).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.badge_outlined,
                        color: Color(0xFFFFA500),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Driver\'s License (Front)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Place on a flat surface, avoid glare.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => _showImageSourceDialog('license'),
                child: Container(
                  margin: const EdgeInsets.all(16),
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                  ),
                  child: _driverLicenseImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _driverLicenseImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo_outlined,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Tap to Upload',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
