//
//  LaunchesListViewModel.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 31/10/2022.
//

import Foundation

public enum LaunchesListProgressType {
    case loading
    case success
    case failure(String)
    // TODO: Think about offline state
}

public typealias LaunchesListProgressClosure = (LaunchesListProgressType) -> Void

public protocol LaunchesListViewModelType {
    var apiService: ApiService { get }
    var launches: [RocketLaunch] { get set }
    var progressHandler: LaunchesListProgressClosure? { get set }

    func getAllLaunches()
}

public final class LaunchesListViewModel: LaunchesListViewModelType {

    public func getAllLaunches() {
        Task {
            do {
                progressHandler?(.loading)
                launches = try await apiService.loadRocketLaunches()
                launches = launches.sorted(by: {$0.dateUnix > $1.dateUnix }) // TODO: Add user possibility to change this
                progressHandler?(.success)
            } catch {
                print("Something went wrong during loading rockets: \(error)")
                progressHandler?(.failure(error.localizedDescription))
            }
        }
    }

    public let apiService: ApiService
    public var launches: [RocketLaunch] = []
    public var progressHandler: LaunchesListProgressClosure?

    init(apiService: ApiService) {
        self.apiService = apiService
    }
}
