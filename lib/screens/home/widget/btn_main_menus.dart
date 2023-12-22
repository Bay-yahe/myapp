import 'package:bay_yahe_app/screens/home/widget/BookingForm/booking_form.dart';
import 'package:flutter/material.dart';

class BtnMainMenus extends StatefulWidget {
  const BtnMainMenus({super.key});

  @override
  State<BtnMainMenus> createState() => _BtnMainMenusState();
}

class _BtnMainMenusState extends State<BtnMainMenus> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Wrap(
        children: [
          MenuIcon(
            title: 'Book Now',
            imageAsset: 'assets/icons/M-trike.png',
          ),
        ],
      ),
    );
  }
}

class MenuIcon extends StatelessWidget {
  final String title;
  final String imageAsset;
  const MenuIcon({
    super.key,
    required this.title,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BookingForm()),
            );
          },
          icon: Image.asset(
            imageAsset,
          ),
          iconSize: 60,
        ),
        Text(title),
      ],
    );
  }
}
