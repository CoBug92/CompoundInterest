//
//  CalculatorTableCell.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 14/01/2020.
//  Copyright © 2020 Home. All rights reserved.
//

import EasyTipView
import PinLayout
import RxSwift

class CalculatorTableCell: UITableViewCell {

    // MARK: - Subviews
    private let depositSizeView = CalculatorView().with {
        $0.titleLabelText = "Начальный депозит"
    }
    private let depositTermView = CalculatorView().with {
        $0.titleLabelText = "Кол-во периодов (месяцев)"
        $0.shouldValidate = true
    }
    private let interestRateView = CalculatorView().with {
        $0.titleLabelText = "Доходность за 1 период"
        $0.keyboardType = .decimalPad
    }
    private let monthlyIncreaseView = CalculatorView().with {
        $0.titleLabelText = "Довложения каждый месяц"
    }

    // MARK: - Properties
    var reuseBag = DisposeBag()
    private var currentTip: EasyTipView?

    // MARK: - Computed properties
    var didChangeDepositSize: Observable<Double> {
        return depositSizeView.didChangeValue
    }
    var didChangeDepositTerm: Observable<Double> {
        return depositTermView.didChangeValue
    }
    var didChangeInterestRate: Observable<Double> {
        return interestRateView.didChangeValue
    }
    var didChangeMonthlyIncrease: Observable<Double> {
        return monthlyIncreaseView.didChangeValue
    }
    var didChangeDepositSizeInfo: Observable<InfoType> {
        return depositSizeView.didPressInfoButton.map { .depositSize }
    }
    var didChangeDepositTermInfo: Observable<InfoType> {
        return depositTermView.didPressInfoButton.map { .depositTerm }
    }
    var didChangeInterestRateInfo: Observable<InfoType> {
        return interestRateView.didPressInfoButton.map { .interestRate }
    }
    var didChangeMonthlyIncreaseInfo: Observable<InfoType> {
        return monthlyIncreaseView.didPressInfoButton.map { .monthlyIncrease }
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews()
        bindObservable()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Binding
    func bindObservable() {
        Observable.merge(didChangeDepositSizeInfo,
                         didChangeDepositTermInfo,
                         didChangeInterestRateInfo,
                         didChangeMonthlyIncreaseInfo)
            .subscribe(onNext: { [unowned self] in self.showTip($0) })
            .disposed(by: reuseBag)

        Observable.merge(didChangeDepositSize,
                         didChangeDepositTerm,
                         didChangeInterestRate,
                         didChangeMonthlyIncrease)
            .subscribe(onNext: { [unowned self] _ in self.currentTip?.dismiss() })
            .disposed(by: reuseBag)
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
        depositSizeView.pin
            .horizontally()
            .sizeToFit(.width)

        depositTermView.pin
            .horizontally()
            .sizeToFit(.width)
            .below(of: depositSizeView)

        interestRateView.pin
            .horizontally()
            .sizeToFit(.width)
            .below(of: depositTermView)

        monthlyIncreaseView.pin
            .horizontally()
            .sizeToFit(.width)
            .below(of: interestRateView)

        contentView.pin.height(monthlyIncreaseView.frame.maxY)
    }

    // MARK: - Private methods
    private func addSubviews() {
        contentView.addSubviews([
            depositSizeView,
            depositTermView,
            interestRateView,
            monthlyIncreaseView,
        ])
    }

    private func showTip(_ infoType: InfoType) {
        currentTip?.dismiss()
        switch infoType {
        case .depositSize:
            let view = EasyTipView(text: TipsConstant.depositeSize, preferences: EasyTipView.globalPreferences, delegate: nil)
            view.show(forView: depositSizeView)
            currentTip = view
        case .depositTerm:
            let view = EasyTipView(text: TipsConstant.depositTerm, preferences: EasyTipView.globalPreferences, delegate: nil)
            view.show(forView: depositTermView)
            currentTip = view
        case .interestRate:
            let view = EasyTipView(text: TipsConstant.interestRate, preferences: EasyTipView.globalPreferences, delegate: nil)
            view.show(forView: interestRateView)
            currentTip = view
        case .monthlyIncrease:
            let view = EasyTipView(text: TipsConstant.monthlyIncrease, preferences: EasyTipView.globalPreferences, delegate: nil)
            view.show(forView: monthlyIncreaseView)
            currentTip = view
        }
    }

}
