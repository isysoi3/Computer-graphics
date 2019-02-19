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
    
//    convenience init(hue: CGFloat, lightness: CGFloat, saturation: CGFloat) {
//        
//    }
    
    func stringDescriptionHLS() -> String {
        return getHLSColor().description
    }
    
    func getHLSColor() -> HLSColor {
        let rgb: NSColor
        if colorSpace == NSColorSpace.deviceCMYK {
            rgb = self.usingColorSpace(NSColorSpace.deviceRGB)!
        } else {
            rgb = self
        }
        let cMax = max(rgb.redComponent, rgb.greenComponent, rgb.blueComponent)
        let cMin = min(rgb.redComponent, rgb.greenComponent, rgb.blueComponent)
        let delta = cMax - cMin
        let l = (cMin + cMax)/2
        let s = delta == 0 ? 0 : delta/(1 - abs(2*l - 1))
        let h: CGFloat
        switch delta {
        case rgb.redComponent:
            h = 60 * ((rgb.greenComponent - rgb.blueComponent)/delta).truncatingRemainder(dividingBy: 6)
        case rgb.blueComponent:
            h = 60 * (((rgb.blueComponent - rgb.greenComponent)/delta) + 4)
        case rgb.greenComponent:
             h = 60 * (((rgb.blueComponent - rgb.redComponent)/delta) + 2)
        default:
            h = 0
        }
        return HLSColor(hue: h,
                        lightness: l,
                        saturation: s)
    
    }
    
}
