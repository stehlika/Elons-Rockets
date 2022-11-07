//
//  SpaceXAPIService.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 25/10/2022.
//

import UIKit
import Network

public protocol ApiService {
    func loadRocketLaunches() async throws -> [RocketLaunch]
    func getRocket(by id: String) async throws -> Rocket
    func getCrewMemeber(by id: String) async throws -> CrewMember
    func getImage(by url: String) async throws -> UIImage
    func getLaunchpad(by id: String) async throws -> Launchpad
}

struct SpaceXAPIService: ApiService {

    let decoder = JSONDecoder()
    let monitor = NWPathMonitor()
    let session = URLSession.shared

    let baseUrl = "https://api.spacexdata.com/"
    let apiVersion5 = "v5/"
    let apiVersion4 = "v4/"

    @MainActor
    func loadRocketLaunches() async throws -> [RocketLaunch] {
        let postfix = "launches"
        let data = try await getData(baseUrl + apiVersion5 + postfix)
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return try decoder.decode([RocketLaunch].self, from: data)
    }

    @MainActor
    func getRocket(by id: String) async throws -> Rocket {
        let postfix = "rockets/"
        let data = try await getData(baseUrl + apiVersion4 + postfix + id)
        return try decoder.decode(Rocket.self, from: data)
    }

    @MainActor
    func getCrewMemeber(by id: String) async throws -> CrewMember {
        let postfix = "crew/"
        let data = try await getData(baseUrl + apiVersion4 + postfix + id)
        return try decoder.decode(CrewMember.self, from: data)
    }

    @MainActor
    func getImage(by url: String) async throws -> UIImage {
        let data = try await getData(url)
        guard let image = UIImage(data: data) else {
            throw SpaceXAPIServiceError.imageDataCorupted
        }
        return image
    }

    @MainActor
    func getLaunchpad(by id: String) async throws -> Launchpad {
        let postfix = "launchpads/"
        let data = try await getData(baseUrl + apiVersion4 + postfix + id)
        return try decoder.decode(Launchpad.self, from: data)
    }

    @MainActor
    func getData(_ stringUrl: String) async throws -> Data {
        guard let url = URL(string: stringUrl) else {
            throw SpaceXAPIServiceError.invalidURL
        }
        try checkInternetConnection()
        let (data, _) = try await session.data(from: url)
        return data
    }

    func checkInternetConnection() throws {
        // iPhone simulator has issues with NWPathMonitor
        #if targetEnvironment(simulator)
            return
        #else
            if monitor.currentPath.status != .satisfied {
                throw SpaceXAPIServiceError.noInternet
            }
        #endif
    }
}
