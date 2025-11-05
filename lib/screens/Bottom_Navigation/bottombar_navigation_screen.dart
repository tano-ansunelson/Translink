import 'package:flutter/material.dart';
import 'package:translink/screens/Home/chat_screen/chat_message_screen.dart';
import 'package:translink/screens/Home/home_screen.dart';
import 'package:translink/screens/Home/my_trip_screen.dart';
import 'package:translink/screens/Profile/profile_screen.dart';

class TransLinkBottomNav extends StatefulWidget {
  const TransLinkBottomNav({super.key});
  static const String id = 'bottom_nav_screen';

  @override
  State<TransLinkBottomNav> createState() => _TransLinkBottomNavState();
}

class _TransLinkBottomNavState extends State<TransLinkBottomNav> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const TransLinkHomePage(),
    const MyTripsScreen(),
    MessagesScreen(),
    //const TransLinkChatPage(),
    const TransLinkProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: 'Home'),
          // BottomNavigationBarItem(
          //   icon: const Icon(Icons.search),
          //   label: 'Search',
          // ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.work_outline),
            label: 'My Trips',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: const Color(0xFFFFA500),
        unselectedItemColor: const Color(0xFFBBBBBB),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
