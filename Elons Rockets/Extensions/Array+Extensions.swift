//
//  Extensions+Array.swift
//  Elons Rockets
//
//  Created by adam.stehlik on 31/10/2022.
//

import Foundation

// To ensure the outOfBounds exception will not happen 
public extension Array {
    subscript(safe index: Int) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
