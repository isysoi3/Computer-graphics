//
//  WindowController.swift
//  lab4
//
//  Created by Ilya Sysoi on 4/8/19.
//  Copyright © 2019 isysoi. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        
        guard let controller = contentViewController as? DrawViewController,
            let window = window as? Window else {
                return
        }
        
        window.mouseTrackdelegate = controller
        window.acceptsMouseMovedEvents = true
    }
    
}
