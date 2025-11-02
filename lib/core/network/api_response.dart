// lib/core/network/api_response.dart
class ApiResponse<T> {
  final T? data;
  final String? message;
  final bool success;
  final int? statusCode;

  ApiResponse({
    this.data,
    this.message,
    required this.success,
    this.statusCode,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>)? fromJsonT,
      ) {
    return ApiResponse(
      data: fromJsonT != null && json['data'] != null
          ? fromJsonT(json['data'] as Map<String, dynamic>)
          : null,
      message: json['message'] as String?,
      success: json['success'] as bool? ?? true,
      statusCode: json['statusCode'] as int?,
    );
  }
}