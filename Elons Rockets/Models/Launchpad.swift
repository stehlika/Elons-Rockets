//
//  Launchpad.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 05/11/2022.
//

import Foundation

public struct Launchpad: Decodable {

    let name: String
    let fullName: String
    let details: String
    let latitude: Double // TODO: Think what to do with this
    let longitude: Double // TODO: Think what to do with this
    let launchAttempts: Int
    let launchSuccesses: Int
    let locality: String
    let region: String

    enum CodingKeys: String, CodingKey {
        case name,
             fullName = "full_name",
             details,
             latitude,
             longitude,
             launchAttempts = "launch_attempts",
             launchSuccesses = "launch_successes",
             locality,
             region
    }
}
