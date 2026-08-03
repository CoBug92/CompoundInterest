import CoreTransferable
import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct MonthlyCapitalPDFDocument: Transferable {

    // MARK: - Typealias

    private typealias MonthlyCapital = KeyIndicatorResult.MonthlyCapital

    // MARK: - Properties

    private let monthlyCapital: [MonthlyCapital]
    private let formatter = DecimalTextFormatter()

    // MARK: - Computed properties

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .pdf) { document in
            document.pdfData
        }
    }

    private var pdfData: Data {
        let renderer = UIGraphicsPDFRenderer(bounds: .pageBounds)

        return renderer.pdfData { context in
            var yPosition = CGFloat.pageMargin
            context.beginPage()
            drawTitle(at: &yPosition)
            drawTableHeader(at: &yPosition)

            for item in monthlyCapital {
                if yPosition + .rowHeight > .pageBottomInset {
                    context.beginPage()
                    yPosition = .pageMargin
                    drawTableHeader(at: &yPosition)
                }

                drawRow(item, at: &yPosition)
            }
        }
    }

    // MARK: - Init/Deinit

    init(monthlyCapital: [KeyIndicatorResult.MonthlyCapital]) {
        self.monthlyCapital = monthlyCapital
    }

    // MARK: - Private methods

    private func drawTitle(at yPosition: inout CGFloat) {
        drawText(
            Localizations.Export.MonthlyIncome.title,
            in: CGRect(
                x: .pageMargin,
                y: yPosition,
                width: .contentWidth,
                height: .titleHeight
            ),
            attributes: .titleAttributes
        )
        yPosition += .titleHeight + .sectionSpacing
    }

    private func drawTableHeader(at yPosition: inout CGFloat) {
        drawTableBackground(at: yPosition, color: .tableHeaderBackground)
        drawText(
            Localizations.Chart.Month.axis,
            in: monthColumnRect(yPosition: yPosition),
            attributes: .headerAttributes
        )
        drawText(
            Localizations.Chart.Capital.axis,
            in: capitalColumnRect(yPosition: yPosition),
            attributes: .headerAttributes
        )
        yPosition += .rowHeight
    }

    private func drawRow(
        _ item: MonthlyCapital,
        at yPosition: inout CGFloat
    ) {
        drawTableBackground(at: yPosition, color: .tableRowBackground)
        drawText(
            String(item.month),
            in: monthColumnRect(yPosition: yPosition),
            attributes: .rowAttributes
        )
        drawText(
            formatter.string(from: item.capital),
            in: capitalColumnRect(yPosition: yPosition),
            attributes: .rowAttributes
        )
        yPosition += .rowHeight
    }

    private func drawTableBackground(
        at yPosition: CGFloat,
        color: UIColor
    ) {
        color.setFill()
        UIBezierPath(rect: CGRect(
            x: .pageMargin,
            y: yPosition,
            width: .contentWidth,
            height: .rowHeight
        )).fill()
    }

    private func drawText(
        _ text: String,
        in rect: CGRect,
        attributes: [NSAttributedString.Key: Any]
    ) {
        (text as NSString).draw(
            with: rect,
            options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine],
            attributes: attributes,
            context: nil
        )
    }

    private func monthColumnRect(yPosition: CGFloat) -> CGRect {
        CGRect(
            x: .pageMargin + .cellPadding,
            y: yPosition + .cellVerticalPadding,
            width: .monthColumnWidth,
            height: .rowTextHeight
        )
    }

    private func capitalColumnRect(yPosition: CGFloat) -> CGRect {
        CGRect(
            x: .pageMargin + .monthColumnWidth + .cellPadding,
            y: yPosition + .cellVerticalPadding,
            width: .capitalColumnWidth,
            height: .rowTextHeight
        )
    }
}

// MARK: - Constants

private extension CGFloat {
    static let pageWidth: CGFloat = 595
    static let pageHeight: CGFloat = 842
    static let pageMargin: CGFloat = 32
    static let rowHeight: CGFloat = 32
    static let rowTextHeight: CGFloat = 20
    static let titleHeight: CGFloat = 30
    static let sectionSpacing: CGFloat = 16
    static let cellPadding: CGFloat = 10
    static let cellVerticalPadding: CGFloat = 7
    static let monthColumnWidth: CGFloat = 120

    static var contentWidth: CGFloat {
        pageWidth - pageMargin * 2
    }

    static var capitalColumnWidth: CGFloat {
        contentWidth - monthColumnWidth - cellPadding * 2
    }

    static var pageBottomInset: CGFloat {
        pageHeight - pageMargin
    }
}

private extension CGRect {
    static let pageBounds = CGRect(
        x: .zero,
        y: .zero,
        width: .pageWidth,
        height: .pageHeight
    )
}

private extension UIColor {
    static let tableHeaderBackground = UIColor.secondarySystemBackground
    static let tableRowBackground = UIColor.systemBackground
}

private extension Dictionary where Key == NSAttributedString.Key, Value == Any {
    static var titleAttributes: [NSAttributedString.Key: Any] {
        [
            .font: UIFont.boldSystemFont(ofSize: 22),
            .foregroundColor: UIColor.label
        ]
    }

    static var headerAttributes: [NSAttributedString.Key: Any] {
        [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .foregroundColor: UIColor.label
        ]
    }

    static var rowAttributes: [NSAttributedString.Key: Any] {
        [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.label
        ]
    }
}
