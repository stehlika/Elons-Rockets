//
//  LaunchDetailViewController.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 01/11/2022.
//

import UIKit

class LaunchDetailViewController: LaunchDetailViewControllerType {

    var loadingAlertView: UIAlertController
    var mainImageView = UIImageView()

    var viewModel: LaunchDetailViewModelType

    public init(viewModel: LaunchDetailViewModelType) {
        self.viewModel = viewModel
        self.loadingAlertView = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewTypeDidLoad()
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

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        headerFor(section: section)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow(at: indexPath)
    }
}
