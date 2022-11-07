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
        let format = NSLocalizedString("LaunchesListCell.CrewPeopleText", comment: "")
        return String(format: format, rocketLaunch.crew.count)
    }

    var statusText: String {
        if Date.now.timeIntervalSince1970 < rocketLaunch.dateUnix {
            return "Upcoming flight"
        } else if rocketLaunch.success == true {
            return "Succesful flight"
        } else {
            return "Failed flight"
        }
    }

    var dateText: String {
        rocketLaunch.date.formatted()
    }

    var flightNumber: String {
        "Fl. #\(rocketLaunch.flightNumber)"
    }
}
