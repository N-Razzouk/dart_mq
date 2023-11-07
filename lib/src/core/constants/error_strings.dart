/// A utility class providing exception-related error messages.
///
/// The `ExceptionStrings` class defines static methods that generate error
/// messages for various exception scenarios. These messages can be used to
/// provide descriptive error information in exception handling and debugging.
class ExceptionStrings {
  /// Generates an error message when MQClient is not initialized.
  ///
  /// This message is used when attempting to use the MQClient before it has
  /// been properly initialized using the `MQClient.initialize()` method.
  static String mqClientNotInitialized() =>
      'MQClient is not initialized. Please make sure to call '
      'MQClient.initialize() first.';

  /// Generates an error message for a Queue that is not registered.
  ///
  /// The [queueId] parameter represents the name of the unregistered queue.
  static String queueNotRegistered(String queueId) =>
      'Queue: $queueId is not registered.';

  /// Generates an error message for a queue with active subscribers.
  ///
  /// The [queueId] parameter represents the ID of the queue with active
  /// subscribers.
  static String queueHasSubscribers(String queueId) =>
      'Queue: $queueId has subscribers.';

  /// Generates an error message for a queue with no name.
  ///
  /// This message is used when the name of the queue is not provided and is
  /// null.
  static String queueIdNull() => "Queue name can't be null.";

  /// Generates an error message for a required routing key.
  ///
  /// This message is used when a routing key is required for a specific
  /// operation but is not provided.
  static String routingKeyRequired() => 'Routing key is required.';

  /// Generates an error message for a non-existent binding key.
  ///
  /// The [bindingKey] parameter represents the non-existent binding key.
  static String bindingKeyNotFound(String bindingKey) =>
      'The binding key "$bindingKey" was not found.';

  /// Generates an error message for a missing binding key.
  ///
  /// This message is used when a binding operation expects a binding key to
  static String bindingKeyRequired() => 'Binding key is required.';

  /// Generates an error message for an exchange that is not registered.
  ///
  /// The [exchangeName] parameter represents the name of the unregistered
  /// exchange.
  static String exchangeNotRegistered(String exchangeName) =>
      'Exchange: $exchangeName is not registered.';

  /// Generates an error message for invalid exchange type.
  static String invalidExchangeType() => 'Exchange type is invalid.';

  /// Generates an error message for a consumer that is not subscribed to a
  /// queue.
  ///
  /// The [consumerId] parameter represents the ID of the consumer.
  /// The [queue] parameter represents the name of the queue.
  static String consumerNotSubscribed(String consumerId, String queue) =>
      'The consumer "$consumerId" is not subscribed to the queue "$queue".';

  /// Generates an error message for a consumer that is already subscribed to
  /// a queue.
  ///
  /// The [consumerId] parameter represents the ID of the consumer.
  /// The [queue] parameter represents the name of the queue.
  static String consumerAlreadySubscribed(String consumerId, String queue) =>
      'The consumer "$consumerId" is already subscribed to the queue "$queue".';

  /// Generates an error message for a consumer that is not registered.
  ///
  /// The [consumerId] parameter represents the ID of the consumer.
  static String consumerNotRegistered(String consumerId) =>
      'The consumer "$consumerId" is not registered.';

  /// Generates an error message for a consumer that has active subscriptions.
  ///
  /// The [consumerId] parameter represents the ID of the consumer.
  static String consumerHasSubscriptions(String consumerId) =>
      'The consumer "$consumerId" has active subscriptions.';

  /// Generates an error message for an ID that is already registered.
  ///
  /// The [id] parameter represents the ID that is already registered.
  static String idAlreadyRegistered(String id) =>
      'Id "$id" already registered.';

  /// Generates an error message for an ID that is not registered.
  ///
  /// The [id] parameter represents the ID that is not registered.
  static String idNotRegistered(String id) => 'Id "$id" not registered.';
}
