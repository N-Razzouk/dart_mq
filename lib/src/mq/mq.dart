import 'package:dart_mq/src/core/constants/enums.dart';
import 'package:dart_mq/src/core/exceptions/exceptions.dart';
import 'package:dart_mq/src/core/registrar/simple_registrar.dart';
import 'package:dart_mq/src/exchange/default_exchange.dart';
import 'package:dart_mq/src/exchange/direct_exchange.dart';
import 'package:dart_mq/src/exchange/exchange.base.dart';
import 'package:dart_mq/src/exchange/fanout_exchange.dart';
import 'package:dart_mq/src/message/message.dart';
import 'package:dart_mq/src/mq/mq.base.dart';
import 'package:dart_mq/src/mq/mq.interface.dart';
import 'package:dart_mq/src/queue/queue.dart';

/// A class representing a message queue client with various messaging
/// functionalities.
///
/// The `MQClient` class is an implementation of both the `BaseMQClient` class
/// and the `MQClientInterface` interface. It provides features for interacting
/// with message queues, including declaring and managing queues and exchanges,
/// sending and receiving messages, and binding/unbinding queues to/from exchanges.
///
/// Example:
/// ```dart
/// // Initialize the message queue client.
/// MQClient.initialize();
///
/// // Declare a queue and an exchange.
/// final queueId = MQClient.instance.declareQueue();
/// final exchangeName = 'my_direct_exchange';
/// MQClient.instance.declareExchange(
///   exchangeName: exchangeName,
///   exchangeType: ExchangeType.direct,
/// );
///
/// // Bind the queue to the exchange.
/// MQClient.instance.bindQueue(
///   queueId: queueId,
///   exchangeName: exchangeName,
/// );
///
/// // Send a message to the exchange.
/// final message = Message(
///   headers: {'contentType': 'json', 'sender': 'Alice'},
///   payload: {'text': 'Hello, World!'},
///   timestamp: '2023-09-07T12:00:002',
/// );
/// MQClient.instance.sendMessage(
///   exchangeName: exchangeName,
///   message: message,
///   routingKey: queueId,
/// );
///
/// // Fetch messages from the queue.
/// final messageStream = MQClient.instance.fetchQueue(queueId);
/// messageStream.listen((message) {
///   print('Received message: $message');
/// });
/// ```
final class MQClient extends BaseMQClient implements MQClientInterface {
  /// Private constructor to create the `MQClient` instance.
  MQClient._internal() {
    _exchanges.register('', DefaultExchange(''));
  }

  /// Initializes the `MQClient` and creates a singleton instance.
  ///
  /// This method should be called before using the `MQClient`.
  factory MQClient.initialize() => _instance ??= MQClient._internal();

  /// Singleton instance of the `MQClient`.
  static MQClient? _instance;

  /// Gets the singleton instance of the `MQClient`.
  ///
  /// Throws a [MQClientNotInitializedException] if the client has not been
  /// initialized.
  static MQClient get instance =>
      _instance ?? (throw MQClientNotInitializedException());

  final Registrar<BaseExchange> _exchanges = Registrar<BaseExchange>();
  final Registrar<Queue> _queues = Registrar<Queue>();

  @override
  String declareQueue(String queueId) {
    try {
      _queues.register(queueId, Queue(queueId));

      _exchanges.get('').bindQueue(
            queue: _queues.get(queueId),
            bindingKey: queueId,
          );

      return queueId;
    } on IdAlreadyRegisteredException catch (_) {
      return queueId;
    }
  }

  @override
  void deleteQueue(String queueId) {
    try {
      final queue = _queues.get(queueId);

      if (queue.hasListeners()) {
        throw QueueHasSubscribersException(queueId);
      } else {
        _deleteQueue(queueId);
      }
    } on IdNotRegisteredException catch (_) {
      throw QueueNotRegisteredException(queueId);
    }
  }

  void _deleteQueue(String queueId) {
    _queues.get(queueId).dispose();
    _exchanges.getAll().forEach(
          (BaseExchange exchange) => exchange.deleteQueue(queueId),
        );
    _queues.unregister(queueId);
  }

  @override
  Stream<Message> fetchQueue(String queueId) => _fetchQueue(queueId).dataStream;

  Queue _fetchQueue(String queueId) {
    try {
      return _queues.get(queueId);
    } on IdNotRegisteredException catch (_) {
      throw QueueNotRegisteredException(queueId);
    }
  }

  @override
  List<String> listQueues() => _queues
      .getAll()
      .map(
        (Queue queue) => queue.id,
      )
      .toList();

  @override
  void sendMessage({
    required Message message,
    String? exchangeName,
    String? routingKey,
  }) {
    try {
      _exchanges
          .get(exchangeName ?? '')
          .forwardMessage(routingKey: routingKey, message: message);
    } on IdNotRegisteredException catch (_) {
      throw ExchangeNotRegisteredException(exchangeName ?? '');
    }
  }

  @override
  Message? getLatestMessage(String queueId) =>
      _fetchQueue(queueId).latestMessage;

  @override
  void bindQueue({
    required String queueId,
    required String exchangeName,
    String? bindingKey,
  }) {
    try {
      final exchange = _exchanges.get(exchangeName);
      switch (exchange) {
        case DirectExchange _:
          if (bindingKey == null) {
            throw BindingKeyRequiredException();
          }
          exchange.bindQueue(
            queue: _fetchQueue(queueId),
            bindingKey: bindingKey,
          );
        case FanoutExchange _:
          exchange.bindQueue(
            queue: _fetchQueue(queueId),
            bindingKey: '',
          );
        default:
          return;
      }
    } on IdNotRegisteredException catch (_) {
      throw ExchangeNotRegisteredException(exchangeName);
    }
  }

  @override
  void unbindQueue({
    required String queueId,
    required String exchangeName,
    String? bindingKey,
  }) {
    try {
      final exchange = _exchanges.get(exchangeName);
      if (exchange.runtimeType == DirectExchange && bindingKey == null) {
        throw BindingKeyRequiredException();
      }
      exchange.unbindQueue(
        queueId: queueId,
        bindingKey: bindingKey ?? '',
      );
    } on IdNotRegisteredException catch (_) {
      throw ExchangeNotRegisteredException(exchangeName);
    }
  }

  @override
  void declareExchange({
    required String exchangeName,
    required ExchangeType exchangeType,
  }) {
    try {
      switch (exchangeType) {
        case ExchangeType.direct:
          _exchanges.register(exchangeName, DirectExchange(exchangeName));
        case ExchangeType.fanout:
          _exchanges.register(exchangeName, FanoutExchange(exchangeName));
        case ExchangeType.base:
          throw InvalidExchangeTypeException();
      }
    } on IdAlreadyRegisteredException catch (_) {
      return;
    }
  }

  @override
  void deleteExchange(String exchangeName) {
    try {
      _exchanges.unregister(exchangeName);
    } catch (_) {
      return;
    }
  }

  @override
  void close() {
    _queues.getAll().forEach(
          (Queue queue) => queue.dispose(),
        );
    _queues.clear();
    _exchanges.clear();
    _instance = null;
  }
}
