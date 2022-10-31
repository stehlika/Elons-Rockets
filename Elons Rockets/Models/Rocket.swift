//
//  Rocket.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 26/10/2022.
//

import Foundation

public struct Rocket: Codable {
    let active: Bool
    let costPerLaunch: Float
    let description: String
    let name: String
    let reusable: Bool?
    let type: String

    enum CodingKeys: String, CodingKey {
        case active,
             costPerLaunch = "cost_per_launch",
             description,
             name,
             reusable,
             type
    }

    struct Height: Codable {
        let meters: Double // Other measurement system can be calculated
    }

    struct Diameter: Codable {
        let meters: Double // Other measurement system can be calculated
    }

    struct Mass: Codable {
        let kg: Double // Other measurement system can be calculated
    }
}
