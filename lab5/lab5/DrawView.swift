//
//  DrawView.swift
//  lab4
//
//  Created by Ilya Sysoi on 4/8/19.
//  Copyright © 2019 isysoi. All rights reserved.
//
import Cocoa

class DrawView: NSView {
    
    // Optimize the rendering
    override var isOpaque: Bool {
        return true
    }
    
    var linesWithPolygon: ([Line], Polygon)? {
        didSet {
            if let linesWithPolygon = linesWithPolygon {
                linesWithRect = .none
                setNeedsDisplay(bounds)
            }
        }
    }
    
    var linesWithRect: ([Line], NSRect)? {
        didSet {
            if let linesWithRect = linesWithRect {
                linesWithPolygon = .none
                setNeedsDisplay(bounds)
            }
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        guard let context: CGContext = NSGraphicsContext.current?.cgContext else {
            return
        }
        
        context.setFillColor(.white)
        context.fill(bounds)
        drawCoordinateSystem()
        
        if let (lines, polygon) = linesWithPolygon {
            let bezierPath = NSBezierPath(polygon: polygon)
            NSColor.green.setStroke()
            bezierPath.stroke()
            bezierPath.close()
            
            let bezierPathLines = NSBezierPath()
            lines/*.map { line -> Line in
                 (CGPoint(x: line.from.x + 250, y: line.from.y + 250),
                 CGPoint(x: line.to.x + 250, y: line.to.y + 250))
                 }*/
                .forEach {
                    bezierPathLines.move(to: $0.from)
                    bezierPathLines.line(to: $0.to)
            }
            NSColor.black.setStroke()
            bezierPathLines.stroke()
            bezierPathLines.close()
        }
        
        if let (lines, rect) = linesWithRect {
            
            let bezierPathRect = NSBezierPath(rect: rect)
            NSColor.green.setStroke()
            bezierPathRect.stroke()
            bezierPathRect.close()
            
            let bezierPathLines = NSBezierPath()
            lines/*.map { line -> Line in
                (CGPoint(x: line.from.x + 250, y: line.from.y + 250),
                 CGPoint(x: line.to.x + 250, y: line.to.y + 250))
                }*/
                .forEach {
                    bezierPathLines.move(to: $0.from)
                    bezierPathLines.line(to: $0.to)
            }
            NSColor.black.setStroke()
            bezierPathLines.stroke()
            bezierPathLines.close()
        }
    }
    
    private func drawCoordinateSystem() {
        let viewSize = self.bounds
        
        let bezierGrid = NSBezierPath()
        bezierGrid.lineWidth = 1
        Array(0...500).forEach { point in
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
