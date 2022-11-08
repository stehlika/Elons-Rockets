//
//  AppCoordinator.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 03/11/2022.
//

import UIKit

public class MainCoordinator: Coordinator {
    public var navigationController: UINavigationController
    let apiService: ApiService

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.apiService = SpaceXAPIService()
    }

    public func start() {
        let launchesListViewModel = LaunchesListViewModel(apiService: apiService)
        let launchesListViewController = LaunchesListViewController(viewModel: launchesListViewModel)
        launchesListViewController.coordinator = self
        navigationController.pushViewController(launchesListViewController, animated: true)
    }

    public func showLaunchDetail(rocketLaunch: RocketLaunch) {
        let launchDetailViewModel = LaunchDetailViewModel(apiService: apiService, rocketLaunch: rocketLaunch)
        let launchDetailViewController = LaunchDetailViewController(viewModel: launchDetailViewModel)
        navigationController.pushViewController(launchDetailViewController, animated: true)
    }
}
