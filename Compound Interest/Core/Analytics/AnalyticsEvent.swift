/// Описывает разрешённые события аналитики приложения.
///
/// События не содержат финансовых значений, идентификаторов пользователя или
/// иных данных, позволяющих идентифицировать пользователя.
enum AnalyticsEvent: Equatable {
    case calculationAttempted(outcome: CalculationOutcome)
    case historyOpened
    case historyEntryReused
    case resultExportStarted

    /// Описывает итог попытки рассчитать результат без передачи введённых значений.
    enum CalculationOutcome: String, Equatable {
        case completed
        case missingRequiredInput = "missing_required_input"
        case invalidDuration = "invalid_duration"
    }
}

extension AnalyticsEvent {
    var firebasePayload: (name: String, parameters: [String: Any]?) {
        switch self {
        case let .calculationAttempted(outcome):
            return (
                name: .calculationAttempted,
                parameters: [.outcome: outcome.rawValue]
            )
        case .historyOpened:
            return (name: .historyOpened, parameters: nil)
        case .historyEntryReused:
            return (name: .historyEntryReused, parameters: nil)
        case .resultExportStarted:
            return (name: .resultExportStarted, parameters: nil)
        }
    }
}

// MARK: - Constants

private extension String {
    static let calculationAttempted = "calculation_attempted"
    static let historyEntryReused = "history_entry_reused"
    static let historyOpened = "history_opened"
    static let outcome = "outcome"
    static let resultExportStarted = "result_export_started"
}
