//
//  NSColor+CMYK.swift
//  lab1
//
//  Created by Ilya Sysoi on 2/19/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Cocoa

extension NSColor {
    
    func stringDescriptionCMYK() -> String {
        return getCMYKColor().description
    }
    
    func getCMYKColor() -> CMYKColor {
        let cmyk: NSColor
        if colorSpace == NSColorSpace.deviceRGB {
            cmyk = self.usingColorSpace(NSColorSpace.deviceCMYK)!
        } else {
            cmyk = self
        }
        return CMYKColor(cyan: cmyk.cyanComponent,
                         magenta: cmyk.magentaComponent,
                         yellow: cmyk.yellowComponent,
                         key: cmyk.blackComponent)
    }
    
}
