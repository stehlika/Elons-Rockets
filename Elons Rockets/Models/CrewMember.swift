//
//  CrewMember.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 26/10/2022.
//

import Foundation

public struct CrewMember: Codable {
    let agency: String
    let id: String
    let imageUrl: String
    let launches: [String]
    let name: String
    let status: String
    let wikiLink: String

    enum CodingKeys: String, CodingKey {
        case agency,
             id,
             imageUrl = "image",
             launches,
             name,
             status,
             wikiLink = "wikipedia"
    }
}
