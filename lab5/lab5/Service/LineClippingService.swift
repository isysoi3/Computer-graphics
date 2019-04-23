//
//  LineClippingService.swift
//  lab5
//
//  Created by Ilya Sysoi on 4/22/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

typealias Line = (from: NSPoint, to: NSPoint)

class LineClippingService {
    
    static let INSIDE = 0; // 0000
    static let LEFT = 1;   // 0001
    static let RIGHT = 2;  // 0010
    static let BOTTOM = 4; // 0100
    static let TOP = 8;    // 1000
    
    private func getCodeToPoint(_ point: NSPoint, rect: NSRect) -> Int {
        
        var code = LineClippingService.INSIDE;          // initialised as being inside of [[clip window]]
        
        if point.x < rect.minX {
            code |= LineClippingService.LEFT; // to the left of clip window
        } else if point.x > rect.maxX {
            code |= LineClippingService.RIGHT; // to the right of clip window
        }
        
        if point.y < rect.minY  {
            code |= LineClippingService.BOTTOM;  // below the clip window
        } else if point.y > rect.maxY {
            code |= LineClippingService.TOP;   // above the clip window
        }
        
        return code
    }
    
    func algorithmCohenSutherland(lines: [Line], rect: NSRect) -> [Line] {
        var clippedLines: [Line] = []
        lines.forEach { [unowned self] line in
            var fromPoint = line.from
            var toPoint = line.to
            var codeFromPoint = self.getCodeToPoint(fromPoint, rect: rect)
            var codeToPoint = self.getCodeToPoint(toPoint, rect: rect)
            
            while true {
                if (codeFromPoint | codeToPoint) == 0 {
                    clippedLines.append(line) // bitwise OR is 0: both points inside window; trivially accept and exit loop
                    break
                } else if (codeFromPoint & codeToPoint) != 0 {
                    // bitwise AND is not 0: both points share an outside zone (LEFT, RIGHT, TOP,
                    // or BOTTOM), so both must be outside window; exit loop
                    break
                } else {
                    let outcodeOut = codeFromPoint != 0 ? codeFromPoint : codeToPoint
                    var x, y: CGFloat!
                    if (outcodeOut & LineClippingService.TOP) != 0 {
                        x = fromPoint.x + (toPoint.x - fromPoint.x) * (rect.maxY - fromPoint.y) / (toPoint.y - fromPoint.y)  // point is above the clip window
                        y = rect.maxY
                    } else if (outcodeOut & LineClippingService.BOTTOM) != 0 { // point is below the clip window
                        x = fromPoint.x + (toPoint.x - fromPoint.x) * (rect.minY - fromPoint.y) / (toPoint.y - fromPoint.y);
                        y = rect.minY
                    } else if (outcodeOut & LineClippingService.RIGHT) != 0 {  // point is to the right of clip window
                        y = fromPoint.y + (toPoint.y - fromPoint.y) * (rect.maxX - fromPoint.x) / (toPoint.x - fromPoint.x);
                        x = rect.maxX
                    } else if (outcodeOut & LineClippingService.LEFT) != 0 {   // point is to the left of clip window
                        y = fromPoint.y + (toPoint.y - fromPoint.y) * (rect.minX - fromPoint.x) / (toPoint.x - fromPoint.x);
                        x = rect.minX
                    }
                    
                    if (outcodeOut == codeFromPoint) {
                        fromPoint = NSPoint(x: x, y: y)
                        codeFromPoint = self.getCodeToPoint(fromPoint, rect: rect)
                    } else {
                        toPoint = NSPoint(x: x, y: y)
                        codeToPoint = self.getCodeToPoint(toPoint, rect: rect)
                    }
                }
            }
        }
        return clippedLines
    }
    
    func byConvexPolygon(lines: [(Line, CGFloat)], polygon: Polygon) {
        
    }
    
}
