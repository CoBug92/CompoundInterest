//
//  ResultViewController.swift
//  CIC
//
//  Created by Богдан Костюченко on 31/01/2020.
//  Copyright © 2020 Bogdan Kostyuchenko. All rights reserved.
//

import UIKit

final class ResultViewController: UIViewController {

    // MARK: - Subviews
    private let navigationView = UIView().with {
        $0.backgroundColor = UIColor.grey.withAlphaComponent(0.3)
    }
    private lazy var closeButton = UIButton(type: .system).with {
        $0.setImage(UIImage(named: "Close"), for: .normal)
        $0.backgroundColor = UIColor.grey.withAlphaComponent(0.3)
        $0.layer.cornerRadius = closeButtonLength / 2
        $0.clipsToBounds = true
        $0.tintColor = .main
    }
    private lazy var tableView = UITableView().with {
        $0.dataSource = self
        $0.estimatedRowHeight = 60
        $0.keyboardDismissMode = .onDrag
        $0.showsVerticalScrollIndicator = false
    }

    // MARK: - Protocol properties
    private let output: ResultViewOutput

    // MARK: - Properties
    private let closeButtonLength: CGFloat = 24

    // MARK: - Observable properties
    private var viewModels = [ResulCellType]() {
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
            let navigationViewHeight: CGFloat = 50

            navigationView.pin
                .horizontally()
                .height(navigationViewHeight)

            closeButton.pin
                .size(closeButtonLength)
                .topRight(Margin.x(4))

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
            navigationView.addSubview(closeButton)
        }

        private func configure() {
            title = "Сложный процент"
            view.backgroundColor = .background
            navigationController?.navigationBar.prefersLargeTitles = true
        }

    }

// MARK: - ResultViewInput
extension ResultViewController: ResultViewInput {

    func setup(_ viewModels: [ResulCellType]) {
        self.viewModels = viewModels
    }

}

extension ResultViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModels[indexPath.row] {
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
