import 'package:dart_mq/src/core/exceptions/exceptions.dart';
import 'package:test/test.dart';

void main() {
  group('RegistrarException', () {
    test('IdAlreadyRegisteredException', () {
      final exception = IdAlreadyRegisteredException('my_id');
      expect(exception.toString(), contains('IdAlreadyRegisteredException'));
      expect(
        exception.toString(),
        contains('IdAlreadyRegisteredException: Id '
            '"my_id" already registered'),
      );
    });

    test('IdNotRegisteredException', () {
      final exception = IdNotRegisteredException('my_id');
      expect(exception.toString(), contains('IdNotRegisteredException'));
      expect(
        exception.toString(),
        contains('IdNotRegisteredException: Id "my_id" not registered.'),
      );
    });
  });
}
