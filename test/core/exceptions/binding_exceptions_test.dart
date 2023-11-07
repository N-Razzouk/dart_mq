import 'package:dart_mq/src/core/exceptions/exceptions.dart';
import 'package:test/test.dart';

void main() {
  group('BindingException', () {
    test('BindingKeyNotFoundException', () {
      final exception = BindingKeyNotFoundException('test-key');
      expect(exception.toString(), contains('BindingKeyNotFoundException'));
      expect(
        exception.toString(),
        contains(
          'BindingKeyNotFoundException:'
          ' The binding key "test-key" was not found.',
        ),
      );
    });

    test('BindingKeyRequiredException', () {
      final exception = BindingKeyRequiredException();
      expect(exception.toString(), contains('BindingKeyRequiredException'));
      expect(exception.toString(), contains('Binding key is required'));
    });
  });
}
