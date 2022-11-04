//
//  FlightDetailHeaderView.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 01/11/2022.
//

import UIKit

class LaunchDetailHeaderView: UITableViewCell {

    let wraperView = UIView()
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
            wraperView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        detailsStackView.addArrangedSubview(launchNameLabel)
        detailsStackView.addArrangedSubview(launchDateLabel)
        mainStackView.addArrangedSubview(patchImageView)
        mainStackView.addArrangedSubview(detailsStackView)

        wraperView.addSubview(mainStackView)
        wraperView.addSubview(separatorLine)
        wraperView.addSubview(detailsLabel)

        addSubview(wraperView)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: wraperView.topAnchor, constant: 8.0),
            mainStackView.leadingAnchor.constraint(equalTo: wraperView.leadingAnchor, constant: 8.0),
            mainStackView.trailingAnchor.constraint(equalTo: wraperView.trailingAnchor, constant: -8.0),
            mainStackView.bottomAnchor.constraint(equalTo: separatorLine.topAnchor, constant: -8.0),

            separatorLine.leadingAnchor.constraint(equalTo: wraperView.leadingAnchor, constant: 8.0),
            separatorLine.trailingAnchor.constraint(equalTo: wraperView.trailingAnchor, constant: 8.0),
            separatorLine.heightAnchor.constraint(equalToConstant: 1.0),

            patchImageView.heightAnchor.constraint(equalToConstant: 64.0),
            patchImageView.widthAnchor.constraint(equalToConstant: 64.0),

            detailsLabel.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 8.0),
            detailsLabel.leadingAnchor.constraint(equalTo: wraperView.leadingAnchor, constant: 8.0),
            detailsLabel.trailingAnchor.constraint(equalTo: wraperView.trailingAnchor, constant: -8.0),
            detailsLabel.bottomAnchor.constraint(equalTo: wraperView.bottomAnchor, constant: -8.0),

            wraperView.topAnchor.constraint(equalTo: topAnchor),
            wraperView.leadingAnchor.constraint(equalTo: leadingAnchor),
            wraperView.trailingAnchor.constraint(equalTo: trailingAnchor),
            wraperView.bottomAnchor.constraint(equalTo: bottomAnchor) // TODO: delete wraper
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
        mainStackView.spacing = 8.0
        mainStackView.axis = .horizontal
        mainStackView.alignment = .center

        patchImageView.contentMode = .scaleAspectFit

        if isDarkModeActive {
            patchImageView.tintColor = .white
        } else {
            patchImageView.tintColor = .black
        }
    }

    func applyViewModel(launch: RocketLaunch, patchImage: UIImage?) {
        patchImageView.image = patchImage
        launchNameLabel.text = launch.name
        launchDateLabel.text = launch.date.formatted()
        detailsLabel.text = launch.details ?? "Currently there are no details about this mission"
    }
}
