//
//  FlightNumberView.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 31/10/2022.
//

import UIKit

class FlightNumberView: UIView {

    let flightNumberLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureViews() {
        backgroundColor = UIColor(named: "FlyghtNumberBackground")
        flightNumberLabel.textColor = UIColor(named: "FlyghtNumberLabel")
        layer.masksToBounds = true
        layer.cornerRadius = 10

        flightNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(flightNumberLabel)

        NSLayoutConstraint.activate([
            flightNumberLabel.topAnchor.constraint(equalTo: topAnchor, constant: LayoutSpacing.xxxs),
            flightNumberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LayoutSpacing.xs),
            flightNumberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -LayoutSpacing.xs),
            flightNumberLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -LayoutSpacing.xxxs)
        ])
    }
}
