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
        let x = x/100
        let y = y/100
        let z = z/100
        let r: CGFloat = NSColor.convertRGBToXYZValue(CGFloat( 3.2404542 * x - 1.5371385 * y - 0.4985314 * z))
        let g: CGFloat = NSColor.convertRGBToXYZValue(CGFloat(-0.9692660 * x + 1.8760108 * y + 0.0415560 * z))
        let b: CGFloat = NSColor.convertRGBToXYZValue(CGFloat( 0.0556434 * x - 0.2040259 * y + 1.0572252 * z))
        let (valueR, isErrorR) = NSColor.validateRGBComponentRange(value: r)
        let (valueG, isErrorG) = NSColor.validateRGBComponentRange(value: g)
        let (valueB, isErrorB) = NSColor.validateRGBComponentRange(value: b)
       
        if isErrorR || isErrorG || isErrorB {
            var info: Int = 0
            if isErrorR {
                info = valueR == 1 ? 256 : -1
            } else if isErrorG {
                info = valueG == 1 ? 256 : -1
            } else if isErrorB {
                info = valueB == 1 ? 256 : -1
            }
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name("XYZtoRGBerror"),
                    object: nil,
                    userInfo: ["value":"\(info)"])
        }
        
        self.init(red: valueR, green: valueG, blue: valueB, alpha: 1.0)
    }
    
    private static func convertRGBToXYZValue(_ value: CGFloat) -> CGFloat {
        if (value >= 0.0031308) {
            return (1.055 * pow(value, (1 / 2.4)) - 0.055)
        } else {
            return 12.92 * value
        }
    }
    
    private static func validateRGBComponentRange(value: CGFloat) -> (value: CGFloat, isError: Bool) {
        if value < 0 {
            return (0, true)
        } else if value > 1 {
            return (1, true)
        }
        return (value, false)
    }

    func getXYZColor() -> XYZColor {
        let r = NSColor.convertXYZToRGBValue(redComponent) * 100
        let g = NSColor.convertXYZToRGBValue(greenComponent) * 100
        let b = NSColor.convertXYZToRGBValue(blueComponent) * 100
        
        let x = Double(0.4124 * r + 0.3576 * g + 0.1805 * b)
        let y = Double(0.2126 * r + 0.7152 * g + 0.0722 * b)
        let z = Double(0.0193 * r + 0.1192 * g + 0.9505 * b)
        return XYZColor(x: x,
                        y: y,
                        z: z)
    }
    
    private static func convertXYZToRGBValue(_ value: CGFloat) -> CGFloat {
        if (value >= 0.04045) {
            return pow(((value + 0.055) / 1.055), 2.4)
        } else {
            return value / 12.92
        }
    }
}
