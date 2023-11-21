import 'package:bay_yahe_app/screens/profile/notifications/widget/notification_travel.dart';
import 'package:flutter/material.dart';
import 'package:bay_yahe_app/Data/messages_data.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Background color of the app bar
        title: const Text(
          "Notification",
          style: TextStyle(
            color: Colors.black, // Text color of the title
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true, // Center the title text
        leading: const BackButton(
          color: Colors.black, // Set the back button color to black
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        child: ListView.builder(
          itemCount: MessagesData.mapNotification.length,
          itemBuilder: (context, index) {
            return NotificationTravel(
              type: MessagesData.mapNotification[index]["type"],
              title: MessagesData.mapNotification[index]["title"],
              shortContent: MessagesData.mapNotification[index]["shortContent"],
              day: MessagesData.mapNotification[index]["day"],
              icon: MessagesData.mapNotification[index]["icon"],
              isRead: MessagesData.mapNotification[index]["isRead"],
            );
          },
        ),
      ),
    );
  }
}
