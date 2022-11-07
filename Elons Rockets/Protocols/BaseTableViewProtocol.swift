//
//  BaseTableViewProtocol.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 01/11/2022.
//

import UIKit

public protocol BaseTableViewProtocol {
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func cellForRow(at indexPath: IndexPath) -> UITableViewCell
    func didSelectRow(at indexPath: IndexPath)
    func viewTypeDidLoad()
}

// Default values
public extension BaseTableViewProtocol {
    func numberOfSections() -> Int {
        1
    }
}
