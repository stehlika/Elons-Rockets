//
//  SpaceXAPIServiceError.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 31/10/2022.
//

import Foundation

enum SpaceXAPIServiceError: Error {
    case invalidURL, imageDataCorupted, noInternet
}

extension SpaceXAPIServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .noInternet: return "Please connect to the internet and try again"
            case .imageDataCorupted: return "Could not download image"
            case .invalidURL: return "Internal app error. Please try again later"
        }
    }
}
