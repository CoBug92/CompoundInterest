//
//  CalculateTableCell.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 14/01/2020.
//  Copyright © 2020 Home. All rights reserved.
//

import PinLayout
import RxCocoa
import RxSwift

class CalculateTableCell: UITableViewCell {

    // MARK: - Subviews
    private let calculateButton = GradientButton().with {
        $0.setTitle("Рассчитать".localized, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        $0.contentEdgeInsets = UIEdgeInsets(verticalInset: Margin.x(4))
        $0.setCorner(radius: 12)
    }

    // MARK: - Properties
    var reuseBag = DisposeBag()

    // MARK: - Computed properties
    var didPressCalculateButton: Observable<Void> {
        calculateButton.animate {}
        return calculateButton.rx.tap.asObservable()
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        layout()
        return contentView.frame.size
    }

    private func layout() {
        calculateButton.pin
            .horizontally(Margin.x(4))
            .sizeToFit(.width)
            .top(Margin.x(6))

        contentView.pin.height(calculateButton.frame.maxY + Margin.x(6))
    }

    // MARK: - Private methods
    private func addSubviews() {
        contentView.addSubview(calculateButton)
    }

}
