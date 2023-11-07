import 'dart:async';
import 'package:dart_mq/src/message/message.dart';
import 'package:dart_mq/src/mq/mq.dart';
import 'package:dart_mq/src/producer/producer.interface.dart';

/// A mixin implementing the `ProducerInterface` for message production.
///
/// The `Producer` mixin provides a concrete implementation of the
/// `ProducerInterface` for message production. It allows classes to easily send
/// messages to exchanges, send RPC (Remote Procedure Call) messages, and set a
/// callback for handling push notifications.
///
/// Example:
/// ```dart
/// class MyMessageProducer with Producer {
///   // Custom implementation of the message producer.
/// }
/// ```
mixin Producer implements ProducerInterface {
  /// A callback function for handling push notifications (received messages).
  Function(Message message)? _callback;

  @override
  void sendMessage({
    required Object payload,
    String? exchangeName,
    Map<String, dynamic>? headers,
    String? routingKey,
    String? timestamp,
  }) {
    final newMessage = Message(
      payload: payload,
      headers: headers,
      timestamp: timestamp,
    );
    MQClient.instance.sendMessage(
      exchangeName: exchangeName,
      routingKey: routingKey,
      message: newMessage,
    );

    _callback?.call(newMessage);
  }

  @override
  Future<T> sendRPCMessage<T>({
    required String processId,
    required String exchangeName,
    Map<String, dynamic>? args,
    String? routingKey,
    T Function(Object)? mapper,
    String? timestamp,
  }) async {
    final Completer completer =
        mapper == null ? Completer<T>() : Completer<Object>();

    final newMessage = Message(
      payload: 'RPC',
      headers: {
        'type': 'RPC',
        'processId': processId,
        'args': args,
        'completer': completer,
      },
      timestamp: timestamp,
    );

    MQClient.instance.sendMessage(
      exchangeName: exchangeName,
      routingKey: routingKey,
      message: newMessage,
    );

    if (mapper == null) {
      _callback?.call(newMessage);
      final res = await completer.future.then((value) => value);
      return res;
    } else {
      _callback?.call(newMessage);
      final rawData = await completer.future.then((value) => value);
      final data = mapper(rawData);
      return data;
    }
  }

  @override
  void setPushCallback(Function(Message message) callback) =>
      _callback = callback;
}
