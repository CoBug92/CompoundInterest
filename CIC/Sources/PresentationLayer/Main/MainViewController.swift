//
//  MainViewModel.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 16.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Combine
import EasyTipView
import SnapKit
import UIKit

private extension CGFloat {
    static let estimatedRowHeight: CGFloat = 60
    static let headerHeight: CGFloat = 60
}

final class MainViewController: UIViewController {

    // MARK: - Typealias
    typealias DataSource = UITableViewDiffableDataSource<MainViewModel.SectionType, MainViewModel.CellType>

    // MARK: - Subviews
    private lazy var tableView = UITableView(frame: .zero, style: .grouped).with {
        $0.delegate = self
        $0.estimatedRowHeight = .estimatedRowHeight
        $0.keyboardDismissMode = .onDrag
        $0.showsVerticalScrollIndicator = false
        $0.register(InitialValueTableCell.self)
        $0.register(CalculateTableCell.self)
        $0.register(ResultTableCell.self)
    }
    private var currentTip: EasyTipView?

    // MARK: - Properties
    private let viewModel: MainViewModel
    private var cancellables = Set<AnyCancellable>()
    private lazy var dataSource = makeDataSource()

    // MARK: - Init
    init(with viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        addSubviews()
        bindObservable()
        addSubviewsLayout()
        viewModel.viewDidLoad.send()
    }

    // MARK: - Private methods
    private func configure() {
        navigationItem.title = Localizations.Main.title
        view.backgroundColor = Colors.Background.primary.color
    }

    private func addSubviews() {
        view.addSubview(tableView)
    }

    private func bindObservable() {
        viewModel.$dataSourceSnapshot
            .map { [weak self] in self?.dataSource.apply($0, animatingDifferences: false) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                if let section = self?.dataSource.snapshot().indexOfSection(.keyIndicators) {
                    self?.tableView.scrollToRow(at: IndexPath(row: 0, section: section), at: .top, animated: true)
                }
            }
            .store(in: &cancellables)
    }

    private func addSubviewsLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func openResultDetail() {
        guard let capitalByPeriod = viewModel.result?.capitalByPeriod else {
            return
        }
        let viewController = ResultViewController(with: ResultDetailViewModel(with: capitalByPeriod))
        present(viewController, animated: true)
    }

    private func showTip(with text: String, on view: UIView) {
        closeTip()
        let easyTipView = EasyTipView(text: text, preferences: EasyTipView.globalPreferences, delegate: nil)
        currentTip = easyTipView
        easyTipView.show(forView: view)
    }

    private func closeTip() {
        currentTip?.dismiss()
    }

    private func makeDataSource() -> DataSource {
        return DataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, cellType -> UITableViewCell? in
                switch cellType {
                case .initialDeposit(let model):
                    let cell = tableView.dequeueCell(InitialValueTableCell.self, for: indexPath)
                    cell.setup(with: model)
                    cell.didChangeValue
                        .subscribe(self.viewModel.initialDeposit)
                        .store(in: &cell.reuseCancellables)
                    cell.didPressInfoButton
                        .sink { [weak self] in self?.showTip(with: model.hint, on: cell) }
                        .store(in: &cell.reuseCancellables)
                    return cell
                case .numberOfPeriods(let model):
                    let cell = tableView.dequeueCell(InitialValueTableCell.self, for: indexPath)
                    cell.setup(with: model)
                    cell.didChangeValue
                        .map { Int(truncating: NSDecimalNumber(decimal: $0)) }
                        .subscribe(self.viewModel.numberOfPeriods)
                        .store(in: &cell.reuseCancellables)
                    cell.didPressInfoButton
                        .sink { [weak self] in self?.showTip(with: model.hint, on: cell) }
                        .store(in: &cell.reuseCancellables)
                    return cell
                case .profitability(let model):
                    let cell = tableView.dequeueCell(InitialValueTableCell.self, for: indexPath)
                    cell.setup(with: model)
                    cell.didChangeValue
                        .subscribe(self.viewModel.interestRate)
                        .store(in: &cell.reuseCancellables)
                    cell.didPressInfoButton
                        .sink { [weak self] in self?.showTip(with: model.hint, on: cell) }
                        .store(in: &cell.reuseCancellables)
                    return cell
                case .monthlyIncrease(let model):
                    let cell = tableView.dequeueCell(InitialValueTableCell.self, for: indexPath)
                    cell.setup(with: model)
                    cell.didChangeValue
                        .subscribe(self.viewModel.monthlyIncrease)
                        .store(in: &cell.reuseCancellables)
                    cell.didPressInfoButton
                        .sink { [weak self] in self?.showTip(with: model.hint, on: cell) }
                        .store(in: &cell.reuseCancellables)
                    return cell
                case .calculate:
                    let cell = tableView.dequeueCell(CalculateTableCell.self, for: indexPath)
                    cell.didPressCalculateButton
                        .subscribe(self.viewModel.didPressCalculate)
                        .store(in: &cell.reuseCancellables)
                    return cell
                case .result(let model):
                    let cell = tableView.dequeueCell(ResultTableCell.self, for: indexPath)
                    cell.setup(with: model)
                    cell.didPressGraphicButton
                        .sink { [weak self] in self?.openResultDetail() }
                        .store(in: &cell.reuseCancellables)
                    return cell
                }
            }
        )
    }

}

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionType = dataSource.snapshot().sectionIdentifiers[section]
        switch sectionType {
        case .keyIndicators:
            return tableView.dequeueHeaderFooterView(LabledHeaderView.self).with {
                $0.setup(with: sectionType.header)
            }
        case .initialValue:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionType = dataSource.snapshot().sectionIdentifiers[section]
        switch sectionType {
        case .keyIndicators:
            return .headerHeight
        case .initialValue:
            return .zero
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if currentTip != nil {
            closeTip()
        }
    }

}
