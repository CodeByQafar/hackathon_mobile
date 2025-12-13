
class SignUpModel {
  final String name;
  final String surname;
  final String userName;
  final String email;
  final String password;
  final String confirmPassword;

  SignUpModel({
    required this.userName,
    required this.email,
    required String password,
  })  : password = password,
        confirmPassword = password, 
        name = _extractName(userName),
        surname = _extractSurname(userName);

  
  static String _extractName(String userName) {
    final parts = userName.split('_'); 
    return parts.isNotEmpty ? parts.first : userName;
  }

  
  static String _extractSurname(String userName) {
    final parts = userName.split('_');
    return parts.length > 1 ? parts.last : userName;
  }

  
  Map<String, dynamic> toJson() => {
        "name": '',
        "surname": '',
        "userName": userName,
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
      };
}
