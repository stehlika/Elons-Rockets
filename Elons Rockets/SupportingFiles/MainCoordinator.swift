//
//  AppCoordinator.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 03/11/2022.
//

import UIKit

public class MainCoordinator: Coordinator {
    public var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start() {
        let launchesListViewModel = LaunchesListViewModel(apiService: SpaceXAPIService.shared)
        let launchesListViewController = LaunchesListViewController(viewModel: launchesListViewModel)
        launchesListViewController.coordinator = self
        navigationController.pushViewController(launchesListViewController, animated: true)
    }

    public func showLaunchDetail(rocketLaunch: RocketLaunch) {
        let launchDetailViewModel = LaunchDetailViewModel(apiService: SpaceXAPIService.shared, rocketLaunch: rocketLaunch)
        let launchDetailViewController = LaunchDetailViewController(viewModel: launchDetailViewModel)
        navigationController.pushViewController(launchDetailViewController, animated: true)
    }
}
