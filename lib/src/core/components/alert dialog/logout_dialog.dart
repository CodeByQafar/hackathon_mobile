import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../navigation/navigation_manager.dart';
Future<bool> showLogoutDialog(BuildContext context) async {
  final bool? result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text("settings.logout_title".tr()),
        content: Text("settings.logout_message".tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("buttons.cancel".tr()),
          ),
          ElevatedButton(
            onPressed: () {Navigator.pop(context, true);
            NavigationManager.instance.pushAndRemoveUntil(RouteName.welcome);
            } ,
            child: Text("buttons.logout".tr()),
          ),
        ],
      );
    },
  );

  return result ?? false;
}
