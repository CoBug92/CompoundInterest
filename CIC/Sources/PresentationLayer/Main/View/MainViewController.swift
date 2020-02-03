//
//  MainViewController.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 14/01/2020.
//  Copyright © 2020 Bogdan Kostyuchenko. All rights reserved.
//

import RxSwift
import PinLayout

final class MainViewController: UIViewController {

    // MARK: - Subviews
    private lazy var tableView = UITableView().with {
        $0.dataSource = self
        $0.estimatedRowHeight = 60
        $0.keyboardDismissMode = .onDrag
        $0.showsVerticalScrollIndicator = false
    }

    // MARK: - Protocol properties
    private let output: MainViewOutput

    // MARK: - Properties
    private let disposeBag = DisposeBag()

    // MARK: - Observable properties
    private var viewModels = [MainCellType]() {
        didSet {
            tableView.reloadData()
            if case .result = viewModels.last {
                tableView.scrollToRow(at: IndexPath(row: viewModels.count - 1, section: 0),
                                      at: .top,
                                      animated: true)
            }
        }
    }

    // MARK: - Init
    init(output: MainViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life cycle
    override func loadView() {
        view = UIView()
        addSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        output.viewDidLoad()
    }

    // MARK: - Layout
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        layout()
    }

    private func layout() {
        tableView.pin.all()
    }

    // MARK: - Private methods
    private func addSubviews() {
        view.addSubview(tableView)
    }

    private func configure() {
        title = "Сложный процент"
        view.backgroundColor = .background
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}

// MARK: - MainViewInput
extension MainViewController: MainViewInput {

    func showData(_ viewModels: [MainCellType]) {
        self.viewModels = viewModels
    }

}

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModels[indexPath.row] {
        case .depositTerm:
            let cell = tableView.cell(at: indexPath, for: DepositTermTableCell.self)
            cell.didChangeDepositTerm
                .bind(onNext: { [unowned self] in self.output.didChangeDepositTerm($0) })
                .disposed(by: cell.reuseBag)
            return cell

        case .depositSize:
            let cell = tableView.cell(at: indexPath, for: DepositSizeTextField.self)
            cell.didChangeDepositSize
                .bind(onNext: { [unowned self] in self.output.didChangeDepositSize($0) })
                .disposed(by: cell.reuseBag)
            return cell

        case .interestRate:
            let cell = tableView.cell(at: indexPath, for: InterestRateTableCell.self)
            cell.didChangeInterestRate
                .bind(onNext: { [unowned self] in self.output.didChangeInterestRate($0) })
                .disposed(by: cell.reuseBag)
            return cell

        case .monthlyIncrease:
            let cell = tableView.cell(at: indexPath, for: MonthlyIncreaseTableCell.self)
            cell.didChangeMonthlyIncrease
                .bind(onNext: { [unowned self] in self.output.didChangeMonthlyIncrease($0) })
                .disposed(by: cell.reuseBag)
            return cell

        case .calculateButton:
            let cell = tableView.cell(at: indexPath, for: CalculateTableCell.self)
            cell.didPressCalculateButton
                .bind(onNext: { [unowned self] in self.output.didPressCalculateButton() })
                .disposed(by: cell.reuseBag)
            return cell

        case .result(let model):
            let cell = tableView.cell(at: indexPath, for: ResultTableCell.self)
            cell.setup(with: model)
            cell.didPressGraphicButton
                .subscribe(onNext: { [unowned self] in self.output.didPressGraphicButton() })
                .disposed(by: disposeBag)
            return cell
        }
    }

}
