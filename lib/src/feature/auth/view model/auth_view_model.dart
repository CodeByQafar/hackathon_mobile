import 'package:flutter/material.dart';
import '../../../core/cache/cache_service.dart';
import '../../../core/cache/user_cache.dart';
import '../model/sign in/sign_in_model.dart';
import '../model/sign in/sign_in_error_model.dart';
import '../model/sign in/sign_in_response_model.dart';
import '../model/sign up/sign_up_model.dart';
import '../model/sign up/sign_up_error_model.dart';
import '../service/auth_service.dart';
class AuthViewModel extends ChangeNotifier {
  final AuthService authService =
      AuthService(baseUrl: "http://cafemangementaapi.runasp.net");

  bool isLoading = false;

  
  static String? token;
  static String? email;
  static String? password;

  
  
  
  Future<dynamic> signIn(SignInModel model) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await authService.signIn(model);

      if (response is SignInResponse) {
        
        token = response.items[0].token;
        email = model.userNameOrEmail;
        password = model.password;

        GlobalUserCache.saveUser(tokenValue: token!, emailValue: email!, passwordValue: password!);
   

        return response;
      } else if (response is SignInErrorResponse) {
        return response;
      } else {
        return SignInErrorResponse(
          success: false,
          errorFlag: true,
          errorMessage: "Unexpected response",
          data: null,
        );
      }
    } catch (e) {
      return SignInErrorResponse(
        success: false,
        errorFlag: true,
        errorMessage: e.toString(),
        data: null,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  
  
  
  Future<dynamic> signUp(SignUpModel model) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await authService.signUp(model);

      if (response is SignUpErrorResponse) {
        return response;
      } else {
        
        final signInResult = await signIn(
          SignInModel(userNameOrEmail: model.email, password: model.password),
        );
        return signInResult;
      }
    } catch (e) {
      return SignUpErrorResponse(
        success: false,
        errorFlag: true,
        errorMessage: e.toString(),
        data: null,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  
  
 
}
