//
//  FlightDetailHeaderView.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 01/11/2022.
//

import UIKit

class LaunchDetailHeaderView: UITableViewCell {

    let patchImageView = UIImageView()
    let launchNameLabel = UILabel()
    let launchDateLabel = UILabel()
    let detailsLabel = UILabel()
    let separatorLine = UIView()
    let detailsStackView = UIStackView()
    let mainStackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        [
            patchImageView,
            launchNameLabel,
            launchDateLabel,
            detailsLabel,
            separatorLine,
            detailsStackView,
            mainStackView,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        detailsStackView.addArrangedSubview(launchNameLabel)
        detailsStackView.addArrangedSubview(launchDateLabel)
        mainStackView.addArrangedSubview(patchImageView)
        mainStackView.addArrangedSubview(detailsStackView)

        addSubview(mainStackView)
        addSubview(separatorLine)
        addSubview(detailsLabel)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: LayoutSpacing.xs),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LayoutSpacing.xs),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -LayoutSpacing.xs),
            mainStackView.bottomAnchor.constraint(equalTo: separatorLine.topAnchor, constant: -LayoutSpacing.xs),

            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LayoutSpacing.xs),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -LayoutSpacing.xs),
            separatorLine.heightAnchor.constraint(equalToConstant: 1.0),

            patchImageView.heightAnchor.constraint(equalToConstant: 64.0),
            patchImageView.widthAnchor.constraint(equalToConstant: 64.0),

            detailsLabel.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: LayoutSpacing.xs),
            detailsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LayoutSpacing.xs),
            detailsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -LayoutSpacing.xs),
            detailsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -LayoutSpacing.xs),
        ])
    }

    func configureViews() {
        separatorLine.backgroundColor = .gray

        launchNameLabel.font = .preferredFont(forTextStyle: .headline)

        launchDateLabel.font = .preferredFont(forTextStyle: .subheadline)

        detailsLabel.numberOfLines = 0
        detailsLabel.textAlignment = .center
        detailsLabel.font = .preferredFont(forTextStyle: .footnote)

        detailsStackView.axis = .vertical
        detailsStackView.spacing = 4.0
        detailsStackView.distribution = .equalSpacing

        mainStackView.distribution = .fill
        mainStackView.spacing = LayoutSpacing.xs
        mainStackView.axis = .horizontal
        mainStackView.alignment = .center

        patchImageView.contentMode = .scaleAspectFit
        patchImageView.tintColor = UIColor(named: "Tint")
    }

    func applyViewModel(launch: RocketLaunch, patchImage: UIImage?) {
        patchImageView.image = patchImage
        launchNameLabel.text = launch.name
        launchDateLabel.text = launch.date.formatted()
        detailsLabel.text = launch.details ?? "Currently there are no details about this mission"
    }
}
