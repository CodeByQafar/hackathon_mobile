import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../core/init/theme/colors.dart';
import '../../../core/utils/padding.dart';
import '../../../core/navigation/navigation_manager.dart';
import '../view model/verify_code_view_model.dart';

class VerifyCodeView extends StatelessWidget {
  VerifyCodeView({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<VerifyCodeViewModel>(context);

    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: TextStyle(
        fontSize: 20,
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Theme.of(context).primaryColor, width: 2),
      borderRadius: BorderRadius.circular(12),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: InkWell(
              onTap: () => NavigationManager.instance.popPage(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(CupertinoIcons.back, color: AppColors.cynicalBlack),
                  Padding(
                    padding: Paddings.backTextPadding,
                    child: Text(
                      "auth.back".tr(),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.cynicalBlack,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Icon(Icons.lock, size: 80, color: Theme.of(context).primaryColor),
            const SizedBox(height: 20),
            Text(
              "auth.verify_code_title".tr(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "auth.verify_code_subtitle".tr(),
              textAlign: TextAlign.center,
              style:
                  Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 40),
            Form(
              key: _formKey,
              child: Pinput(
                length: 4,
                controller: vm.pinController,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                showCursor: true,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: vm.isLoading
                      ? Colors.grey.shade400
                      : Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: vm.isLoading
                    ? null
                    : () async {
                        final ok = await vm.checkPin(context);
                        if (ok) {
                          NavigationManager.instance.pushToPage(RouteName.welcome);
                        }
                      },
                child: vm.isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: FittedBox(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      )
                    : Text(
                        "buttons.verify_code".tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
