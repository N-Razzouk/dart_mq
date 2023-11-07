import 'package:dart_mq/src/core/constants/error_strings.dart';

/// The [BindingException] class represents a base exception related to
/// bindings.
///
/// It is used to handle exceptions that may occur when working with bindings,
/// such as when a binding key is not found or when a binding key is required
/// but not provided.
///
/// Subclasses of [BindingException] can provide more specific information about
/// the nature of the exception.
abstract base class BindingException implements Exception {
  /// Creates a new [BindingException] with the specified error [message].
  BindingException(this.message);

  /// The error message associated with the exception.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// The [BindingKeyNotFoundException] class represents an exception that occurs
/// when a binding key is not found.
///
/// This exception is thrown when attempting to access a binding key that does
/// not exist in the context of bindings.
final class BindingKeyNotFoundException extends BindingException {
  /// Creates a new [BindingKeyNotFoundException] instance.
  BindingKeyNotFoundException(String key)
      : super(ExceptionStrings.bindingKeyNotFound(key));
}

/// The [BindingKeyRequiredException] class represents an exception that occurs
/// when a binding key is required but not provided.
///
/// This exception is thrown when a binding operation expects a binding key to
/// be provided, but it is missing or empty.
final class BindingKeyRequiredException extends BindingException {
  /// Creates a new [BindingKeyRequiredException] instance.
  BindingKeyRequiredException() : super(ExceptionStrings.bindingKeyRequired());
}
