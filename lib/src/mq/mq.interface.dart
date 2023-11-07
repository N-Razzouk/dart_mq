import 'package:dart_mq/src/core/constants/enums.dart';
import 'package:dart_mq/src/message/message.dart';

/// An abstract interface class defining the contract for a message queue
/// client.
///
/// The `MQClientInterface` abstract interface class defines a contract for
/// classes that implement a message queue client. Implementing classes must
/// provide methods for fetching messages from a queue, sending messages to an
/// exchange, declaring queues and exchanges, deleting queues and exchanges,
/// binding and unbinding queues from exchanges, and more.
///
/// Example:
/// ```dart
/// class MyMQClient implements MQClientInterface {
///   // Custom implementation of the message queue client.
/// }
/// ```
abstract interface class MQClientInterface {
  /// Declares a queue in the message queue system.
  ///
  /// The [queueId] parameter represents the optional ID for the queue.
  ///
  /// Returns the ID of the declared queue.
  String declareQueue(String queueId);

  /// Deletes a queue from the message queue system.
  ///
  /// The [queueId] parameter represents the ID of the queue to be deleted.
  void deleteQueue(String queueId);

  /// Fetches messages from a queue.
  ///
  /// The [queueId] parameter represents the ID of the queue to fetch messages
  /// from.
  ///
  /// Returns a stream of messages from the specified queue.
  Stream<Message> fetchQueue(String queueId);

  /// Retrieves the list of queues.
  ///
  /// Returns a list of queue IDs.
  List<String> listQueues();

  /// Sends a message to an exchange for routing to queues.
  ///
  /// The [exchangeName] parameter represents the name of the exchange to send
  /// the message to.
  /// The [message] parameter represents the message to be sent.
  /// The [routingKey] parameter represents the optional routing key for message
  /// routing within the exchange.
  void sendMessage({
    required Message message,
    String? exchangeName,
    String? routingKey,
  });

  /// Retrieves the latest message from a queue.
  ///
  /// The [queueId] parameter represents the ID of the queue to fetch the latest
  /// message from.
  ///
  /// Returns the latest message from the specified queue or `null` if the queue
  /// is empty.
  Message? getLatestMessage(String queueId);

  /// Binds a queue to an exchange for message routing.
  ///
  /// The [queueId] parameter represents the ID of the queue to be bound.
  /// The [exchangeName] parameter represents the name of the exchange to bind
  /// to.
  /// The [bindingKey] parameter represents the optional binding key for routing
  /// messages to the queue within the exchange.
  void bindQueue({
    required String queueId,
    required String exchangeName,
    String? bindingKey,
  });

  /// Unbinds a queue from an exchange to stop message routing.
  ///
  /// The [queueId] parameter represents the ID of the queue to be unbound.
  /// The [exchangeName] parameter represents the name of the exchange to unbind
  /// from.
  /// The [bindingKey] parameter represents the optional binding key previously
  /// used for binding.
  void unbindQueue({
    required String queueId,
    required String exchangeName,
    String? bindingKey,
  });

  /// Declares an exchange in the message queue system.
  ///
  /// The [exchangeName] parameter represents the name of the exchange to be
  /// declared.
  /// The [exchangeType] parameter represents the type of exchange (e.g.,
  /// direct, fanout).
  void declareExchange({
    required String exchangeName,
    required ExchangeType exchangeType,
  });

  /// Deletes an exchange from the message queue system.
  ///
  /// The [exchangeName] parameter represents the name of the exchange to be
  /// deleted.
  void deleteExchange(String exchangeName);

  /// Closes the connection to the message queue system.
  ///
  /// This method should be called when the message queue client is no longer
  /// needed.
  void close();
}
