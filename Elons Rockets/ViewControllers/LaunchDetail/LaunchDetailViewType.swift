//
//  LaunchDetailViewType.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 01/11/2022.
//

import UIKit

public typealias LaunchDetailViewControllerType = LaunchDetailViewType & UITableViewController // TODO: Think if this is necessary

public protocol LaunchDetailViewType: UITableViewController, BaseTableViewProtocol {

    var viewModel: LaunchDetailViewModelType { get set }

    var mainImageView: UIImageView { get set }
    var loadingAlertView: UIAlertController { get set }
}

public extension LaunchDetailViewType where Self: UITableViewController {

    func viewTypeDidLoad() {
        configureViews()
        setupTableView()
        setupViewModel()
    }

    func numberOfSections() -> Int {
        viewModel.tableData.count
    }

    func numberOfRows(in section: Int) -> Int {
        viewModel.tableData[safe: section]?.rows.count ?? 0
    }

    func cellForRow(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = viewModel.tableData[safe: indexPath.section]?.rows[safe: indexPath.row] else {
            return UITableViewCell()
        }

        if indexPath.section == 1 {
            cell.selectionStyle = .gray
        } else {
            cell.selectionStyle = .none
        }
        return cell
    }

    func headerFor(section: Int) -> String? {
        viewModel.tableData[safe: section]?.sectionHeaderTitle
    }

    func didSelectRow(at indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            guard let link = viewModel.linksData[safe: indexPath.row]?.1, let url = URL(string: link) else { return }
            UIApplication.shared.open(url)
        }
        return
    }

    var loadingIndicator: UIActivityIndicatorView {
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()
        return loadingIndicator
    }
}

private extension LaunchDetailViewType {
    func configureViews() {
        navigationItem.largeTitleDisplayMode = .never
        if isDarkModeActive {
            navigationController?.navigationBar.tintColor  = .white
        } else {
            navigationController?.navigationBar.tintColor  = .black
        }

        loadingAlertView.view.addSubview(loadingIndicator)
    }

    func setupTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 320
        tableView.separatorStyle = .none
        mainImageView.translatesAutoresizingMaskIntoConstraints = false

        tableView.tableHeaderView = mainImageView
        guard let tableHeaderView = tableView.tableHeaderView else {
            return
        }
        NSLayoutConstraint.activate([
            mainImageView.heightAnchor.constraint(equalToConstant: 280),
            mainImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            mainImageView.centerXAnchor.constraint(equalTo: tableHeaderView.centerXAnchor),
            mainImageView.centerYAnchor.constraint(equalTo: tableHeaderView.centerYAnchor)
        ])
    }

    func setupViewModel() {
        viewModel.getLaunchDetails()
        viewModel.progressHandler = { [weak self] type in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch type {
                    case .success:
                        self.updateTableHeader()
                        self.tableView.reloadData()
                        self.dismiss(animated: false)
                    case .loading:
                        self.present(self.loadingAlertView, animated: false)
                    case .failure(let errorMessage):
                        self.loadingAlertView.dismiss(animated: true) {
                            // It needs to wait for one view to close down to show another
                            self.showErrorMessage(errorMessage)
                        }
                }
            }
        }
    }

    func updateTableHeader() {
        if viewModel.mainImage != nil {
            mainImageView.isHidden = false
            mainImageView.image = viewModel.mainImage
        } else {
            mainImageView.image = nil
            mainImageView.isHidden = true
            tableView.tableHeaderView = UIView()
        }
    }

    func showErrorMessage(_ message: String) {
        let alert = UIAlertController(title: "Something went wrong", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
            self.viewModel.getLaunchDetails()
        })
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
}
