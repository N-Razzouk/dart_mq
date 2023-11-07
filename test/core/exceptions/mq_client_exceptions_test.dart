import 'package:dart_mq/src/core/exceptions/exceptions.dart';
import 'package:test/test.dart';

void main() {
  group('MQClientException', () {
    test('MQClientNotInitializedException', () {
      final exception = MQClientNotInitializedException();
      expect(exception.toString(), contains('MQClientNotInitializedException'));
      expect(
        exception.toString(),
        contains('MQClientNotInitializedException: MQClient is not '
            'initialized. Please make sure to call MQClient.initialize() '
            'first.'),
      );
    });
  });
}
