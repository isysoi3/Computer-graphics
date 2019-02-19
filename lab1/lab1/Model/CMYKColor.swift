//
//  CMYK.swift
//  lab1
//
//  Created by Ilya Sysoi on 2/19/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

struct CMYKColor: CustomStringConvertible {
    
    let cyan: CGFloat
    let magenta: CGFloat
    let yellow: CGFloat
    let key: CGFloat
    
    var description: String {
        return "C: \(cyan * 100)\nM: \(magenta * 100)\nY: \(yellow * 100)\nK: \(key * 100)\n"
    }
}
