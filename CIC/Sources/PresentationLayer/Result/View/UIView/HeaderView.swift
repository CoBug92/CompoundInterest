//
//  HeaderView.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 2/17/20.
//  Copyright © 2020 Home. All rights reserved.
//

import PinLayout

class HeaderView: UIView {

    // MARK: - Subviews
    private let titleLabel = UILabel().with {
        $0.font = .boldSystemFont(ofSize: 20)
        $0.textColor = .main
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
        addSubviews()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        pin.width(size.width)
        layout()
        return frame.size
    }

    private func layout() {
        titleLabel.pin
            .sizeToFit()
            .top(Margin.x(6))
            .left(Margin.x(4))

        pin.height(titleLabel.frame.maxY + Margin.x(6))
    }

    // MARK: - Public methods
    func setup(with text: String) {
        titleLabel.text = text
    }

    // MARK: - Private methods
    private func addSubviews() {
        addSubview(titleLabel)
    }

    private func configure() {
        backgroundColor = .background
    }

}
