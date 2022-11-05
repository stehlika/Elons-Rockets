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
        if isDarkModeActive {
            backgroundColor = .white
            flightNumberLabel.textColor = .black
        } else {
            backgroundColor = .black
            flightNumberLabel.textColor = .white
        }

        layer.masksToBounds = true
        layer.cornerRadius = 10

        flightNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(flightNumberLabel)

        NSLayoutConstraint.activate([
            flightNumberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2.0),
            flightNumberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
            flightNumberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0),
            flightNumberLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2.0)
        ])
    }
}
