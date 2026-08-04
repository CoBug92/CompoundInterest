import FirebaseAnalytics

final class FirebaseAnalyticsClient {
}

// MARK: - AnalyticsClient

extension FirebaseAnalyticsClient: AnalyticsClient {

    func track(_ event: AnalyticsEvent) {
        let payload = event.firebasePayload
        Analytics.logEvent(payload.name, parameters: payload.parameters)
    }
}
