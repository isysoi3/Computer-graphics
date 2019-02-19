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
        return "C: \(cyanComponent * 100)\nM: \(magentaComponent * 100)\nY: \(yellowComponent * 100)\nK: \(blackComponent * 100)\n"
    }
    
    func getCMYK() -> CMYKColor {
        return CMYKColor(cyan: cyanComponent,
                         magenta: magentaComponent,
                         yellow: yellowComponent,
                         key: blackComponent)
    }
    
}
