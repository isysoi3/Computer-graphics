//
//  CMYK.swift
//  lab1
//
//  Created by Ilya Sysoi on 2/19/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

struct CMYKColor: CustomStringConvertible {
    
    enum MaxValueEnum {
        static let cyan: Double = 100
        static let magenta: Double = 100
        static let yellow: Double = 100
        static let key: Double = 100
    }
    
    let cyan: Double
    let magenta: Double
    let yellow: Double
    let key: Double
    
    var description: String {
        let c = cyan.rounded(toPlaces: 2)
        let m = magenta.rounded(toPlaces: 2)
        let y = yellow.rounded(toPlaces: 2)
        let k = key.rounded(toPlaces: 2)
        return "C: \(c)\nM: \(m)\nY: \(y)\nK: \(k)\n"
    }
}
