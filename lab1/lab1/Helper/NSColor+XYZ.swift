//
//  NSColor+XYZ.swift
//  lab1
//
//  Created by Ilya Sysoi on 2/21/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Cocoa

extension NSColor {
    
    convenience init(x: Double, y: Double, z: Double) {
        let x = x/XYZColor.MaxValueEnum.x
        let y = y/XYZColor.MaxValueEnum.y
        let z = z/XYZColor.MaxValueEnum.z
        let r: CGFloat = CGFloat( 3.2404542*x - 1.5371385*y - 0.4985314*z)
        let g: CGFloat = CGFloat(-0.9692660*x + 1.8760108*y + 0.0415560*z)
        let b: CGFloat = CGFloat( 0.0556434*x - 0.2040259*y + 1.0572252*z)
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }

    func getXYZColor() -> XYZColor {
        let r = Double(redComponent)
        let g = Double(greenComponent)
        let b = Double(blueComponent)
        let x = (0.49000 * r + 0.31000 * g + 0.20000 * b) * XYZColor.MaxValueEnum.x
        let y = (0.17697 * r + 0.81240 * g + 0.01063 * b) * XYZColor.MaxValueEnum.y
        let z = (0.00000 * r + 0.01000 * g + 0.99000 * b) * XYZColor.MaxValueEnum.z
        return XYZColor(x: x,
                        y: y,
                        z: z)
    }
    
}
