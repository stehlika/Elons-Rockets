//
//  LaunchesListViewModel.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 31/10/2022.
//

import Foundation

public enum LaunchesListProgressType {
    case showLoader
    case reloadTable
    case showFailureAlert(String)
}

public enum LaunchesOrderType: String {
    case date
    case name
    case launchNumber
}

public typealias LaunchesListProgressClosure = (LaunchesListProgressType) -> Void

public protocol LaunchesListViewModelType {
    var apiService: ApiService { get }
    var launches: [RocketLaunch] { get set }
    var filteredLaunches: [RocketLaunch] { get set }
    var progressHandler: LaunchesListProgressClosure? { get set }
    var orderLaunchesBy: LaunchesOrderType { get set }
    var orderLaunchesKey: String { get }

    func getAllLaunches()
    func orderLaunches(_ launches: [RocketLaunch]) -> [RocketLaunch]
}

public extension LaunchesListViewModelType {
    mutating func reorderLaunches(by newOrder: LaunchesOrderType) {
        orderLaunchesBy = newOrder
        UserDefaults.standard.set(orderLaunchesBy.rawValue, forKey: orderLaunchesKey)
        launches = orderLaunches(launches)
        progressHandler?(.reloadTable)
    }

    mutating func filteredLaunches(by searchText: String) {
        filteredLaunches = launches.filter {
            $0.name.lowercased().contains(searchText)
        }
        progressHandler?(.reloadTable)
    }

    func orderLaunches(_ launches: [RocketLaunch]) -> [RocketLaunch] {
        switch orderLaunchesBy {
            case .name:
                return launches.sorted(by: {$0.name.lowercased() < $1.name.lowercased() })
            case .launchNumber:
                return launches.sorted(by: {$0.flightNumber > $1.flightNumber })
            case .date:
                return launches.sorted(by: {$0.dateUnix > $1.dateUnix })
        }
    }
}



public final class LaunchesListViewModel: LaunchesListViewModelType {

    public let apiService: ApiService
    public var launches: [RocketLaunch] = []
    public var filteredLaunches: [RocketLaunch] = []
    public var orderLaunchesBy: LaunchesOrderType
    public let orderLaunchesKey = "orderLaunchesKey"

    public var progressHandler: LaunchesListProgressClosure?

    init(apiService: ApiService) {
        self.apiService = apiService

        let orderLaunchesString = UserDefaults.standard.string(forKey: orderLaunchesKey) ?? "date"
        orderLaunchesBy = LaunchesOrderType(rawValue: orderLaunchesString) ?? .date
    }

    public func getAllLaunches() {
        Task {
            do {
                progressHandler?(.showLoader)
                let unOrderedlaunches = try await apiService.loadRocketLaunches()
                launches = orderLaunches(unOrderedlaunches)
                progressHandler?(.reloadTable)
            } catch {
                print("Something went wrong during loading rockets: \(error)")
                progressHandler?(.showFailureAlert(error.localizedDescription))
            }
        }
    }
}
