class ControlResponseModel {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;
  
  const ControlResponseModel({
    required this.success,
    required this.message,
    this.data,
  });
  
  factory ControlResponseModel.fromJson(Map<String, dynamic> json) {
    return ControlResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? 'Operation completed',
      data: json['data'],
    );
  }
}