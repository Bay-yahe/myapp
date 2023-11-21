import 'package:bay_yahe_app/screens/messages/Chat.dart';
import 'package:bay_yahe_app/screens/profile/profile_screen.dart';
import 'package:bay_yahe_app/screens/activity/activity_screen.dart';
import 'package:bay_yahe_app/screens/home/home_screen.dart';
import 'package:bay_yahe_app/screens/payment/wallet_screen.dart';

import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: const TabBarView(
            children: [
              // Home Screen
              HomeScreen(),
              // Activity Screen
              ActivityScreen(),
              // Payment Screen
              WalletScreen(),
              // Messages Screen
              ChatPage(),
              // Profile Screen
              ProfileScreen(),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(color: Colors.black45, blurRadius: 2, spreadRadius: 0),
          ], color: Colors.white),
          child: const TabBar(
            labelColor: Color(0xFF008438),
            indicatorColor: Colors.transparent,
            labelPadding: EdgeInsets.all(0.5),
            indicatorWeight: 1,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
            unselectedLabelColor: Colors.black45,
            tabs: [
              Tab(
                icon: Icon(LineAwesomeIcons.compass),
                iconMargin: EdgeInsets.only(bottom: 5),
                text: "Home",
              ),
              Tab(
                icon: Icon(LineAwesomeIcons.newspaper),
                iconMargin: EdgeInsets.only(bottom: 5),
                text: "Activity",
              ),
              Tab(
                icon: Icon(LineAwesomeIcons.wallet),
                iconMargin: EdgeInsets.only(bottom: 5),
                text: "Wallet",
              ),
              Tab(
                icon: Icon(LineAwesomeIcons.comment_dots),
                iconMargin: EdgeInsets.only(bottom: 5),
                text: "Messages",
              ),
              Tab(
                icon: Icon(LineAwesomeIcons.user_circle),
                iconMargin: EdgeInsets.only(bottom: 5),
                text: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
