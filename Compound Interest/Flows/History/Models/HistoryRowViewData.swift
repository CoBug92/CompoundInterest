import Foundation

struct HistoryRowViewData: Identifiable {
    let id: UUID
    let date: String
    let initialInvestment: String
    let contribution: String
    let duration: String
    let annualInterestRate: String
}
