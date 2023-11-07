import 'package:dart_mq/src/core/exceptions/exceptions.dart';
import 'package:test/test.dart';

void main() {
  group('ExchangeException', () {
    test('ExchangeNotRegisteredException', () {
      final exception = ExchangeNotRegisteredException('NewsExchange');
      expect(exception.toString(), contains('ExchangeNotRegisteredException'));
      expect(
        exception.toString(),
        contains('Exchange: NewsExchange is not registered'),
      );
    });

    test('InvalidExchangeTypeException', () {
      final exception = InvalidExchangeTypeException();
      expect(exception.toString(), contains('InvalidExchangeTypeException'));
      expect(exception.toString(), contains('Exchange type is invalid.'));
    });
  });
}
