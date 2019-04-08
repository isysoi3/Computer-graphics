//
//  ViewController.swift
//  lab4
//
//  Created by Ilya Sysoi on 4/5/19.
//  Copyright © 2019 isysoi. All rights reserved.
//

import Cocoa

class DrawViewController: NSViewController {
    
    @IBOutlet var drawView: DrawView!
    
    @IBOutlet weak var mouseLocationLabel: NSTextField!
    
    var mouseLocation: NSPoint = NSPoint() {
        didSet {
            mouseLocationLabel.stringValue = mouseLocation.debugDescription
        }
    }
    
    override func scrollWheel(with event: NSEvent) {
        super.scrollWheel(with: event)
        if event.deltaY > 0 {
            drawView.scaleUnitSquare(to: NSSize(width: 2, height: 2))
        }
        if event.deltaY < 0 {
            drawView.scaleUnitSquare(to: NSSize(width: 0.5, height: 0.5))
        }
        drawView.needsDisplay = true
    }
    
}

// MARK: - ViewController: CMKMouseTrackDelegate
extension DrawViewController: MouseTrackDelegate {
    
    func mouseMoved(with position: NSPoint) {
        let point = position.round()
        mouseLocation = NSPoint(x: point.x, y: point.y)
    }
    
}

extension DrawViewController {
    
    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        let point = event.locationInWindow.round()
        mouseLocation = NSPoint(x: point.x, y: point.y)
    }
}

