//
//  RocketLaunch.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 25/10/2022.
//

import Foundation

public struct RocketLaunch: Codable {
    let crew: [Crew]
    let details: String?
    let failures: [Failure]?
    let dateUnix: TimeInterval
    let flightNumber: Int
    let id: String
    let launchpad: String
    let name: String
    let rocketId: String
    let success: Bool?

    var date: Date {
        Date(timeIntervalSince1970: dateUnix)
    }

    enum CodingKeys: String, CodingKey {
        case crew,
             details,
             failures,
             dateUnix = "date_unix",
             flightNumber = "flight_number",
             id,
             launchpad,
             name,
             rocketId = "rocket",
             success
    }

    struct Crew: Codable {
        let crewId: String
        let role: String

        enum CodingKeys: String, CodingKey {
            case crewId = "crew", role
        }
    }

    struct Failure: Codable {
        let altitude: Float?
        let reason: String
        let time: Float
    }
}
