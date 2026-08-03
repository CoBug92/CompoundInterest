import Foundation
import SwiftData

@Model
final class HistoryModel {

    // MARK: - Properties

    var id: UUID
    var calculatedAt: Date
    var sequenceNumber: Int64
    var initialInvestment: String
    var monthlyContribution: String?
    var contributionFrequency: String
    var investmentDuration: String
    var investmentDurationUnit: String
    var annualInterestRate: String

    // MARK: - Init/Deinit

    init(
        id: UUID = UUID(),
        calculatedAt: Date,
        sequenceNumber: Int64,
        input: CalculationInput
    ) {
        self.id = id
        self.calculatedAt = calculatedAt
        self.sequenceNumber = sequenceNumber
        initialInvestment = input.initialInvestment.persistedString
        monthlyContribution = input.monthlyContribution?.persistedString
        contributionFrequency = input.contributionFrequency.storageCode
        investmentDuration = input.investmentDuration.persistedString
        investmentDurationUnit = input.investmentDurationUnit.storageCode
        annualInterestRate = input.annualInterestRate.persistedString
    }

    // MARK: - Public methods

    func makeEntry(
        calendar: Calendar = .history
    ) -> HistoryEntry? {
        guard
            let initialInvestment = Decimal(persistedString: initialInvestment),
            let contributionFrequency = ContributionFrequency(storageCode: contributionFrequency),
            let investmentDuration = Decimal(persistedString: investmentDuration),
            let investmentDurationUnit = InvestmentDurationUnit(storageCode: investmentDurationUnit),
            let annualInterestRate = Decimal(persistedString: annualInterestRate)
        else {
            return nil
        }

        let parsedMonthlyContribution: Decimal?
        if let monthlyContribution {
            guard let value = Decimal(persistedString: monthlyContribution) else {
                return nil
            }

            parsedMonthlyContribution = value
        } else {
            parsedMonthlyContribution = nil
        }

        return HistoryEntry(
            id: id,
            calculatedAt: calculatedAt,
            calculatedDay: HistoryDay(date: calculatedAt, calendar: calendar),
            input: CalculationInput(
                initialInvestment: initialInvestment,
                monthlyContribution: parsedMonthlyContribution,
                contributionFrequency: contributionFrequency,
                investmentDuration: investmentDuration,
                investmentDurationUnit: investmentDurationUnit,
                annualInterestRate: annualInterestRate
            )
        )
    }
}

private extension Decimal {

    var persistedString: String {
        NSDecimalNumber(decimal: self).stringValue
    }

    init?(persistedString: String) {
        self.init(string: persistedString, locale: Locale(identifier: "en_US_POSIX"))
    }
}
