//
//  DarkMode+UIMode.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 04/11/2022.
//

import UIKit

var isDarkModeActive: Bool {
    UIScreen.main.traitCollection.userInterfaceStyle == .dark ? true : false
}
