//
//  RocketLaunch.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 25/10/2022.
//

import Foundation

public struct RocketLaunch: Codable {
    let crew: [Crew]?
    let details: String?
    let failures: [Failure]?
    let fireDateUnix: Date?
    let flightNumber: Int
    let id: String
    let launchpad: String
    let rocketId: String
    let success: Bool?

    enum CodingKeys: String, CodingKey {
        case crew,
             details,
             failures,
             fireDateUnix = "static_fire_date_unix",
             flightNumber = "flight_number",
             id,
             launchpad,
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
