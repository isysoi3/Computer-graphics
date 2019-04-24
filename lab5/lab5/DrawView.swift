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
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        guard let context: CGContext = NSGraphicsContext.current?.cgContext else {
            return
        }
        
        context.setFillColor(.white)
        context.fill(bounds)
        drawCoordinateSystem()
        
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
