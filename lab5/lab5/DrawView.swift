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
    
    let scale: CGFloat = 25//10 or 25 or 1
    
    var linesWithPolygon: ([Line], [Line], Polygon)? {
        didSet {
            if linesWithPolygon != nil {
                linesWithRect = .none
                setNeedsDisplay(bounds)
            }
        }
    }
    
    var linesWithRect: ([Line], [Line], NSRect)? {
        didSet {
            if linesWithRect != nil {
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
        
        if let (lines, clippedLines, polygon) = linesWithPolygon {
            let bezierPath = NSBezierPath(polygon: Polygon(lines: polygon.lines.map { line -> Line in
                (transformToViewCordinates(line.from),
                 transformToViewCordinates(line.to))
            }))
            NSColor.green.setStroke()
            bezierPath.stroke()
            bezierPath.close()
            
            drawLines(lines, color: NSColor.black)
            drawLines(clippedLines, color: NSColor.red)
        }
        
        if let (lines, clippedLines, rect) = linesWithRect {
            let bezierPathRect = NSBezierPath(rect:
                NSRect(origin: transformToViewCordinates(rect.origin),
                       size: CGSize(width: rect.width * scale,
                                    height: rect.height * scale)))
            NSColor.green.setStroke()
            bezierPathRect.stroke()
            bezierPathRect.close()
            
            drawLines(lines, color: NSColor.black)
            drawLines(clippedLines, color: NSColor.red)
        }
    }
    
    private func drawCoordinateSystem() {
        let viewHeight = Int(self.bounds.height)
        let viewWidth = Int(self.bounds.width)
        
        let bezierGrid = NSBezierPath()
        bezierGrid.lineWidth = 1
        
        stride(from: 0, to: viewHeight, by: Int(scale)).forEach { point in
            bezierGrid.move(to: CGPoint(x: 0, y: point))
            bezierGrid.line(to: CGPoint(x: viewWidth, y: point))
        }
        stride(from: 0, to: viewWidth, by: Int(scale)).forEach { point in
            bezierGrid.move(to: CGPoint(x: point, y: 0))
            bezierGrid.line(to: CGPoint(x: point, y: viewHeight))
        }
     
        
        NSColor.lightGray.setStroke()
        bezierGrid.stroke()
        bezierGrid.close()
        
        let bezierMain = NSBezierPath()
        bezierMain.lineWidth = 1
        bezierMain.move(to: CGPoint(x: 0, y: viewHeight/2))
        bezierMain.line(to: CGPoint(x: viewWidth, y: viewHeight/2))
        bezierMain.line(to: CGPoint(x: viewWidth-5, y: viewHeight/2-5))
        bezierMain.move(to: CGPoint(x: viewWidth, y: viewHeight/2))
        bezierMain.line(to: CGPoint(x: viewWidth-5, y: viewHeight/2+5))
        
        bezierMain.move(to: CGPoint(x: viewWidth/2, y: 0))
        bezierMain.line(to: CGPoint(x: viewWidth/2, y: viewHeight))
        bezierMain.line(to: CGPoint(x: viewWidth/2-5, y: viewHeight-5))
        bezierMain.move(to: CGPoint(x: viewWidth/2, y: viewHeight))
        bezierMain.line(to: CGPoint(x: viewWidth/2+5, y: viewHeight-5))
        
        NSColor.blue.setStroke()
        bezierMain.stroke()
        
        bezierMain.close()

    }
    
    private func transformToViewCordinates(_ point: CGPoint) -> CGPoint {
        let viewHeight = self.bounds.height
        let viewWidth = self.bounds.width
        
        return CGPoint(x: point.x*scale + viewWidth/2, y: point.y*scale + viewHeight/2)
    }
    
    func clear() {
        linesWithPolygon = .none
        linesWithRect = .none
        setNeedsDisplay(bounds)
    }
    
    private func drawLines(_ lines: [Line], color: NSColor) {
        let bezierPathLines = NSBezierPath()
        lines
            .map { line -> Line in
                (transformToViewCordinates(line.from),
                 transformToViewCordinates(line.to))
            }
            .forEach {
                bezierPathLines.move(to: $0.from)
                bezierPathLines.line(to: $0.to)
        }
        color.setStroke()
        bezierPathLines.stroke()
        bezierPathLines.close()
    }
    
}
