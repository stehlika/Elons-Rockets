//
//  LaunchDetailViewModel.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 01/11/2022.
//

import UIKit

public enum LaunchDetailProgressType {
    case showLoader
    case reloadData
    case failure(String)
}

public typealias LaunchDetailProgressClosure = (LaunchDetailProgressType) -> Void

public protocol LaunchDetailViewModelType {

    var progressHandler: LaunchDetailProgressClosure? { get set }

    var apiService: ApiService { get }

    var crewMembers: [CrewMember] { get set }
    var launchpad: Launchpad? { get set }
    var rocket: Rocket? { get set }
    var rocketLaunch: RocketLaunch { get set }

    var tableData: [TableSectionViewModel] { get }

    var mainImage: UIImage? { get set }
    var patchImage: UIImage { get set }
    func getLaunchDetails()
}

public extension LaunchDetailViewModelType {

    var tableData: [TableSectionViewModel] {
        var rows: [TableSectionViewModel] = []

        rows.append(TableSectionViewModel(rows: [launchDetailMainInfo], sectionHeaderTitle: "Main information"))
        if !linksSectionRows.isEmpty {
            rows.append(TableSectionViewModel(rows: linksSectionRows , sectionHeaderTitle: "Links"))
        }
        rows.append(TableSectionViewModel(rows: rocketSectionRows, sectionHeaderTitle: "Rocket"))
        rows.append(TableSectionViewModel(rows: crewMembersSectionRows, sectionHeaderTitle: "Flight crew"))
        if !launchpadSectionRows.isEmpty {
            rows.append(TableSectionViewModel(rows: launchpadSectionRows, sectionHeaderTitle: "Launchpad"))
        }
        return rows
    }

    var launchDetailMainInfo: UITableViewCell {
        let headerCell = LaunchDetailHeaderView()
        headerCell.applyViewModel(launch: rocketLaunch, patchImage: patchImage)
        return headerCell
    }

    var rocketSectionRows: [UITableViewCell] {
        guard let rocket = rocket else {
            return [ValueRow(key: "There are no details", value: "").tableViewCell]
        }
        var rows: [ValueRow] = []
        rows.append(ValueRow(key: "Name", value: rocket.name))
        rows.append(ValueRow(key: "Type", value: rocket.type))
        rows.append(ValueRow(key: "Cost per launch", value: String(format: "%.2f", rocket.costPerLaunch) + " $"))
        rows.append(ValueRow(key: "Diameter", value: "\(rocket.diameterCalculated)"))
        rows.append(ValueRow(key: "Height", value: "\(rocket.heightCalculated)"))
        rows.append(ValueRow(key: "Mass", value: "\(rocket.massCalculated)"))
        return rows.map { $0.tableViewCell }
    }

    var linksSectionRows: [UITableViewCell] {
        var rows: [ValueRow] = []
        for links in linksData {
            rows.append(ValueRow(key: links.0, value: ""))
        }
        return rows.map { $0.tableViewCell }
    }

    // If you want to add another social link add it here
    var linksData: [(String, String)] {
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

    var crewMembersSectionRows: [UITableViewCell] {
        guard !crewMembers.isEmpty else {
            return [ValueRow(key: "This launch is crewless", value: "").tableViewCell]
        }

        var crewRows: [ValueRow] = []
        for crewMember in crewMembers {
            crewRows.append(ValueRow(key: crewMember.name, value: crewMember.agency))
        }
        return crewRows.map { $0.tableViewCell }
    }

    var launchpadSectionRows: [UITableViewCell] {
        guard let launchpad = launchpad else { return [] }

        var rows: [ValueRow] = []
        rows.append(ValueRow.init(key: "Name", value: launchpad.name))
        rows.append(ValueRow.init(key: "Full name", value: launchpad.fullName))
        rows.append(ValueRow.init(key: "Locality", value: launchpad.locality))
        rows.append(ValueRow.init(key: "Region", value: launchpad.region))
        rows.append(ValueRow.init(key: "Launch attempts", value: "\(launchpad.launchAttempts)"))
        rows.append(ValueRow.init(key: "Launch succcesses", value: "\(launchpad.launchSuccesses)"))
        rows.append(ValueRow.init(key: "Details", value: launchpad.details))
        return rows.map { $0.tableViewCell }
    }
}

class LaunchDetailViewModel: LaunchDetailViewModelType {
    var progressHandler: LaunchDetailProgressClosure?

    var crewMembers: [CrewMember] = []
    var launchpad: Launchpad?
    var rocket: Rocket?
    var rocketLaunch: RocketLaunch

    var patchImage: UIImage = UIImage(named: "rocket")!
    var mainImage: UIImage?

    var apiService: ApiService


    init(apiService: ApiService, rocketLaunch: RocketLaunch) {
        self.apiService = apiService
        self.rocketLaunch = rocketLaunch
    }

    func getLaunchDetails() {
        Task {
            do {
                progressHandler?(.showLoader)
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
                launchpad = try await apiService.getLaunchpad(by: rocketLaunch.launchpad)
                progressHandler?(.reloadData)
            } catch {
                print("Something went wrong: \(error)")
                progressHandler?(.failure(error.localizedDescription))
            }
        }
    }
}
