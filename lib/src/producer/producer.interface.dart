import 'package:dart_mq/src/message/message.dart';

/// An abstract interface class defining the contract for a message producer.
///
/// The `ProducerInterface` abstract interface class defines a contract for
/// classes that implement a message producer. Implementing classes must provide
/// methods for sending messages to exchanges, sending RPC (Remote Procedure
/// Call) messages, and setting a callback for push notifications.
///
/// Example:
/// ```dart
/// class MyProducer implements ProducerInterface {
///   // Custom implementation of the message producer.
/// }
/// ```
abstract interface class ProducerInterface {
  /// Sends a message to an exchange.
  ///
  /// The [payload] parameter represents the message payload to send.
  /// The [exchangeName] parameter is the name of the exchange to send the
  /// message to.
  /// The [headers] parameter is an optional map of headers for the message.
  /// The [routingKey] parameter is an optional routing key for the message.
  void sendMessage({
    required Object payload,
    required String exchangeName,
    Map<String, dynamic>? headers,
    String? routingKey,
  });

  /// Sends an RPC (Remote Procedure Call) message and awaits a response.
  ///
  /// The [processId] parameter is a unique identifier for the RPC request.
  /// The [args] parameter is an optional map of arguments for the RPC request.
  /// The [exchangeName] parameter is the name of the exchange for RPC
  /// communication.
  /// The [routingKey] parameter is an optional routing key for the RPC message.
  /// The [mapper] parameter is an optional function to map the response
  /// payload.
  ///
  /// Returns a future that completes with the response payload.
  Future<T> sendRPCMessage<T>({
    required String processId,
    required String exchangeName,
    Map<String, dynamic>? args,
    String? routingKey,
    T Function(Object)? mapper,
  });

  /// Sets a callback function to be called after every 'sendMessage` or
  /// `sendRPCMessage`.
  ///
  /// The [callback] parameter is a function that will be invoked when a push
  /// notification (message) is received.
  void setPushCallback(Function(Message message) callback);
}
