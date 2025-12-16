import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import '../../../core/init/theme/colors.dart';
import '../../../core/mixins/navigation_mixin.dart';
import '../../../core/navigation/navigation_manager.dart';
import 'widgets/buttons/signin_button.dart';
import 'widgets/buttons/signup_button.dart';
import 'widgets/containers/background_image.dart';
import 'widgets/texts/subtitle_text.dart';
import '../../../core/utils/padding.dart';
import 'widgets/texts/title_text.dart';
import 'package:flutter/material.dart';

class WelcomeView extends StatefulWidget  {
  WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> with NavigatornMixinStateful<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.black,
        statusBarIconBrightness: Brightness.light,

        systemNavigationBarColor: AppColors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      ),
      body: BackgroundImage(
        child: Column(
          children: [
            Padding(
              padding: Paddings.titleTopPadding,
              child: Column(
                children: [
                  TitleText(text: 'welcome_screen.title'.tr()),
                  SubtitleText(text: 'welcome_screen.subtitle'.tr()),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SignInButton(
                    onPressed: () {
                      router.pushToPage(RouteName.signIn);
                    },
                    text: "buttons.sign_in".tr(),
                  ),
                ),
                Expanded(
                  child: SignUpButton(
                    onPressed: () {
                      router.pushToPage(RouteName.signUp);
                    },
                    text: "buttons.sign_up".tr(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
