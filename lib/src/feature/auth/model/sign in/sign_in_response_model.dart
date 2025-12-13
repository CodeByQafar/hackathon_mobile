class SignInResponseItem {
  final String username;
  final String token;
  final DateTime expiredAt;

  SignInResponseItem({
    required this.username,
    required this.token,
    required this.expiredAt,
  });

  factory SignInResponseItem.fromJson(Map<String, dynamic> json) {
    return SignInResponseItem(
      username: json['username'] as String,
      token: json['token'] as String,
      expiredAt: DateTime.parse(json['expirdeAt'] as String),
    );
  }
}

class SignInResponse {
  final bool success;
  final List<SignInResponseItem> items;
  final bool errorFlag;
  final String? errorMessage;

  SignInResponse({
    required this.success,
    required this.items,
    required this.errorFlag,
    this.errorMessage,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final itemsJson = data['items'] as List<dynamic>? ?? [];
    final items = itemsJson.map((e) => SignInResponseItem.fromJson(e)).toList();

    return SignInResponse(
      success: json['success'] as bool,
      items: items,
      errorFlag: json['errorFlag'] as bool,
      errorMessage: json['errorMessage'] as String?,
    );
  }
}