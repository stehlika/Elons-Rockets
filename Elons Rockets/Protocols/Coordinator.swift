//
//  Coordinator.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 07/11/2022.
//

import UIKit

public protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
