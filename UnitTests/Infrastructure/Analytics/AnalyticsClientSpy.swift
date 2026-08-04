@testable import CompoundInterest

final class AnalyticsClientSpy: AnalyticsClient {

    private(set) var trackedEvents: [AnalyticsEvent] = []

    func track(_ event: AnalyticsEvent) {
        trackedEvents.append(event)
    }
}
