//
//  LaunchesListViewType.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 31/10/2022.
//

import UIKit

public typealias LaunchesListViewControllerType = LaunchesListViewType & UITableViewController

public protocol LaunchesListViewType: UITableViewController {
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func cellForRow(at indexPath: IndexPath) -> UITableViewCell
    func didSelectRow(at indexPath: IndexPath)
    func viewTypeDidLoad()

    var viewModel: LaunchesListViewModelType { get set }
}

public extension LaunchesListViewType where Self: UITableViewController {
    func viewTypeDidLoad() {
        configureViews()
        setupTableView()
        setupViewModel()
    }

    func numberOfSections() -> Int {
        1 // TODO: Add sections by months
    }

    func numberOfRows(in section: Int) -> Int {
        viewModel.launches.count
    }

    func cellForRow(at indexPath: IndexPath) -> UITableViewCell {
        let launchesListCell = LaunchesListCell()
        guard let launch = viewModel.launches[safe: indexPath.row] else {
            return UITableViewCell()
        }
        launchesListCell.applyViewModel(
            viewModel: LaunchesListCellViewModel(rocketLaunch: launch)
        )
        return launchesListCell
    }

    func didSelectRow(at indexPath: IndexPath) {
        // TODO: Add navigation to next screen.
        print("Selected: \(indexPath.row)")
    }
}

private extension LaunchesListViewType {
    func configureViews() {
        title = "Rocket launches"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 132
        tableView.contentInset = .zero
        tableView.separatorInset = .zero
    }

    func setupViewModel() {
        viewModel.getAllLaunches()
        self.viewModel.progressHandler = { [weak self] type in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch type {
                    case .success:
                        self.tableView.reloadData()
                    case .failure(let erroMessage):
                        self.showErrorMessage(erroMessage)
                    case .loading:
                        self.showLoader()
                }
            }
        }
    }

    func showErrorMessage(_ message: String) {
        let alert = UIAlertController(title: "Something went wrong", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
