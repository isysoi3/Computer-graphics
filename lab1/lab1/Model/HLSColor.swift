//
//  HLS.swift
//  lab1
//
//  Created by Ilya Sysoi on 2/19/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

struct HLSColor: CustomStringConvertible {
    
    enum MaxValueEnum {
        static let hue: Double = 360
        static let lightness: Double = 100
        static let saturation: Double = 100
    }
    
    let hue: Double
    let lightness: Double
    let saturation: Double
    
    var description: String {
        return "H: \(hue.rounded(toPlaces: 2))\nL: \(lightness.rounded(toPlaces: 2))\nS: \(saturation.rounded(toPlaces: 2))\n"
    }
    
}
