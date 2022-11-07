//
//  DarkMode+UIMode.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 04/11/2022.
//

import UIKit

var isDarkModeActive: Bool {
    if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
        return true
    } else {
        return false
    }
}
