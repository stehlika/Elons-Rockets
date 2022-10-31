//
//  SpaceXAPIService.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 25/10/2022.
//

import Foundation


public protocol ApiService {
    func loadRocketLaunches() async throws -> [RocketLaunch]
    func getRocket(by id: String) async throws -> Rocket
    func getCrewMemeber(by id: String) async throws -> CrewMember
}

struct SpaceXAPIService: ApiService {

    var session = URLSession.shared

    var baseUrl = "https://api.spacexdata.com/"
    var apiVersion5 = "v5/"
    var apiVersion4 = "v4/"

    @MainActor
    func loadRocketLaunches() async throws -> [RocketLaunch] {
        let postfix = "launches"
        guard let url = URL(string: baseUrl + apiVersion5 + postfix) else {
            throw SpaceXAPIServiceError.invalidURL
        }
        let (data, _) = try await session.data(from: url)
        print("Data: \(data)")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return try decoder.decode([RocketLaunch].self, from: data)
    }

    @MainActor
    func getRocket(by id: String) async throws -> Rocket {
        let postfix = "rockets/"
        guard let url = URL(string: baseUrl + apiVersion4 + postfix + id) else {
            throw SpaceXAPIServiceError.invalidURL
        }
        let (data, _) = try await session.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode(Rocket.self, from: data)
    }

    @MainActor
    func getCrewMemeber(by id: String) async throws -> CrewMember {
        let postfix = "crew/"
        guard let url = URL(string: baseUrl + apiVersion4 + postfix + id) else {
            throw SpaceXAPIServiceError.invalidURL
        }

        let (data, _) = try await session.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode(CrewMember.self, from: data)
    }
}
