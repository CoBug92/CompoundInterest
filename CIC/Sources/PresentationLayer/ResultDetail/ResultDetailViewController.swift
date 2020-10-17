//
//  ResultDetailViewController.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 17.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Combine
import CombineCocoa
import UIKit

private enum Constants {
    static let closeButtonLength: CGFloat = 24
    static let closeButtonCornerRadius: CGFloat = closeButtonLength / 2
}

private extension CGFloat {
    static let headerHeight: CGFloat = 60
    static let footerHeight: CGFloat = 20
    static let tableHeaderViewHeight: CGFloat = 30
    static let estimatedRowHeight: CGFloat = 60
}

final class ResultViewController: UIViewController {

    // MARK: - Subviews
    private let navigationView = UIView().with {
        $0.backgroundColor = Colors.Background.modalSecondary.color
    }
    private lazy var closeButton = UIButton(type: .system).with {
        $0.setImage(Images.close.image, for: .normal)
        $0.backgroundColor = Colors.Theme.black.color.withAlphaComponent(0.2)
        $0.setCorner(radius: Constants.closeButtonCornerRadius)
        $0.tintColor = Colors.Theme.white.color
    }
    private lazy var tableView = UITableView(frame: .zero, style: .grouped).with {
        $0.dataSource = self
        $0.delegate = self
        $0.estimatedRowHeight = .estimatedRowHeight
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = Colors.Background.modalPrimary.color
        $0.register(GraphicTableCell.self)
        $0.register(CapitalByPeriodTableCell.self)
        let headerView = UIView()
        headerView.backgroundColor = Colors.Background.modalPrimary.color
        headerView.frame.size.height = .tableHeaderViewHeight
        $0.tableHeaderView = headerView
    }

    // MARK: - Properties
    private let viewModel: ResultDetailViewModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Observable properties
    private var viewModels = [ResultDetailViewModel.DataSource]() {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Init
    init(with viewModel: ResultDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Binding
    private func bindObservables() {
        closeButton.tapPublisher
            .sink { [weak self] in self?.dismiss(animated: true) }
            .store(in: &cancellables)

        viewModel.$dataSource
            .assignUnretained(to: \.viewModels, on: self)
            .store(in: &cancellables)
    }

    // MARK: Life cycle
    override func loadView() {
        view = UIView()
        addSubviews()
        bindObservables()
        addSubviewsLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        viewModel.viewDidLoad.send()
    }

    // MARK: - Private methods
    private func configure() {
        view.backgroundColor = Colors.Background.modalPrimary.color
    }

    private func addSubviews() {
        view.addSubviews([
            tableView,
            navigationView,
        ])
        navigationView.addSubview(closeButton)
    }

    private func addSubviewsLayout() {
        navigationView.snp.makeConstraints {
            $0.trailing.leading.top.equalToSuperview()
        }

        closeButton.snp.makeConstraints {
            $0.size.equalTo(Constants.closeButtonLength)
            $0.top.bottom.equalToSuperview().inset(Margin.x3)
            $0.right.equalToSuperview().inset(Margin.x4)
        }

        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(navigationView.snp.bottom)
            $0.bottom.equalToSuperview()
        }
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
            let cell = tableView.dequeueCell(GraphicTableCell.self, for: indexPath)
            cell.setup(with: models)
            return cell

        case .period(let model):
            let cell = tableView.dequeueCell(CapitalByPeriodTableCell.self, for: indexPath)
            cell.setup(with: model)
            return cell
        }
    }

}

extension ResultViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueHeaderFooterView(LabledHeaderView.self).with {
            $0.setup(with: viewModels[section].section.header)
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .headerHeight
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .footerHeight
    }

}
