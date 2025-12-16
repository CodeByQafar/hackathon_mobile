import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../../../../../core/components/alert dialog/language_alert_dialog.dart';
import '../../../../../core/init/theme/colors.dart'; 
import '../../../../../core/mixins/navigation_mixin.dart'; 
import '../../../../../core/utils/padding.dart'; 




class BackNavigationButton extends StatefulWidget
 {
  const BackNavigationButton({super.key});

  @override
  State<BackNavigationButton> createState() => _BackNavigationButtonState();
}

class _BackNavigationButtonState extends State<BackNavigationButton>    with NavigatornMixinStateful {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        
        InkWell(
          onTap: () => router.popPage(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(CupertinoIcons.back, color: AppColors.white),
              Padding(
                padding: Paddings.backTextPadding,
                child: Text(
                  "auth.back".tr(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),

        
        InkWell(
          onTap: () {
            showLanguageSelectionDialog(context);
        
          
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Icon(Icons.language, color: AppColors.white, size: 30),
          ),
        ),
      ],
    );
  }
}

