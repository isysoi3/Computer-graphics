//
//  NSColor+CMYK.swift
//  lab1
//
//  Created by Ilya Sysoi on 2/19/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Cocoa

extension NSColor {
    
    convenience init(cyan: Double, magenta: Double, yellow: Double, key: Double) {
        let c = cyan/CMYKColor.MaxValueEnum.cyan
        let m = magenta/CMYKColor.MaxValueEnum.magenta
        let y = yellow/CMYKColor.MaxValueEnum.yellow
        let k = key/CMYKColor.MaxValueEnum.key
        let r: CGFloat = CGFloat((1-c) * (1-k))
        let g: CGFloat = CGFloat((1-m) * (1-k))
        let b: CGFloat = CGFloat((1-y) * (1-k))
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    func getCMYKColor() -> CMYKColor {
        let r = Double(redComponent)
        let g = Double(greenComponent)
        let b = Double(blueComponent)
        let k = 1 - max(r, g, b)
        guard k != 1 else {
            return CMYKColor(cyan: CMYKColor.MaxValueEnum.cyan,
                             magenta: CMYKColor.MaxValueEnum.magenta,
                             yellow: CMYKColor.MaxValueEnum.yellow,
                             key: CMYKColor.MaxValueEnum.key)
        }
        let c = (1 - r - k) / (1 - k)
        let m = (1 - g - k) / (1 - k)
        let y = (1 - b - k) / (1 - k)
        
        return CMYKColor(cyan: c * CMYKColor.MaxValueEnum.cyan,
                         magenta: m * CMYKColor.MaxValueEnum.magenta,
                         yellow: y * CMYKColor.MaxValueEnum.yellow,
                         key: k * CMYKColor.MaxValueEnum.key)
    }
    
}
