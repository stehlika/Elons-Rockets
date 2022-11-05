//
//  AppCoordinator.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 03/11/2022.
//

import UIKit

public enum AppNavigationSection {
    case detail(rocketLaunch: RocketLaunch)
}

public typealias AppNavigationHandler = ((AppNavigationSection) -> Void)

public protocol AppCoordinatorType: AnyObject {

    var launchDetailViewController: LaunchDetailViewControllerType { get set }
    var launchesListViewController: LaunchesListViewControllerType { get }

    var apiService: ApiService { get }
    var rootViewController: UINavigationController { get set }
    func navigate(to section: AppNavigationSection)
}

public extension AppCoordinatorType {
    func navigate(to section: AppNavigationSection) {
        switch section {
            case .detail(let rocketLaunch):
                let viewController = launchDetailViewController
                viewController.viewModel.rocketLaunch = rocketLaunch
                rootViewController.pushViewController(viewController, animated: true)
        }
    }

    var launchesListViewController: LaunchesListViewControllerType {
        let viewModel: LaunchesListViewModelType = LaunchesListViewModel(apiService: apiService)
        let viewController: LaunchesListViewControllerType = LaunchesListViewController(viewModel: viewModel)
//        viewController.navigationHandler = { [weak self] section in
//            guard let self = self else {
//                fatalError("Self is nil ") // TODO: MUST TUTO to pada lebo self je nil
//            }
//            self.navigate(to: section)
//        }
        return viewController
    }
}

public final class AppCoordinator: AppCoordinatorType {

    public var rootViewController: UINavigationController
    public let apiService: ApiService

    public lazy var launchDetailViewController: LaunchDetailViewControllerType = {
        let viewModel: LaunchDetailViewModelType = LaunchDetailViewModel(apiService: apiService)
        let viewController: LaunchDetailViewControllerType = LaunchDetailViewController(viewModel: viewModel)
        // TODO: Add navigation handler
        return viewController
    }()

    public init() {
        self.apiService = SpaceXAPIService()
        self.rootViewController = UINavigationController()
        self.rootViewController = UINavigationController(rootViewController: launchesListViewController)
    }
}
