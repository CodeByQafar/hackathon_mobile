class SignUpErrorResponse {
  final bool success;
  final bool errorFlag;
  final String? errorMessage;
  final SignUpErrorData? data;

  SignUpErrorResponse({
    required this.success,
    required this.errorFlag,
    this.errorMessage,
    this.data,
  });

  factory SignUpErrorResponse.fromJson(Map<String, dynamic> json) {
    return SignUpErrorResponse(
      success: json['success'] as bool,
      errorFlag: json['errorFlag'] as bool,
      errorMessage: json['errorMessage'] as String?,
      data: json['data'] != null
          ? SignUpErrorData.fromJson(json['data'])
          : null,
    );
  }
}

class SignUpErrorData {
  final List<dynamic> items;
  final dynamic pagination;

  SignUpErrorData({
    required this.items,
    this.pagination,
  });

  factory SignUpErrorData.fromJson(Map<String, dynamic> json) {
    return SignUpErrorData(
      items: json['items'] as List<dynamic>? ?? [],
      pagination: json['pagination'],
    );
  }
}
