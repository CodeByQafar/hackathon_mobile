import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class VerifyCodeViewModel extends ChangeNotifier {
  final TextEditingController pinController = TextEditingController();
  bool isLoading = false;

  final List<String> validPins = [
    '4837',
    '9201',
    '1746',
    '6583',
    '3928',
    '5071',
    '8614',
    '2395',
    '7149',
    '6052',
  ];

  Future<bool> checkPin(BuildContext context) async {
    final pin = pinController.text.trim();
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 2500));

    if (validPins.contains(pin)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("buttons.verify_success".tr()),
          backgroundColor: Colors.green,
          duration: const Duration(milliseconds: 1500),
        ),
      );

      isLoading = false;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 1500));
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("buttons.verify_fail".tr()),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );

      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
