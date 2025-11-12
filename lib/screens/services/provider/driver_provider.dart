import 'package:flutter/material.dart';

class DriverProvider extends ChangeNotifier {
  String? _fullName;
  String? _licensePlate;
  String? _vehicleType;
  String? _carImageUrl;
  String? _licenseImageUrl;
  bool _isVerified = false;

  // Getters
  String? get fullName => _fullName;
  String? get licensePlate => _licensePlate;
  String? get vehicleType => _vehicleType;
  String? get carImageUrl => _carImageUrl;
  String? get licenseImageUrl => _licenseImageUrl;
  bool get isVerified => _isVerified;

  // Setters
  void setDriverInfo({
    String? fullName,
    String? licensePlate,
    String? vehicleType,
    String? carImageUrl,
    String? licenseImageUrl,
    bool? isVerified,
  }) {
    _fullName = fullName;
    _licensePlate = licensePlate;
    _vehicleType = vehicleType;
    _carImageUrl = carImageUrl;
    _licenseImageUrl = licenseImageUrl;
    _isVerified = isVerified ?? _isVerified;
    notifyListeners();
  }

  void clearDriverInfo() {
    _fullName = null;
    _licensePlate = null;
    _vehicleType = null;
    _carImageUrl = null;
    _licenseImageUrl = null;
    _isVerified = false;
    notifyListeners();
  }
}

class userprovider extends ChangeNotifier {
  String? _fullName;
  String? _email;
  String? _phoneNumber;
  String? _profileImageUrl;
  String? _profession;
  //GETTERS
  String? get fullName => _fullName;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;
  String? get profileImageUrl => _profileImageUrl;
  String? get profession => _profession;
  void setuserInfo({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
    String? profession,
  }) {
    fullName = fullName;
    email = email;
    phoneNumber = phoneNumber;
    profileImageUrl = profileImageUrl;
    profession = profession;
    notifyListeners();
  }

  void clearuserInfo() {
    _fullName = null;
    _email = null;
    _phoneNumber = null;
    _profileImageUrl = null;
    _profession = null;
    notifyListeners();
  }
}
