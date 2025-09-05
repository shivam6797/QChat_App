class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() {
    return "ApiException: $message (Status code: $statusCode)";
  }

  static ApiException fromDioError(dynamic error) {
    if (error.response != null) {
      final statusCode = error.response?.statusCode;
      final message = error.response?.data['message'] ??
          'Something went wrong. Please try again.';

      switch (statusCode) {
        case 400:
          return ApiException("Bad Request: $message", statusCode: statusCode);
        case 401:
          return ApiException("Unauthorized: $message", statusCode: statusCode);
        case 403:
          return ApiException("Forbidden: $message", statusCode: statusCode);
        case 404:
          return ApiException("Not Found: $message", statusCode: statusCode);
        case 500:
          return ApiException("Internal Server Error", statusCode: statusCode);
        default:
          return ApiException("Unexpected Error: $message",
              statusCode: statusCode);
      }
    } else {
      return ApiException("No Internet connection or Server down");
    }
  }
}
