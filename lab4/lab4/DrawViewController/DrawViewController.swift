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
    
    var currentAlgorithmType: RasterAlgorithmsTypeEnum {
        set {
            drawView.currentAlgorithmType = newValue
        }
        get {
            return drawView.currentAlgorithmType
        }
    }
    
    private var scale: Int = 0
    
    var mouseLocation: NSPoint = NSPoint() {
        didSet {
            mouseLocationLabel.stringValue = mouseLocation.addToPoint(x: -250, y: -250).debugDescription
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var scalesCenterPoints: [CGFloat] = Array(0...6).map { 250.0 - (250.0 / pow(CGFloat(2), CGFloat($0)))}
//    [0, 125, 187.5, 218.75, 234.375, 242.1875, 246.09375, 248.046875]//1, 2, 3 scale
    var lastScaleNumber: CGFloat = 0
    
    override func scrollWheel(with event: NSEvent) {
        super.scrollWheel(with: event)
        let size: NSSize!
        if event.deltaY > 0 {
            size = NSSize(width: 2, height: 2)
            scale += 1
        } else {
            size = NSSize(width: 0.5, height: 0.5)
            scale -= 1
        }
        switch scale {
        case 0...4:
            drawView.scaleUnitSquare(to: size)
            drawView.bounds.origin = CGPoint(x: event.locationInWindow.x - (250.0 / pow(CGFloat(2), CGFloat(scale))),
                                             y: event.locationInWindow.y - (250.0 / pow(CGFloat(2), CGFloat(scale))))
            drawView.needsDisplay = true
        case 5...:
            scale -= 1
            break
        default:
            scale = 0
            lastScaleNumber = 0
            drawView.bounds.origin = CGPoint.zero
        }
    }
    
    func clearPlot() {
        drawView.lines = []
        drawView.setNeedsDisplay(drawView.bounds)
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

