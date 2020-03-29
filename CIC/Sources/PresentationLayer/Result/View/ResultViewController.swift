//
//  ResultViewController.swift
//  CIC
//
//  Created by Богдан Костюченко on 31/01/2020.
//  Copyright © 2020 Bogdan Kostyuchenko. All rights reserved.
//

import RxSwift
import UIKit

final class ResultViewController: UIViewController {

    // MARK: - Subviews
    private let navigationView = UIView().with {
        $0.backgroundColor = UIColor.background
    }
    private let titleLabel = UILabel().with {
        $0.text = "Детализация".localized
        $0.font = .boldSystemFont(ofSize: 20)
        $0.textColor = .main
    }
    private lazy var closeButton = UIButton(type: .system).with {
        $0.setImage(UIImage(named: "Close"), for: .normal)
        $0.backgroundColor = UIColor.grey.withAlphaComponent(0.3)
        $0.layer.cornerRadius = closeButtonLength / 2
        $0.clipsToBounds = true
        $0.tintColor = .white
    }
    private lazy var tableView = UITableView(frame: .zero, style: .grouped).with {
        $0.dataSource = self
        $0.delegate = self
        $0.estimatedRowHeight = 60
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .background
    }

    // MARK: - Protocol properties
    private let output: ResultViewOutput

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let closeButtonLength: CGFloat = 24

    // MARK: - Observable properties
    private var viewModels = [ResultDataSet]() {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Init
    init(output: ResultViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Binding
    private func bindObservables() {
        closeButton.rx.tap.asObservable()
            .subscribe(onNext: { [unowned self] in self.output.didPressCloseButton() })
            .disposed(by: disposeBag)
    }

    // MARK: Life cycle
    override func loadView() {
        view = UIView()
        addSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        bindObservables()
        output.viewDidLoad()
    }

    // MARK: - Layout
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        layout()
    }

    private func layout() {
        let navigationViewHeight: CGFloat = 50

        navigationView.pin
            .horizontally()
            .height(navigationViewHeight)
            .top(view.pin.safeArea.top)

        closeButton.pin
            .size(closeButtonLength)
            .topRight(Margin.x(4))

        titleLabel.pin
            .sizeToFit()
            .center()

        tableView.pin
            .horizontally()
            .below(of: navigationView)
            .bottom()
    }

    // MARK: - Private methods
    private func addSubviews() {
        view.addSubviews([
            tableView,
            navigationView,
        ])
        navigationView.addSubviews([
            closeButton,
            titleLabel,
        ])
    }

    private func configure() {
        view.backgroundColor = .background
    }

}

// MARK: - ResultViewInput
extension ResultViewController: ResultViewInput {

    func setup(_ viewModels: [ResultDataSet]) {
        self.viewModels = viewModels
    }

}

// MARK: - UITableViewDataSource
extension ResultViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels[section].cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModels[indexPath.section].cells[indexPath.row] {
        case .graphic(let models):
            let cell = tableView.cell(at: indexPath, for: GraphicTableCell.self)
            cell.setup(with: models)
            return cell

        case .period(let model):
            let cell = tableView.cell(at: indexPath, for: CapitalByPeriodTableCell.self)
            cell.setup(with: model)
            return cell
        }
    }

}

extension ResultViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch viewModels[section].section {
        case .commonHeader(let text):
            let headerView = HeaderView()
            headerView.setup(with: text)
            return headerView
        case .emptyHeader:
            return nil
        }
    }

}
