import 'package:dart_mq/src/core/exceptions/exceptions.dart';
import 'package:dart_mq/src/core/registrar/simple_registrar.dart';
import 'package:test/test.dart';

void main() {
  late Registrar<String> registrar;

  setUp(() {
    registrar = Registrar<String>();
  });

  test('register and get objects', () {
    registrar
      ..register('user_1', 'Alice')
      ..register('user_2', 'Bob');

    expect(registrar.get('user_1'), equals('Alice'));
    expect(registrar.get('user_2'), equals('Bob'));
  });

  test('register throws IdAlreadyRegisteredException for duplicate IDs', () {
    registrar.register('user_1', 'Alice');
    expect(
      () => registrar.register('user_1', 'Another Alice'),
      throwsA(const TypeMatcher<IdAlreadyRegisteredException>()),
    );
  });

  test('get throws IdNotRegisteredException for unknown IDs', () {
    expect(
      () => registrar.get('unknown_id'),
      throwsA(const TypeMatcher<IdNotRegisteredException>()),
    );
  });

  test('getAll returns a list of all registered objects', () {
    registrar
      ..register('user_1', 'Alice')
      ..register('user_2', 'Bob');

    final allObjects = registrar.getAll();

    expect(allObjects, contains('Alice'));
    expect(allObjects, contains('Bob'));
  });

  test('unregister removes objects', () {
    registrar
      ..register('user_1', 'Alice')
      ..register('user_2', 'Bob')
      ..unregister('user_1');

    expect(
      () => registrar.get('user_1'),
      throwsA(const TypeMatcher<IdNotRegisteredException>()),
    );
    expect(registrar.get('user_2'), equals('Bob'));
  });

  test('unregister throws IdNotRegisteredException for unknown IDs', () {
    expect(
      () => registrar.unregister('unknown_id'),
      throwsA(const TypeMatcher<IdNotRegisteredException>()),
    );
  });

  test('clear removes all registered objects', () {
    registrar
      ..register('user_1', 'Alice')
      ..register('user_2', 'Bob')
      ..clear();

    expect(registrar.count, equals(0));
  });

  test('has checks if an object is registered', () {
    registrar.register('user_1', 'Alice');

    expect(registrar.has('user_1'), isTrue);
    expect(registrar.has('user_2'), isFalse);
  });

  test('count returns the number of registered objects', () {
    registrar
      ..register('user_1', 'Alice')
      ..register('user_2', 'Bob');

    expect(registrar.count, equals(2));
  });

  test('toString returns a formatted string representation of the registrar',
      () {
    registrar
      ..register('user_1', 'Alice')
      ..register('user_2', 'Bob');

    const expectedString = '''
Registrar( 
\tuser_1: Alice,
\tuser_2: Bob
     )''';

    expect(registrar.toString(), equals(expectedString));
  });
}
