import 'package:flutter/material.dart';

class UpgradePopup extends StatelessWidget {
  final String currentVersion;
  final String latestVersion;

  const UpgradePopup({
    super.key,
    required this.currentVersion,
    required this.latestVersion,
  });

  Future<void> checkForUpgrade(BuildContext context) async {
    if (currentVersion != latestVersion) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('New Version Available'),
            content: const Text(
                'A new version of the app is available. Please upgrade to the latest version.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Upgrade'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    checkForUpgrade(context);
    return Container(); // Return your actual widget here
  }
}
