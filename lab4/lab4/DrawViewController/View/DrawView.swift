//
//  DrawView.swift
//  lab4
//
//  Created by Ilya Sysoi on 4/8/19.
//  Copyright © 2019 isysoi. All rights reserved.
//
import Cocoa

class DrawView: NSView {

    typealias Line = (from: NSPoint, to: NSPoint)
    
    var penRadius: CGFloat = 4 {
        didSet {
            window?.invalidateCursorRects(for: self)
        }
    }

    var lines: [Line] = []
    var currentLine: Line?

    var runOnce = false
    var coordinateXPoints: [CGPoint] = []
    var coordinateYPoints: [CGPoint] = []

    // Optimize the rendering
    override var isOpaque: Bool {
        return true
    }

    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        guard let context: CGContext = NSGraphicsContext.current?.cgContext else {
            return
        }
        
        if (!runOnce){
            runOnce = true
            calculateCoordinateSystem()
        }
        
        context.setFillColor(.white)
        context.fill(bounds)
        
        for line in lines {
            let pts = RasterAlgorithmsService().bresenhamLine(startPoint: line.from, finishPoint: line.to)
            context.setFillColor(.black)
            context.fillPixels(pts)
        }
        
        if let currentLine = currentLine {
            let pts =  RasterAlgorithmsService().bresenhamLine(startPoint: currentLine.from, finishPoint: currentLine.to)
            context.setFillColor(.black)
            context.fillPixels(pts)
        }
        
        context.setFillColor(NSColor.red.cgColor)
        
        // Draw coordinate X and Y Points
        context.fillPixels(coordinateXPoints)
        context.fillPixels(coordinateYPoints)
    }

    
    func calculateCoordinateSystem() {
        let midX = Int(self.frame.midX)
        let midY = Int(self.frame.midY)
        coordinateXPoints = Array(Int(self.frame.minX)...Int(self.frame.maxX)).map {
            CGPoint(x: $0, y: midY)
        }
        coordinateYPoints = Array(Int(self.frame.minY)...Int(self.frame.maxY)).map {
            CGPoint(x: midX, y: $0)
        }
    }
    
}

extension DrawView {
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        let pixel = convert(event.locationInWindow, from: nil).round()
        currentLine = (pixel, pixel)
        
        setNeedsDisplay(bounds)
    }
    
    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        
        let pixel = convert(event.locationInWindow, from: nil).round()
        currentLine?.to = pixel
        
        setNeedsDisplay(bounds)
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        
        let pixel = convert(event.locationInWindow, from: nil).round()
        currentLine?.to = pixel
        currentLine.flatMap { lines.append($0) }
        
        setNeedsDisplay(bounds)
    }
    
    override func resetCursorRects() {
        super.resetCursorRects()
        
        addCursorRect(bounds,
                      cursor: NSCursor(radius: penRadius * NSScreen.main!.backingScaleFactor,
                                       color: NSColor.black))
    }
    
}
