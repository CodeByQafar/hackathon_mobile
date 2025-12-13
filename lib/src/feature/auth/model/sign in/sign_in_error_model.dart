class SignInErrorResponse {
  final bool success;
  final bool errorFlag;
  final String? errorMessage;
  final SignInErrorData? data;

  SignInErrorResponse({
    required this.success,
    required this.errorFlag,
    this.errorMessage,
    this.data,
  });

  factory SignInErrorResponse.fromJson(Map<String, dynamic> json) {
    return SignInErrorResponse(
      success: json['success'] as bool,
      errorFlag: json['errorFlag'] as bool,
      errorMessage: json['errorMessage'] as String?,
      data: json['data'] != null
          ? SignInErrorData.fromJson(json['data'])
          : null,
    );
  }
}

class SignInErrorData {
  final List<dynamic> items;
  final dynamic pagination;

  SignInErrorData({
    required this.items,
    this.pagination,
  });

  factory SignInErrorData.fromJson(Map<String, dynamic> json) {
    return SignInErrorData(
      items: json['items'] as List<dynamic>? ?? [],
      pagination: json['pagination'],
    );
  }
}
