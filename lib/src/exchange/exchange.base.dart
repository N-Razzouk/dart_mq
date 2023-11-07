import 'package:dart_mq/src/binding/binding.dart';
import 'package:dart_mq/src/core/registrar/simple_registrar.dart';
import 'package:dart_mq/src/exchange/exchange_interface.dart';

/// An abstract base class representing an exchange for message routing.
///
/// The `BaseExchange` abstract base class defines the core functionality of a
/// message exchange for routing messages to specific queues or bindings.
///
/// Example:
/// ```dart
/// class MyExchange extends BaseExchange {
///   // Custom implementation of the exchange.
/// }
/// ```
abstract base class BaseExchange implements ExchangeInterface {
  /// Creates a new exchange with the specified [id].
  ///
  /// The [id] parameter represents the unique identifier for the exchange.
  BaseExchange(this.id);

  /// The unique identifier for the exchange.
  final String id;

  /// A registrar for managing bindings associated with the exchange.
  Registrar<Binding> bindings = Registrar<Binding>();
}
