/// Exception thrown when location service operations fail
class LocationServiceException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  LocationServiceException({
    required this.message,
    this.code,
    this.originalException,
  });

  @override
  String toString() =>
      'LocationServiceException: $message${code != null ? ' (code: $code)' : ''}';
}

/// Exception thrown when location permission is denied
class LocationPermissionDeniedException extends LocationServiceException {
  LocationPermissionDeniedException({String? message})
    : super(
        message: message ?? 'Location permission was denied',
        code: 'PERMISSION_DENIED',
      );
}

/// Exception thrown when location permission is permanently denied
class LocationPermissionDeniedForeverException
    extends LocationServiceException {
  LocationPermissionDeniedForeverException({String? message})
    : super(
        message: message ?? 'Location permission was permanently denied',
        code: 'PERMISSION_DENIED_FOREVER',
      );
}

/// Exception thrown when location service is disabled
class LocationServiceDisabledException extends LocationServiceException {
  LocationServiceDisabledException({String? message})
    : super(
        message: message ?? 'Location service is disabled',
        code: 'SERVICE_DISABLED',
      );
}

/// Exception thrown when location request times out
class LocationTimeoutException extends LocationServiceException {
  LocationTimeoutException({String? message})
    : super(message: message ?? 'Location request timed out', code: 'TIMEOUT');
}
