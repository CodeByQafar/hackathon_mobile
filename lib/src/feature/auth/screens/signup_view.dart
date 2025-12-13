import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:hackathon_mobile/src/feature/auth/model/sign%20in/sign_in_response_model.dart'
    show SignInResponse;
import 'package:provider/provider.dart';

import '../../../core/extension/string_extension.dart';
import '../../../core/init/lang/languages.dart';
import '../../../core/init/theme/colors.dart';
import '../../../core/mixins/navigation_mixin.dart';
import '../../../core/navigation/navigation_manager.dart';
import '../../../core/utils/border_radius.dart';
import '../model/sign up/sign_up_error_model.dart';
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

class SignUpView extends StatefulWidget {
  SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> with NavigatornMixinStateful {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isBoxChecked = true;
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
                        SignTitleText(text: "auth.sign_up_title".tr()),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              CustomTextField(
                                controller: userNameController,
                                hintText: "auth.full_name_hint".tr(),
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "auth.errors.full_name_empty".tr();
                                  }
                                  return null;
                                },
                              ),

                              CustomTextField(
                                controller: emailController,
                                hintText: "auth.email_hint".tr(),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "auth.errors.email_empty".tr();
                                  }
                                  // if (!value.isValidEmail) {
                                  //   return "auth.errors.email_invalid".tr();
                                  // }
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

                              CustomCheckboxListTile(
                                message: 'auth.personal_data_usage'.tr(),
                                onChanged: (value) {
                                  setState(() {
                                    _isBoxChecked = value;
                                  });
                                  return value;
                                },
                              ),

                              SignButton(
                                isLodaing: provider.isLoading,
                                message: "buttons.sign_up".tr(),
                                isEnabled: _isBoxChecked,
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    dynamic result = await authViewModel.signUp(
                                      SignUpModel(
                                        userName: userNameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                      ),
                                    );

                                    bool success = false;
                                    String message = "";

                                    // result SignInResponse (success) və ya SignUpErrorResponse (error) ola bilər
                                    if (result != null) {
                                      if (result is SignInResponse) {
                                        success = true;
                                        message =
                                            "Successfully Created & Logged In";
                                      } else if (result
                                          is SignUpErrorResponse) {
                                        success = false;
                                        message =
                                            result.errorMessage ??
                                            "Unknown error";
                                      } else {
                                        // Əgər dynamic tip gözlənilməz bir şeydirsə
                                        success = false;
                                        message =
                                            "Unexpected error: Unknown response type";
                                        debugPrint(
                                          "Unexpected signUp response type: ${result.runtimeType}",
                                        );
                                      }
                                    } else {
                                      success = false;
                                      message =
                                          "Unexpected error: null response";
                                      debugPrint("signUp returned null");
                                    }

                                    // Snackbar göstərişi
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

                                    // Əgər success-dirsə 1500 ms sonra route
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

                              // DividerText(text: "auth.sign_up_with".tr()),
                              // SignWidthIcons(),

                              TextWidthButton(
                                text: "auth.dont_have_account".tr(),
                                buttonText: "buttons.sign_in".tr(),
                                onPressed: () {
                                  router.pushToPage(RouteName.signIn);
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
