//
//  Window.swift
//  lab4
//
//  Created by Ilya Sysoi on 4/8/19.
//  Copyright © 2019 isysoi. All rights reserved.
//

import Cocoa

class Window: NSWindow {

    weak var mouseTrackdelegate: MouseTrackDelegate?
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing bufferingType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: bufferingType, defer: flag)
        
        titleVisibility = .hidden
    }
    
    override func mouseMoved(with event: NSEvent) {
        mouseTrackdelegate?.mouseMoved(with: event.locationInWindow)
    }
    
}
