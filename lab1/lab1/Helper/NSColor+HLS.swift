//
//  NSColor+HLS.swift
//  lab1
//
//  Created by Ilya Sysoi on 2/20/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

import Cocoa

extension NSColor {
    
    convenience init(hue: Double, lightness: Double, saturation: Double) {
        let l = lightness/HLSColor.MaxValueEnum.lightness
        let s = saturation/HLSColor.MaxValueEnum.saturation
        let c = (1 - abs(2 * l - 1)) * s
        let x = c * (1 - abs((hue/60).truncatingRemainder(dividingBy: 2) - 1))
        let m = l - c/2
        let r: Double
        let g: Double
        let b: Double
        switch hue {
        case 0..<60:
            r = c
            g = x
            b = 0
        case 60..<120:
            r = x
            g = c
            b = 0
        case 120..<180:
            r = 0
            g = c
            b = x
        case 180..<240:
            r = 0
            g = x
            b = c
        case 240..<300:
            r = x
            g = 0
            b = c
        case 300..<360:
            r = c
            g = 0
            b = x
        default:
            r = 0
            g = 0
            b = 0
        }
        
        self.init(red: CGFloat(r+m),
                  green: CGFloat(g+m),
                  blue: CGFloat(b+m),
                  alpha: 1.0)
    }
    
    func getHLSColor() -> HLSColor {
        let r = Double(redComponent)
        let g = Double(greenComponent)
        let b = Double(blueComponent)
        let cMax = max(r, g, b)
        let cMin = min(r, g, b)
        let delta = cMax - cMin
        let l = (cMin + cMax)/2
        let s = delta == 0 ? 0 : (delta/(1 - abs(2*l - 1)))
        let h: Double
        if delta != 0 {
            switch cMax {
            case r:
                h = 60 * ((g - b)/delta).truncatingRemainder(dividingBy: 6)
            case b:
                h = 60 * (((b - g)/delta) + 4)
            case g:
                h = 60 * (((b - r)/delta) + 2)
            default:
                h = 0
            }
        } else {
            h = 0
        }
        return HLSColor(hue: h,
                        lightness: l * HLSColor.MaxValueEnum.lightness,
                        saturation: s * HLSColor.MaxValueEnum.saturation)
    
    }
    
}
