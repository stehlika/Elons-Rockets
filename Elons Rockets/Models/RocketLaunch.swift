//
//  RocketLaunch.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 25/10/2022.
//

import Foundation

public struct RocketLaunch: Decodable {
    let crew: [Crew]
    let details: String?
    let failures: [Failure]?
    let dateUnix: TimeInterval
    let flightNumber: Int
    let id: String
    let launchpad: String
    let links: Links
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
             links,
             name,
             rocketId = "rocket",
             success
    }

    struct Crew: Decodable {
        let crewId: String
        let role: String

        enum CodingKeys: String, CodingKey {
            case crewId = "crew", role
        }
    }

    struct Failure: Decodable {
        let altitude: Float?
        let reason: String
        let time: Float
    }

    struct Links: Decodable {
        let patch: Patch
        let flickr: Flickr
        let wikipedia: String?
        let webcast: String?
        let article: String?

        struct Patch: Decodable {
            let small: String?
        }
    }

    struct Flickr: Decodable {
        let original: [String]?
    }
}
