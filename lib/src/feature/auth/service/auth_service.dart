import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hackathon_mobile/src/feature/auth/model/sign%20up/sign_up_model.dart';
import 'package:hackathon_mobile/src/feature/auth/model/sign%20up/sign_up_error_model.dart';
import 'package:hackathon_mobile/src/feature/auth/model/sign%20in/sign_in_model.dart';
import 'package:hackathon_mobile/src/feature/auth/model/sign%20in/sign_in_response_model.dart';
import 'package:hackathon_mobile/src/feature/auth/model/sign%20in/sign_in_error_model.dart';

class AuthService {
  final String baseUrl;

  AuthService({required this.baseUrl});

  
Future<dynamic> signIn(SignInModel model) async {
  final url = Uri.parse('$baseUrl/api/Auth/Login');

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(model.toJson()),
    );

    // JSON parse yalnız body boş deyilsə
    dynamic json;
    if (response.body.isNotEmpty) {
      try {
        json = jsonDecode(response.body);
      } catch (_) {
        json = null;
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300 && json != null && json['success'] == true) {
      return SignInResponse.fromJson(json);
    } else if (json != null) {
      return SignInErrorResponse.fromJson(json);
    } else {
      return SignInErrorResponse(
        success: false,
        errorFlag: true,
        errorMessage: 'HTTP Error: ${response.statusCode}',
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
  }
}

Future<dynamic> signUp(SignUpModel model) async {
  final url = Uri.parse('$baseUrl/api/Auth/Register');

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(model.toJson()),
    );

    dynamic json;
    if (response.body.isNotEmpty) {
      try {
        json = jsonDecode(response.body);
      } catch (_) {
        json = null;
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300 && json != null && json['success'] == true) {
      // Avtomatik sign in
      dynamic signInResult = await signIn(
        SignInModel(userNameOrEmail: model.userName, password: model.password),
      );
      if (signInResult is SignInResponse) {
        return signInResult; // Success
      } else {
        return SignUpErrorResponse(
          success: false,
          errorFlag: true,
          errorMessage: "Sign in after sign up failed",
          data: null,
        );
      }
    } else if (json != null) {
      return SignUpErrorResponse.fromJson(json);
    } else {
      return SignUpErrorResponse(
        success: false,
        errorFlag: true,
        errorMessage: 'HTTP Error: ${response.statusCode}',
        data: null,
      );
    }
  } catch (e) {
    return SignUpErrorResponse(
      success: false,
      errorFlag: true,
      errorMessage: e.toString(),
      data: null,
    );
  }
}


}
