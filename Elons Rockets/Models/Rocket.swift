//
//  Rocket.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 26/10/2022.
//

import Foundation

public struct Rocket: Decodable {
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

    var measurementFormatter: MeasurementFormatter {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        return formatter
    }

    var massCalculated: String {
        if measurementSystem == .metric {
            return "\(mass.kg) kg"
        } else {
            let measurementValue = Measurement(value: mass.kg, unit: UnitMass.kilograms)
            let convertedValue = measurementValue.converted(to: UnitMass.pounds)
            return measurementFormatter.string(from: convertedValue)
        }
    }

    var diameterCalculated: String {
        if measurementSystem == .metric {
            return "\(diameter.meters) m"
        } else {
            return convertMetersToFeet(diameter.meters)
        }
    }

    var heightCalculated: String {
        if measurementSystem == .metric {
            return "\(height.meters) m"
        } else {
            return convertMetersToFeet(height.meters)
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

    struct Height: Decodable {
        let meters: Double // Other measurement system can be calculated
    }

    struct Diameter: Decodable {
        let meters: Double // Other measurement system can be calculated
    }

    struct Mass: Decodable {
        let kg: Double // Other measurement system can be calculated
    }

    func convertMetersToFeet(_ valueInMeters: Double) -> String {
        let measuredValue = Measurement(value: valueInMeters, unit: UnitLength.meters)
        let convertedValue = measuredValue.converted(to: UnitLength.feet)
        return measurementFormatter.string(from: convertedValue)
    }
}
