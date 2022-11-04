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
    let type: String
    let height: Height
    let diameter: Diameter
    let mass: Mass

    var measurementSystem: Locale.MeasurementSystem {
        Locale.current.measurementSystem
    }

    var massCalculated: String {
        if measurementSystem == .metric {
            return "\(mass.kg) kg"
        } else {
            return "\(Float(mass.kg) * kgsToLbsRatio) lb"
        }
    }

    var diameterCalculated: String {
        if measurementSystem == .metric {
            return "\(diameter.meters) m"
        } else {
            return "\(Float(diameter.meters) * metersToFeetRatio) ft"
        }
    }

    var heightCalculated: String {
        if measurementSystem == .metric {
            return "\(height.meters) m"
        } else {
            return "\(Float(height.meters) * metersToFeetRatio) ft"
        }
    }

    enum CodingKeys: String, CodingKey {
        case active,
             costPerLaunch = "cost_per_launch",
             description,
             diameter,
             height,
             mass,
             name,
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
