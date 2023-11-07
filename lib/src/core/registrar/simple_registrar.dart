import 'package:dart_mq/src/core/exceptions/exceptions.dart';

/// A generic registrar for managing and storing objects by their unique
/// identifiers.
///
/// The [Registrar] class allows you to register, get, unregister, and manage
/// objects associated with unique identifiers (IDs). It provides a way to store
/// and access objects in a key-value fashion.
///
/// Example:
/// ```dart
/// final registrar = Registrar<String>();
///
/// // Register objects with unique IDs.
/// registrar.register('user_1', 'Alice');
/// registrar.register('user_2', 'Bob');
///
/// // Get an object by its ID.
/// final user1 = registrar.get('user_1'); // Returns 'Alice'
///
/// // Check if an object with a specific ID exists.
/// final hasUser2 = registrar.has('user_2'); // Returns true
///
/// // Unregister an object by its ID.
/// registrar.unregister('user_1');
///
/// // Check the number of registered objects.
/// final count = registrar.count; // Returns 1
/// ```
final class Registrar<T> {
  /// A map to store objects with their associated IDs.
  final Map<String, T> _registry = {};

  /// Registers an object with a unique ID.
  ///
  /// The [id] parameter represents the unique identifier for the object.
  /// The [value] parameter represents the object to be registered.
  ///
  /// If an object with the same ID already exists, an
  /// [IdAlreadyRegisteredException] is thrown.
  void register(String id, T value) {
    if (_registry.containsKey(id)) {
      throw IdAlreadyRegisteredException(id);
    }
    _registry[id] = value;
  }

  /// Gets an object by its unique ID.
  ///
  /// The [id] parameter represents the unique identifier of the object to
  /// retrieve.
  ///
  /// If no object with the specified ID is found, an [IdNotRegisteredException]
  /// is thrown.
  T get(String id) {
    if (!_registry.containsKey(id)) {
      throw IdNotRegisteredException(id);
    }
    return _registry[id]!;
  }

  /// Retrieves a list of all registered objects.
  List<T> getAll() => _registry.values.toList();

  /// Unregisters an object by its unique ID.
  ///
  /// The [id] parameter represents the unique identifier of the object to
  /// unregister.
  ///
  /// If no object with the specified ID is found, an [IdNotRegisteredException]
  /// is thrown.
  void unregister(String id) {
    if (!_registry.containsKey(id)) {
      throw IdNotRegisteredException(id);
    }
    _registry.remove(id);
  }

  /// Clears the registrar, removing all registered objects.
  void clear() => _registry.clear();

  /// Checks if an object with a specific ID is registered.
  ///
  /// The [id] parameter represents the unique identifier to check.
  ///
  /// Returns `true` if an object with the specified ID is registered;
  /// otherwise, `false`.
  bool has(String id) => _registry.containsKey(id);

  /// Returns the count of registered objects.
  int get count => _registry.length;

  @override
  String toString() {
    return '''
Registrar( 
\t${_registry.entries.map((e) => '${e.key}: ${e.value}').join(',\n\t')}
     )''';
  }
}
