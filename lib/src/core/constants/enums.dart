/// An enumeration representing different types of message exchanges.
///
/// The [ExchangeType] enum defines various types of message exchanges that are
/// commonly used in messaging systems. Each type represents a specific behavior
/// for distributing messages to multiple queues or consumers.
///
/// - `direct`: A direct exchange routes messages to queues based on a specified
///    routing key.
/// - `base`: The default exchange (unnamed) routes messages to queues using
///    their names.
/// - `fanout`: A fanout exchange routes messages to all connected queues,
///    ignoring routing keys.
enum ExchangeType {
  /// Represents a direct message exchange.
  direct,

  /// Represents the default exchange (unnamed).
  base,

  /// Represents a fanout message exchange.
  fanout,
}
