import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/extension/string_extension.dart';
import '../../../core/init/lang/languages.dart';
import '../../../core/init/theme/colors.dart';

import '../../../core/mixins/navigation_mixin.dart';
import '../../../core/navigation/navigation_manager.dart';
import '../../../core/utils/border_radius.dart';
import '../../../core/utils/padding.dart';
import '../model/sign in/sign_in_error_model.dart';
import '../model/sign in/sign_in_model.dart';
import '../model/sign in/sign_in_response_model.dart';
import '../model/sign up/sign_up_model.dart';
import '../view model/auth_view_model.dart';
import 'widgets/buttons/back_navigation_button.dart';
import 'widgets/buttons/sign_button.dart';
import 'widgets/buttons/sign_with_icon_buttons.dart';
import 'widgets/check_box_list_tiles/checkbox_list_tile.dart';
import 'widgets/containers/background_image.dart';
import 'package:flutter/material.dart';

import 'widgets/divider/divider_text.dart';
import 'widgets/text_fields/password_text_field.dart';
import 'widgets/text_fields/text_field.dart';
import 'widgets/texts/custom_text_with_button.dart';
import 'widgets/texts/sign_title.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> with NavigatornMixinStateful {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _rememberMe = true;

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.read<AuthViewModel>();

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
      body: Consumer<AuthViewModel>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
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
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SignTitleText(text: "auth.sign_in_title".tr()),
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

                              CustomPasswordTextField(
                                controller: passwordController,
                                hintText: "auth.password_hint".tr(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "auth.errors.password_empty".tr();
                                  }
                                  if (value.length < 8) {
                                    return "auth.errors.password_short".tr();
                                  }
                                  return null;
                                },
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomCheckboxListTile(
                                    message: 'auth.remember_me'.tr(),
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value;
                                      });
                                      return value;
                                    },
                                  ),
                                  Padding(
                                    padding:
                                        Paddings.forgotPasswordButtonPadding,
                                    child: TextButton(
                                      onPressed: () {
                                        router.pushToPage(
                                          RouteName.forgotPassword,
                                        );
                                      },
                                      child: Text(
                                        'auth.forgot_password'.tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                              color: AppColors.cyanBlueAzure,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SignButton(
                                isLodaing: provider.isLoading,
                                message: 'buttons.sign_in'.tr(),
                                isEnabled: true,
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    dynamic result = await authViewModel.signIn(
                                      SignInModel(
                                        userNameOrEmail: emailController.text,
                                        password: passwordController.text,
                                      ),
                                    );

                                    bool success = false;
                                    String message = "";

                                    // result SignInResponse (success) və ya SignInErrorResponse (error) ola bilər
                                    if (result is SignInResponse) {
                                      success = true;
                                      message = "Successfully Logged In";
                                    } else if (result is SignInErrorResponse) {
                                      success = false;
                                      message =
                                          result.errorMessage ??
                                          "Unknown error";
                                    } else {
                                      success = false;
                                      message = "Unexpected error";
                                    }

                                    // Snackbar göstər
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(message),
                                        backgroundColor: success
                                            ? Colors.green
                                            : Colors.red,
                                        behavior: SnackBarBehavior.floating,
                                        margin: const EdgeInsets.all(12),
                                        duration: const Duration(
                                          milliseconds: 1500,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    );

                                    // Əgər success → 1500 ms sonra route
                                    if (success) {
                                      Future.delayed(
                                        const Duration(milliseconds: 1500),
                                        () {
                                          router.pushAndRemoveUntil(RouteName.home);
                                        },
                                      );
                                    }
                                  }
                                },
                              ),

                              // DividerText(text: 'auth.sign_in_with'.tr()),
                              // SignWidthIcons(),

                              TextWidthButton(
                                text: 'auth.dont_have_account'.tr(),
                                buttonText: 'buttons.sign_up'.tr(),
                                onPressed: () {
                                  router.pushToPage(RouteName.signUp);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
