import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function() onpress;
  const ActionButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onpress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpress,
      child: Container(
        height: 70,
        width: 100,
        decoration: BoxDecoration(
          color: const Color(0xFF33c072),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Icon(
              icon, // Use FontAwesomeIcons here
              color: Colors.white,
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
