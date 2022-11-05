//
//  LaunchDetailViewModel.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 01/11/2022.
//

import UIKit

public enum LaunchDetailProgressType {
    case loading
    case success
    case failure(String)
}

public typealias LaunchDetailProgressClosure = (LaunchDetailProgressType) -> Void

public protocol LaunchDetailViewModelType {

    var progressHandler: LaunchDetailProgressClosure? { get set }

    var apiService: ApiService { get }
    var rocketLaunch: RocketLaunch? { get set }

    var crewMembers: [CrewMember] { get set }
    var rocket: Rocket? { get set }
    var tableData: [TableSectionViewModel] { get }

    var mainImage: UIImage? { get set }
    var patchImage: UIImage { get set }
    func getLaunchDetails()
}

public extension LaunchDetailViewModelType {

    var launchDetailMainInfo: UITableViewCell {
        let cell = LaunchDetailHeaderView()
        guard let rocketLaunch = rocketLaunch else { return UITableViewCell() }
        cell.applyViewModel(launch: rocketLaunch, patchImage: patchImage)
        return cell
    }

    var rocketSectionRows: [ValueRow] {
        guard let rocket = rocket else {
            return [ValueRow(key: "There are no details", value: "")]
        }
        var rows: [ValueRow] = []
        rows.append(ValueRow(key: "Name", value: rocket.name))
        rows.append(ValueRow(key: "Type", value: rocket.type))
        rows.append(ValueRow(key: "Cost per launch", value: String(format: "%.2f", rocket.costPerLaunch) + " $"))
        rows.append(ValueRow(key: "Diameter", value: "\(rocket.diameterCalculated)"))
        rows.append(ValueRow(key: "Height", value: "\(rocket.heightCalculated)"))
        rows.append(ValueRow(key: "Mass", value: "\(rocket.massCalculated)"))

        return rows
    }

    var linksSectionRows: [ValueRow] {
        var rows: [ValueRow] = []
        for links in linksData {
            rows.append(ValueRow(key: links.0, value: ""))
        }
        return rows
    }

    // If you want to add another social link add it here
    var linksData: [(String, String)] {
        guard let rocketLaunch = rocketLaunch else { return [] }
        var links: [(String, String)] = []

        if let wikiLink = rocketLaunch.links.wikipedia {
            links.append(("Wikipedia", wikiLink))
        }

        if let webcastLink = rocketLaunch.links.webcast {
            links.append(("YouTube", webcastLink))
        }

        if let articleLink = rocketLaunch.links.article {
            links.append(("SpaceX article", articleLink))
        }
        return links
    }

    var tableData: [TableSectionViewModel] {
        var rows: [TableSectionViewModel] = []

        rows.append(TableSectionViewModel(rows: [launchDetailMainInfo], sectionHeaderTitle: "Main information"))
        if !linksSectionRows.isEmpty {
            rows.append(TableSectionViewModel(rows: linksSectionRows.map { $0.tableViewCell } , sectionHeaderTitle: "Links"))
        }
        rows.append(TableSectionViewModel(rows: rocketSectionRows.map { $0.tableViewCell }, sectionHeaderTitle: "Rocket"))
        rows.append(TableSectionViewModel(rows: crewMembersSectionRows.map({ $0.tableViewCell }), sectionHeaderTitle: "Flight crew"))
        return rows
    }

    var crewMembersSectionRows: [ValueRow] {
        guard !crewMembers.isEmpty else {
            return [ValueRow(key: "This launch is crewless", value: "")]
        }

        var crewRows: [ValueRow] = []
        for crewMember in crewMembers {
            crewRows.append(ValueRow(key: crewMember.name, value: crewMember.agency))
        }

        return crewRows
    }
}

class LaunchDetailViewModel: LaunchDetailViewModelType {
    var progressHandler: LaunchDetailProgressClosure?

    var crewMembers: [CrewMember] = []

    var rocket: Rocket?

    var patchImage: UIImage = UIImage(named: "rocket")!
    var mainImage: UIImage?

    var apiService: ApiService
    var rocketLaunch: RocketLaunch?

    init(apiService: ApiService) {
        self.apiService = apiService
    }

    func getLaunchDetails() {
        Task {
            do {
                guard let rocketLaunch = rocketLaunch else {
                    return
                }
                progressHandler?(.loading)
                if !rocketLaunch.crew.isEmpty {
                    for crew in rocketLaunch.crew {
                        let crewMember = try await apiService.getCrewMemeber(by: crew.crewId)
                        crewMembers.append(crewMember)
                    }
                }

                if let mainImageUrl = rocketLaunch.links.flickr.original?.randomElement() {
                    mainImage = try await apiService.getImage(by: mainImageUrl)
                }

                if let imageUrl = rocketLaunch.links.patch.small {
                    patchImage = try await apiService.getImage(by: imageUrl)
                }

                rocket = try await apiService.getRocket(by: rocketLaunch.rocketId)
                progressHandler?(.success)
            } catch {
                print("Something went wrong: \(error)")
                progressHandler?(.failure(error.localizedDescription))
            }
        }
    }
}
