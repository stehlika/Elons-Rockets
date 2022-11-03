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
    // TODO: Think about offline state
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

    func getAllLaunches()
}

public extension LaunchesListViewModelType {
    mutating func reorderLaunches(by newOrder: LaunchesOrderType) {
        orderLaunchesBy = newOrder
        UserDefaults.standard.set(orderLaunchesBy.rawValue, forKey: "orderLaunchesKey")
        switch orderLaunchesBy {
            case .name:
                launches = launches.sorted(by: {$0.name.lowercased() < $1.name.lowercased() })
            case .launchNumber:
                launches = launches.sorted(by: {$0.flightNumber > $1.flightNumber })
            case .date:
                launches = launches.sorted(by: {$0.dateUnix > $1.dateUnix })
        }
        progressHandler?(.reloadTable)
    }

    mutating func filteredLaunches(by searchText: String) {
        filteredLaunches = launches.filter {
            $0.name.lowercased().contains(searchText)
        }
        progressHandler?(.reloadTable)
    }
}



public final class LaunchesListViewModel: LaunchesListViewModelType {

    public let apiService: ApiService
    public var launches: [RocketLaunch] = []
    public var filteredLaunches: [RocketLaunch] = []
    public var orderLaunchesBy: LaunchesOrderType

    public var progressHandler: LaunchesListProgressClosure?

    init(apiService: ApiService) {
        self.apiService = apiService

        let orderLaunchesString = UserDefaults.standard.string(forKey: "orderLaunchesKey") ?? "date"
        orderLaunchesBy = LaunchesOrderType(rawValue: orderLaunchesString) ?? .date
    }

    public func getAllLaunches() {
        Task {
            do {
                progressHandler?(.showLoader)
                let unOrderedlaunches = try await apiService.loadRocketLaunches()
                switch orderLaunchesBy {
                    case .name:
                        launches = unOrderedlaunches.sorted(by: {$0.name.lowercased() < $1.name.lowercased() })
                    case .launchNumber:
                        launches = unOrderedlaunches.sorted(by: {$0.flightNumber > $1.flightNumber })
                    case .date:
                        launches = unOrderedlaunches.sorted(by: {$0.dateUnix > $1.dateUnix })
                }
                progressHandler?(.reloadTable)
            } catch {
                print("Something went wrong during loading rockets: \(error)")
                progressHandler?(.showFailureAlert(error.localizedDescription))
            }
        }
    }
}
