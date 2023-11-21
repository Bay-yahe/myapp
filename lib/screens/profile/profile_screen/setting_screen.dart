import 'package:bay_yahe_app/screens/profile/profile_screen/security/security.dart';
import 'package:bay_yahe_app/screens/profile/profile_screen/settings/communcation_settings.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: SettingsList(),
    ),
  );
}

class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFF33c072),
      ),
      body: ListView(
        children: [
          SettingsSection(
            title: 'Privacy',
            tiles: [
              SettingsTile(
                title: 'Communication',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CommunicationScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          SettingsSection(
            title: 'Security',
            tiles: [
              SettingsTile(
                title: 'Set up Security',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PinCodeScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> tiles;

  const SettingsSection({super.key, required this.title, required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Column(children: tiles),
        const Divider(),
      ],
    );
  }
}

class SettingsTile extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final bool showIcon;

  const SettingsTile(
      {super.key,
      required this.title,
      required this.onPressed,
      this.showIcon = true});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: onPressed,
      trailing: showIcon ? const Icon(Icons.arrow_forward_ios) : null,
    );
  }
}
