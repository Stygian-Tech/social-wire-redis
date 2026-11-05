import Foundation
import Logging
import Testing
@testable import SocialWireRedis

@Test(.enabled(if: ProcessInfo.processInfo.environment["REDIS_INTEGRATION_URL"] != nil))
func shutdownIsIdempotentAndLateCommandsDoNotTouchTheClosedEventLoop() async throws {
  let url = try #require(ProcessInfo.processInfo.environment["REDIS_INTEGRATION_URL"])
  let client = try RediStackRedisClient(configuration: RedisConfiguration(url: url), logger: Logger(label: "redis-shutdown"))
  try await client.ping()
  try await client.shutdown()
  try await client.shutdown()
  await #expect(throws: RedisClientClosedError.self) { try await client.ping() }
  await #expect(throws: RedisClientClosedError.self) { try await client.get("late") }
  await #expect(throws: RedisClientClosedError.self) { try await client.execute(command: "PING", arguments: []) }
}
