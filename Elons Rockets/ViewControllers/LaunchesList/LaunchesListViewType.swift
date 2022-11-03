//
//  LaunchesListViewType.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 31/10/2022.
//

import UIKit

public typealias LaunchesListViewControllerType = LaunchesListViewType & UITableViewController & UISearchResultsUpdating

public protocol LaunchesListViewType: UITableViewController, BaseTableViewProtocol {

    func orderLaunchesButtonAction()

    var loadingAlertView: UIAlertController { get set }
    var orderingBarIcon: UIImage? { get }
    var searchController: UISearchController { get set }
    var viewModel: LaunchesListViewModelType { get set }

}

public extension LaunchesListViewType where Self: UITableViewController {
    func viewTypeDidLoad() {
        configureViews()
        setupTableView()
        setupViewModel()

        self.navigationItem.backButtonTitle = ""
    }

    func numberOfSections() -> Int {
        1
    }

    func numberOfRows(in section: Int) -> Int {
        if isFiltering {
            return viewModel.filteredLaunches.count
        }
        return viewModel.launches.count
    }

    func cellForRow(at indexPath: IndexPath) -> UITableViewCell {
        let launchesListCell = LaunchesListCell()

        var launch: RocketLaunch?
        if isFiltering {
            launch = viewModel.filteredLaunches[safe: indexPath.row]
        } else {
            launch = viewModel.launches[safe: indexPath.row]
        }

        guard let launch = launch else {
            return UITableViewCell()
        }

        launchesListCell.applyViewModel(
            viewModel: LaunchesListCellViewModel(rocketLaunch: launch)
        )
        return launchesListCell
    }

    func didSelectRow(at indexPath: IndexPath) {
        // TODO: MUST Rework this - for now  just for accessing detail view
        tableView.deselectRow(at: indexPath, animated: true)

        var launch: RocketLaunch?
        if isFiltering {
            launch = viewModel.filteredLaunches[safe: indexPath.row]
        } else {
            launch = viewModel.launches[safe: indexPath.row]
        }
        guard let launch = launch else {
            return
        }
        let detailViewModel = LaunchDetailViewModel(apiService: viewModel.apiService, rocketLaunch: launch)
        let detailViewController = LaunchDetailViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    var orderingBarIcon: UIImage? {
        UIImage(systemName: "arrow.up.arrow.down.circle")
    }

    func orderLaunchesButtonAction() {
        let actionSheet = UIAlertController(title: "Order launches by", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Launch number", style: .default, handler: { _ in
            self.viewModel.reorderLaunches(by: .launchNumber)
        }))
        actionSheet.addAction(UIAlertAction(title: "Date", style: .default, handler: { _ in
            self.viewModel.reorderLaunches(by: .date)
        }))
        actionSheet.addAction(UIAlertAction(title: "Name", style: .default, handler: { _ in
            self.viewModel.reorderLaunches(by: .name)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(actionSheet, animated: true)
    }

    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    func filterContentForSearchText(_ searchText: String, launchName: String? = nil) {
        viewModel.filteredLaunches(by: searchText.lowercased())
    }

    var loadingIndicator: UIActivityIndicatorView {
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()
        return loadingIndicator
    }
}

private extension LaunchesListViewType {
    func configureViews() {
        title = "Rocket launches"
        navigationController?.navigationBar.prefersLargeTitles = true

        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search rocket launches"
        navigationItem.searchController = searchController
        definesPresentationContext = true
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
                        self.loadingAlertView.dismiss(animated: true)
                        self.tableView.reloadData()
                    case .failure(let erroMessage):
                        self.loadingAlertView.dismiss(animated: true)
                        self.showErrorMessage(erroMessage)
                    case .loading:
                        self.present(self.loadingAlertView, animated: true)
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
