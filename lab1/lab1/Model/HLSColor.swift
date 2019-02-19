//
//  HLS.swift
//  lab1
//
//  Created by Ilya Sysoi on 2/19/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

struct HLSColor: CustomStringConvertible {
    
    let hue: CGFloat
    let lightness: CGFloat
    let saturation: CGFloat
    
    var description: String {
        return "H: \(String(format: "%.2f", Double(hue)))\nL: \(String(format: "%.2f", Double(lightness)))\nS: \(String(format: "%.2f", Double(saturation)))\n"
    }
    
}
