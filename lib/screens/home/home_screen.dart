import 'package:bay_yahe_app/screens/home/widget/btn_main_menus.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF33c072),
        flexibleSpace: SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(15, 20, 15, 15),
            padding: const EdgeInsets.fromLTRB(0, 0, 2, 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: const TextField(
              maxLines: 1,
              textAlignVertical: TextAlignVertical.center,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                  hintText: "Seach Here ...",
                  prefixIcon: Icon(
                    LineAwesomeIcons.qrcode,
                    color: Colors.black45,
                  ),
                  border: InputBorder.none),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: const BtnMainMenus(),
        ),
      ),
    );
  }
}
