class SignInModel {
  final String userNameOrEmail;
  final String password;
  final bool isRemembered;

  SignInModel({
    required this.userNameOrEmail,
    required this.password,
    this.isRemembered = true,
  });

  Map<String, dynamic> toJson() => {
        "userNameOrEmail": userNameOrEmail,
        "password": password,
        "isRemembered": isRemembered,
      };
}