import 'package:dart_mq/src/core/exceptions/exceptions.dart';
import 'package:test/test.dart';

void main() {
  group('ConsumerException', () {
    test('ConsumerNotRegisteredException', () {
      final exception = ConsumerNotRegisteredException('Alice');
      expect(exception.toString(), contains('ConsumerNotRegisteredException'));
      expect(
        exception.toString(),
        contains('ConsumerNotRegisteredException: The consumer "Alice" is not '
            'registered.'),
      );
    });

    test('ConsumerAlreadySubscribedException', () {
      final exception = ConsumerAlreadySubscribedException(
        consumer: 'NewsConsumer',
        queue: 'NewsQueue',
      );
      expect(
        exception.toString(),
        contains('ConsumerAlreadySubscribedException'),
      );
      expect(
        exception.toString(),
        contains(
            'ConsumerAlreadySubscribedException: The consumer "NewsConsumer" '
            'is already subscribed to the queue "NewsQueue".'),
      );
    });

    test('ConsumerNotSubscribedException', () {
      final exception = ConsumerNotSubscribedException(
        consumer: 'WeatherConsumer',
        queue: 'WeatherQueue',
      );
      expect(exception.toString(), contains('ConsumerNotSubscribedException'));
      expect(
        exception.toString(),
        contains(
            'ConsumerNotSubscribedException: The consumer "WeatherConsumer" '
            'is not subscribed to the queue "WeatherQueue".'),
      );
    });

    test('ConsumerHasSubscriptionsException', () {
      final exception = ConsumerHasSubscriptionsException('Bob');
      expect(
        exception.toString(),
        contains('ConsumerHasSubscriptionsException'),
      );
      expect(
        exception.toString(),
        contains('ConsumerHasSubscriptionsException: The consumer "Bob" has '
            'active subscriptions.'),
      );
    });
  });
}
