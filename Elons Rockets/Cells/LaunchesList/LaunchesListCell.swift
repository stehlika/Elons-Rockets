//
//  LaunchesListCell.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 31/10/2022.
//

import UIKit

class LaunchesListCell: UITableViewCell {

    let launchNameLabel = UILabel()
    let crewAmountLabel = UILabel()
    let launchStatusLabel = UILabel()
    let launchDateLabel = UILabel()
    let flightNumberView = FlightNumberView()

    let detailsStackView = UIStackView()

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applyViewModel(viewModel: LaunchesListCellViewModel) {
        launchNameLabel.text = viewModel.launchName
        crewAmountLabel.text = viewModel.crewText
        launchStatusLabel.text = viewModel.statusText
        launchDateLabel.text = viewModel.dateText
        flightNumberView.flightNumberLabel.text = viewModel.flightNumber
    }
}

private extension LaunchesListCell {

    func configureViews() {
        launchNameLabel.font = .preferredFont(forTextStyle: .headline)
        [
            crewAmountLabel,
            launchStatusLabel,
            launchDateLabel
        ].forEach {
            $0.font = .preferredFont(forTextStyle: .subheadline)
            $0.textColor = .darkGray
        }

        detailsStackView.translatesAutoresizingMaskIntoConstraints = false
        detailsStackView.axis = .vertical
        detailsStackView.alignment = .leading
        detailsStackView.spacing = 8.0
        accessoryType = .disclosureIndicator
    }

    func setupLayout() {
        [
            launchNameLabel,
            crewAmountLabel,
            launchStatusLabel,
            launchDateLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            detailsStackView.addArrangedSubview($0)
        }

        flightNumberView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(detailsStackView)
        contentView.addSubview(flightNumberView)

        NSLayoutConstraint.activate([
            detailsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
            detailsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            detailsStackView.trailingAnchor.constraint(equalTo: flightNumberView.leadingAnchor, constant: -8.0),
            detailsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0),

            flightNumberView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            flightNumberView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
        ])
    }
}
