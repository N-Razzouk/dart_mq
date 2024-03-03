import 'dart:async';

import 'package:dart_mq/src/consumer/consumer.interface.dart';
import 'package:dart_mq/src/core/exceptions/exceptions.dart';
import 'package:dart_mq/src/core/registrar/simple_registrar.dart';
import 'package:dart_mq/src/message/message.dart';
import 'package:dart_mq/src/mq/mq.dart';

/// A mixin implementing the `ConsumerInterface` for message consumption.
///
/// The `ConsumerMixin` mixin provides a concrete implementation of the
/// `ConsumerInterface`for message consumption. It allows classes to easily
/// consume messages from specific queues by subscribing to them, handling
/// received messages, and managing subscriptions.
///
/// Example:
/// ```dart
/// class MyMessageConsumer with ConsumerMixin {
///   // Custom implementation of the message consumer.
/// }
/// ```
mixin ConsumerMixin implements ConsumerInterface {
  /// A registry of active message subscriptions.
  final Registrar<StreamSubscription<Message>> _subscriptions =
      Registrar<StreamSubscription<Message>>();

  @override
  Message? getLatestMessage(String queueId) =>
      MQClient.instance.getLatestMessage(queueId);

  @override
  void subscribe({
    required String queueId,
    required Function(Message) callback,
    bool Function(Object)? filter,
  }) {
    try {
      final messageStream = MQClient.instance.fetchQueue(queueId);

      final sub = filter != null
          ? messageStream.listen((Message message) {
              if (filter(message.payload)) {
                callback(message);
              }
            })
          : messageStream.listen(callback);

      _subscriptions.register(queueId, sub);
    } on IdAlreadyRegisteredException catch (_) {
      throw ConsumerAlreadySubscribedException(
        consumer: runtimeType.toString(),
        queue: queueId,
      );
    }
  }

  @override
  void unsubscribe({required String queueId}) => _subscriptions
    ..get(queueId).cancel()
    ..unregister(queueId);

  @override
  void pauseSubscription(String queueId) => _subscriptions.get(queueId).pause();

  @override
  void resumeSubscription(String queueId) =>
      _subscriptions.get(queueId).resume();

  @override
  void updateSubscription({
    required String queueId,
    required Function(Message) callback,
    bool Function(Object)? filter,
  }) {
    _subscriptions.get(queueId).cancel();
    _subscriptions.unregister(queueId);
    subscribe(
      queueId: queueId,
      callback: callback,
      filter: filter,
    );
  }

  @override
  void clearSubscriptions() {
    for (final StreamSubscription sub in _subscriptions.getAll()) {
      sub.cancel();
    }

    _subscriptions.clear();
  }
}
