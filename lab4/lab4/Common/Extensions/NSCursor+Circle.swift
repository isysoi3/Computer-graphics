//
//  NSCursor+Circle.swift
//  lab4
//
//  Created by Ilya Sysoi on 4/8/19.
//  Copyright © 2019 isysoi. All rights reserved.
//

import Cocoa

extension NSCursor {
    
    public convenience init(radius: CGFloat, color: NSColor) {
        let size = NSSize(width: 2 * radius, height: 2 * radius)
        let image = NSImage(size: size)
        let path = NSBezierPath(roundedRect: NSRect(origin: .zero, size: size), xRadius: radius, yRadius: radius)
        image.lockFocus()
        color.setFill()
        path.fill()
        image.unlockFocus()
        self.init(image: image, hotSpot: NSPoint(x: radius, y: radius))
    }
    
}
