//
//  TableSectionViewModel.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 02/11/2022.
//

import UIKit

public struct TableSectionViewModel {
    public var rows: [UITableViewCell]
    public var sectionHeaderTitle: String?
}

public struct ValueRow {
    public let key: String
    public let value: String
}

public extension ValueRow {
    var tableViewCell: UITableViewCell {
        let cell = UITableViewCell()
        var content = UIListContentConfiguration.valueCell()

        content.text = key
        content.secondaryText = value
        cell.contentConfiguration = content
        return cell
    }
}
