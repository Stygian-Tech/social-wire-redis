/// Commands after shutdown fail before touching the closed NIO event loop.
public struct RedisClientClosedError: Error, Sendable {
  public init() {}
}
