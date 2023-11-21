import 'package:bay_yahe_app/screens/activity/widgets/header.dart';
import 'package:bay_yahe_app/screens/activity/widgets/tabbar_activity.dart';
import 'package:flutter/material.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Header(),

            SizedBox(
              height: 10,
            ),

            TabbarActivity()
            // Tabbar Act
          ],
        ),
      ),
    );
  }
}
