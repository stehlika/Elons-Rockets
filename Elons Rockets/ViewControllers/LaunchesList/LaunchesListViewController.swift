//
//  ViewController.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 31/10/2022.
//

import UIKit

class LaunchesListViewController: LaunchesListViewControllerType {

    var loadingAlertView: UIAlertController
    var searchController: UISearchController

    var viewModel: LaunchesListViewModelType

    public init(viewModel: LaunchesListViewModelType) {
        self.viewModel = viewModel
        self.searchController = UISearchController(searchResultsController: nil)
        self.loadingAlertView = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        super.init(nibName: nil, bundle: nil)

        self.searchController.searchResultsUpdater = self
        loadingAlertView.view.addSubview(loadingIndicator)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewTypeDidLoad()

        let sortingBarButton = UIBarButtonItem(title: "", image: orderingBarIcon, target: self, action: #selector(orderLaunchesButtonTapped))
        sortingBarButton.tintColor = .black
        navigationItem.rightBarButtonItem = sortingBarButton
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRows(in: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellForRow(at: indexPath)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        numberOfSections()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow(at: indexPath)
    }

    @objc func orderLaunchesButtonTapped() {
        orderLaunchesButtonAction()
    }

    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
