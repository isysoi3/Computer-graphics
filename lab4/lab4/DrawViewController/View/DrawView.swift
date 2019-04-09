//
//  DrawView.swift
//  lab4
//
//  Created by Ilya Sysoi on 4/8/19.
//  Copyright © 2019 isysoi. All rights reserved.
//
import Cocoa

class DrawView: NSView {
    
    var currentAlgorithmType: RasterAlgorithmsTypeEnum = .bresenhamLine
    
    var penRadius: CGFloat = 4 {
        didSet {
            window?.invalidateCursorRects(for: self)
        }
    }

    var lines: [[CGPoint]] = []
    var currentLine: Line?
    
    let helperRasterAlgorithms = RasterAlgorithmsService()

    // Optimize the rendering
    override var isOpaque: Bool {
        return true
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        guard let context: CGContext = NSGraphicsContext.current?.cgContext else {
            return
        }
        
        context.setFillColor(.white)
        context.fill(bounds)
        drawCoordinateSystem()
        
        for points in lines {
            context.setFillColor(.black)
            context.fillPixels(points)
        }
        
        if let currentLine = currentLine {
            let points = helperRasterAlgorithms.bresenhamLine(startPoint: currentLine.from, finishPoint: currentLine.to)
            context.setFillColor(.black)
            context.fillPixels(points)
        }
    }
    
    private func drawCoordinateSystem() {
        let bezierGrid = NSBezierPath()
        bezierGrid.lineWidth = 0.1
        let ponints = Array(0...500)
        ponints.forEach { point in
            if point == 250 { return }
            
            bezierGrid.move(to: CGPoint(x: 0, y: point))
            bezierGrid.line(to: CGPoint(x: 500, y: point))
            
            bezierGrid.move(to: CGPoint(x: point, y: 0))
            bezierGrid.line(to: CGPoint(x: point, y: 500))
        }
        NSColor.lightGray.setStroke()
        bezierGrid.stroke()
        bezierGrid.close()
        
        let bezierMain = NSBezierPath()
        bezierMain.lineWidth = 2
        bezierMain.move(to: CGPoint(x: 0, y: 250))
        bezierMain.line(to: CGPoint(x: 500, y: 250))
        bezierMain.line(to: CGPoint(x: 490, y: 240))
        bezierMain.move(to: CGPoint(x: 500, y: 250))
        bezierMain.line(to: CGPoint(x: 490, y: 260))
        
        bezierMain.move(to: CGPoint(x: 250, y: 0))
        bezierMain.line(to: CGPoint(x: 250, y: 500))
        bezierMain.line(to: CGPoint(x: 240, y: 490))
        bezierMain.move(to: CGPoint(x: 250, y: 500))
        bezierMain.line(to: CGPoint(x: 260, y: 490))
        
        NSColor.red.setStroke()
        bezierMain.stroke()
        
        bezierMain.close()
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
        
        if let currentLine = currentLine {
            TimeService().timeMeasure {
                helperRasterAlgorithms
                    .performAlgorithmBasedOn(currentAlgorithmType, line: currentLine)
                    .flatMap { lines.append([$0]) }
                return currentAlgorithmType.rawValue
            }
        }
        currentLine = nil
        
        setNeedsDisplay(bounds)
    }
    
    override func resetCursorRects() {
        super.resetCursorRects()
        
        addCursorRect(bounds,
                      cursor: NSCursor(radius: penRadius * NSScreen.main!.backingScaleFactor,
                                       color: NSColor.black))
    }
    
}
