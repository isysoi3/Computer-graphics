//
//  XYZ.swift
//  lab1
//
//  Created by Ilya Sysoi on 2/19/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

struct XYZColor {
    
    enum MaxValueEnum {
        static let x: Double = 100
        static let y: Double = 100
        static let z: Double = 100
    }
    
    let x: Double
    let y: Double
    let z: Double
    
    var description: String {
        return "X: \(x.rounded(toPlaces: 2))\nY: \(y.rounded(toPlaces: 2))\nZ: \(z.rounded(toPlaces: 2))\n"
    }
    
}
