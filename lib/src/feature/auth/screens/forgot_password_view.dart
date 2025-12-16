import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/extension/string_extension.dart';
import '../../../core/init/theme/colors.dart';
import '../../../core/mixins/navigation_mixin.dart';
import '../../../core/navigation/navigation_manager.dart';
import '../../../core/utils/border_radius.dart';
import 'widgets/buttons/back_navigation_button.dart';
import 'widgets/buttons/sign_button.dart';
import 'widgets/containers/background_image.dart';
import 'widgets/text_fields/text_field.dart';
import 'widgets/texts/sign_title.dart';

class ForgotPasswordView extends StatelessWidget with NavigatornMixinStateless {
  ForgotPasswordView({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.black,
          statusBarIconBrightness: Brightness.light,

          systemNavigationBarColor: AppColors.black,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        automaticallyImplyLeading: false,
        title: BackNavigationButton(),
      ),
      body: SingleChildScrollView(
        child: BackgroundImage(
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadiuses.backgroundContainerRadius,
                ),
                padding: const EdgeInsets.only(top: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 80,
                      color: AppColors.cyanBlueAzure,
                    ),
                    const SizedBox(height: 8),

                    Text(
                      "auth.forgot_password".tr(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),

                    Text(
                      "auth.forgot_password_subtitle".tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall!.copyWith(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 24),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: emailController,
                            hintText: "auth.email_hint".tr(),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "auth.errors.email_empty".tr();
                              }
                              if (!value.isValidEmail) {
                                return "auth.errors.email_invalid".tr();
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 40),
                          SignButton(
                            isLodaing: false,

                            message: "buttons.send_reset_link".tr(),
                            isEnabled: true,
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                router.pushToPage(RouteName.verifyCodeView);
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
