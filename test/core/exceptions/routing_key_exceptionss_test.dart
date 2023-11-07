import 'package:dart_mq/src/core/exceptions/exceptions.dart';
import 'package:test/test.dart';

void main() {
  group('RoutingKeyException', () {
    test('RoutingKeyRequiredException', () {
      final exception = RoutingKeyRequiredException();
      expect(exception.toString(), contains('RoutingKeyRequiredException'));
      expect(exception.toString(), contains('Routing key is required'));
    });
  });
}
