class ErrorModel {
  final int statusCode;
  final String message;
  final String? code;
  
  const ErrorModel({
    required this.statusCode,
    required this.message,
    this.code,
  });
  
  factory ErrorModel.fromJson(Map<String, dynamic> json, int statusCode) {
    return ErrorModel(
      statusCode: statusCode,
      message: json['message'] ?? json['error'] ?? 'Unknown error',
      code: json['code'],
    );
  }
}