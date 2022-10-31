//
//  LaunchesListCellViewModel.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 31/10/2022.
//

import Foundation

struct LaunchesListCellViewModel {
    private let rocketLaunch: RocketLaunch

    init(rocketLaunch: RocketLaunch) {
        self.rocketLaunch = rocketLaunch
    }

    var launchName: String {
        rocketLaunch.name
    }

    var crewText: String {
        if rocketLaunch.crew.count == 0 {
            return "Crewless launch"
        } else {
            return "Crew: \(rocketLaunch.crew.count) people"
        }
    }

    var statusText: String {
        if Date.now.timeIntervalSince1970 < rocketLaunch.dateUnix {
            return "Upcoming flight"
        } else {
            return rocketLaunch.success ?? false ? "Succesful flight" : "Failed flight"
        }
    }

    var dateText: String {
        return rocketLaunch.date.formatted()
    }

    var flightNumber: String {
        "Fl. #\(rocketLaunch.flightNumber)"
    }
}
