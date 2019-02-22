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
        static let x: Double = 95
        static let y: Double = 100
        static let z: Double = 109
    }
    
    let x: Double
    let y: Double
    let z: Double
    
    var description: String {
        let x = self.x.rounded(toPlaces: 2)
        let y = self.y.rounded(toPlaces: 2)
        let z = self.z.rounded(toPlaces: 2)
        return "X: \(x)\nY: \(y)\nZ: \(z)\n"
    }
    
}
