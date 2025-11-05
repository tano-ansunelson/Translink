import 'package:flutter/material.dart';
import 'package:translink/screens/Booking_screen/booking_ride_cargo_screen.dart';
import 'package:translink/screens/Bottom_Navigation/bottombar_navigation_screen.dart';
import 'package:translink/screens/Home/chat_screen/chat_message_screen.dart';
import 'package:translink/screens/Home/chat_screen/chat_screen.dart';
import 'package:translink/screens/Home/create_trip_screen.dart';
import 'package:translink/screens/Home/home_screen.dart';
import 'package:translink/screens/Home/search_trip_screen.dart';
import 'package:translink/screens/Profile/edit_profile_screen.dart';
import 'package:translink/screens/Profile/help_support_screen.dart';
import 'package:translink/screens/Profile/profile_screen.dart';
import 'package:translink/screens/Registration_screen/Forget_password/OTP_verfication_screen.dart';
import 'package:translink/screens/Registration_screen/Forget_password/Reset_password_comfirmation.dart';
import 'package:translink/screens/Registration_screen/Forget_password/forget_password_screen.dart';
import 'package:translink/screens/Registration_screen/authentication.dart'
    show TwoFactorAuthScreen;
import 'package:translink/screens/Registration_screen/login_screen.dart';
import 'package:translink/screens/Registration_screen/signup_screen.dart';
import 'package:translink/screens/Trip_cancellation/cancel_trip_comfirmation.dart';
import 'package:translink/screens/Trip_cancellation/cancel_trip_screen.dart'
    show TripCancelledScreen;
import 'package:translink/screens/Trip_cancellation/trip_cancellation_reason_sheet.dart';
import 'package:translink/screens/onboarding_screens/landing_screen.dart';
import 'package:translink/screens/onboarding_screens/passenger_onboarding_screen.dart';
import 'package:translink/screens/onboarding_screens/splash_screen.dart';

//import 'package:translink_project/screens/registration_screens/signup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TransLink',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: SplashScreen.id,
      routes: {
        TransLinkLandingPage.id: (context) => const TransLinkLandingPage(),
        LoginScreen.id: (context) => const LoginScreen(),
        SignUpScreen.id: (context) => const SignUpScreen(),
        SplashScreen.id: (context) => const SplashScreen(),
        TransLinkOnboardingPage.id: (context) =>
            const TransLinkOnboardingPage(),
        TransLinkBottomNav.id: (context) => const TransLinkBottomNav(),
        ResetPasswordScreen.id: (context) => const ResetPasswordScreen(),
        TwoFactorAuthScreen.id: (context) => const TwoFactorAuthScreen(),
        VerificationScreen.id: (context) => const VerificationScreen(),
        TransLinkHomePage.id: (context) => const TransLinkHomePage(),
        TransLinkProfilePage.id: (context) => const TransLinkProfilePage(),
        TransLinkSearchTripsPage.id: (context) =>
            const TransLinkSearchTripsPage(),
        SetPasswordScreen.id: (context) => const SetPasswordScreen(),
        TransLinkCreateTripPage.id: (context) =>
            const TransLinkCreateTripPage(),
        EditProfileScreen.id: (context) => const EditProfileScreen(),
        NewBookingScreen.id: (context) => const NewBookingScreen(),
        MessagesScreen.id: (context) => const MessagesScreen(),
        HelpSupportScreen.id: (context) => const HelpSupportScreen(),
        TripCancelledScreen.id: (context) => const TripCancelledScreen(),
        TripCancellationReasonSheet.id: (context) =>
            const TripCancellationReasonSheet(),
        CancelTripConfirmationScreen.id: (context) =>
            const CancelTripConfirmationScreen(),
        TransLinkChatPage.id: (context) => const TransLinkChatPage(),
      },
    );
  }
}
