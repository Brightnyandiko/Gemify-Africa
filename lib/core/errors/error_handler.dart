// lib/core/errors/error_handler.dart
import 'package:dio/dio.dart';
import 'exceptions.dart';
import 'failures.dart';

class ErrorHandler {
  static Failure handleException(Exception exception) {
    if (exception is ServerException) {
      return ServerFailure(
        exception.message,
        statusCode: exception.statusCode,
      );
    } else if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    } else if (exception is CacheException) {
      return CacheFailure(exception.message);
    } else if (exception is ValidationException) {
      return ValidationFailure(exception.message);
    } else {
      return const ServerFailure('Unexpected error occurred');
    }
  }

  static ServerException handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw NetworkException('Connection timeout');

      case DioExceptionType.connectionError:
        throw NetworkException('No internet connection');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;

        String message = 'Server error';
        if (data is Map<String, dynamic>) {
          message = data['message'] ?? data['error'] ?? message;
        }

        return ServerException(
          message: message,
          statusCode: statusCode,
        );

      case DioExceptionType.cancel:
        return ServerException(message: 'Request cancelled');

      default:
        return ServerException(message: 'Unexpected error occurred');
    }
  }
}