import 'package:dart_mq/src/core/constants/error_strings.dart';

/// The [RegistrarException] class represents a base exception related to
/// registrar operations.
///
/// It is used to handle exceptions that may occur when working with registrar
/// objects, which are responsible for managing and registering items.
///
/// Subclasses of [RegistrarException] can provide more specific information
/// about the nature of the exception.
abstract class RegistrarException implements Exception {
  /// Creates a new [RegistrarException] with the specified error [message].
  RegistrarException(this.message);

  /// The error message associated with the exception.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// The [IdAlreadyRegisteredException] class represents an exception that occurs
/// when attempting to register an ID that is already registered in a registrar.
///
/// This exception is thrown when a duplicate ID is detected during the
/// registration process.
final class IdAlreadyRegisteredException extends RegistrarException {
  /// Creates a new [IdAlreadyRegisteredException] instance with the specified
  /// [id].
  IdAlreadyRegisteredException(String id)
      : super(ExceptionStrings.idAlreadyRegistered(id));
}

/// The [IdNotRegisteredException] class represents an exception that occurs
/// when attempting to access an ID that is not registered in a registrar.
///
/// This exception is thrown when an operation is performed on an unregistered
/// ID.
final class IdNotRegisteredException extends RegistrarException {
  /// Creates a new [IdNotRegisteredException] instance with the specified [id].
  IdNotRegisteredException(String id)
      : super(ExceptionStrings.idNotRegistered(id));
}
