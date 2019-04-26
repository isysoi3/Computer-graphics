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
    
    public enum LineClippingAlgorithmEnum {
        case cohenSutherland
        case byConvexPolygon
    }
    
    static let INSIDE = 0; // 0000
    static let LEFT = 1;   // 0001
    static let RIGHT = 2;  // 0010
    static let BOTTOM = 4; // 0100
    static let TOP = 8;    // 1000
    
    private func getCodeToPoint(_ point: NSPoint, rect: NSRect) -> Int {
        
        var code = LineClippingService.INSIDE
        
        if point.x < rect.minX {
            code |= LineClippingService.LEFT
        } else if point.x > rect.maxX {
            code |= LineClippingService.RIGHT
        }
        
        if point.y < rect.minY  {
            code |= LineClippingService.BOTTOM
        } else if point.y > rect.maxY {
            code |= LineClippingService.TOP
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
                    //inside
                    clippedLines.append((fromPoint, toPoint))
                    break
                } else if (codeFromPoint & codeToPoint) != 0 {
                    //outside
                    break
                } else {
                    let outcodeOut = codeFromPoint != 0 ? codeFromPoint : codeToPoint
                    var x, y: CGFloat!
                    if (outcodeOut & LineClippingService.TOP) != 0 {
                        //above
                        x = fromPoint.x + (toPoint.x - fromPoint.x)
                            * (rect.maxY - fromPoint.y)
                            / (toPoint.y - fromPoint.y)
                        y = rect.maxY
                    } else if (outcodeOut & LineClippingService.BOTTOM) != 0 {
                        //below
                        x = fromPoint.x + (toPoint.x - fromPoint.x)
                            * (rect.minY - fromPoint.y)
                            / (toPoint.y - fromPoint.y)
                        y = rect.minY
                    } else if (outcodeOut & LineClippingService.RIGHT) != 0 {
                        // right
                        y = fromPoint.y + (toPoint.y - fromPoint.y)
                            * (rect.maxX - fromPoint.x)
                            / (toPoint.x - fromPoint.x)
                        x = rect.maxX
                    } else if (outcodeOut & LineClippingService.LEFT) != 0 {
                        // left
                        y = fromPoint.y + (toPoint.y - fromPoint.y)
                            * (rect.minX - fromPoint.x)
                            / (toPoint.x - fromPoint.x)
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
    
    func byConvexPolygon(lines: [Line], polygon: Polygon) -> [Line] {
        var clippedLines: [Line] = []
        let lineWithNormal = polygon.lines
            .reversed()
            .map { line -> (Line, CGVector) in
                let newLine = (line.to, line.from)
                let normal = calculateNoramlForLine(newLine)
                return (newLine, normal)
        }
        lines.forEach { line in
            var tIn: [CGFloat] = []
            var tOut: [CGFloat] = []
            let lineVector = vectorFromLine(line)
            
            lineWithNormal.forEach { (polygonSide, normal) in
                let t = findT(line: line, polygonSide: polygonSide)
                guard t >= 0, t <= 1 else { return }
                let s = dotProduction(vector1: lineVector, vector2: normal)
                switch s {
                case 0:
                    break
                    //fix it
                case 1...:
                    tIn.append(t)
                default:
                    tOut.append(t)
                }
            }
            let minT = tIn.max()
            let maxT = tOut.min()
            if maxT == nil && minT == nil { return }
            clippedLines.append((countPoint(line: line, t: minT ?? 0),
                                 countPoint(line: line, t: maxT ?? 1)))
           
        }
        return clippedLines
    }
    
    private func countPoint(line: Line, t: CGFloat) -> CGPoint {
        return CGPoint(x: line.from.x + t * (line.to.x - line.from.x),
                       y: line.from.y + t * (line.to.y - line.from.y))
    }
    
    private func vectorFromLine(_ line: Line) -> CGVector {
        return CGVector(dx: line.to.x - line.from.x,
                        dy: line.to.y - line.from.y)
    }
    
    private func calculateNoramlForLine(_ line: Line) -> CGVector {
        let A = line.from.y - line.to.y
        let B = line.to.x - line.from.x
        return CGVector(dx: A, dy: B)
    }
    
    private func dotProduction(vector1: CGVector, vector2: CGVector) -> CGFloat {
        return vector1.dx * vector2.dx + vector1.dy * vector2.dy;
    }

    private func findT(line: Line, polygonSide: Line) -> CGFloat {
        let A = polygonSide.from.y - polygonSide.to.y
        let B = polygonSide.to.x - polygonSide.from.x
        let C = polygonSide.from.x * polygonSide.to.y - polygonSide.from.y * polygonSide.to.x
        
        return (A * line.from.x + B * line.from.y + C)
            / (A * (line.from.x - line.to.x) + B * (line.from.y - line.to.y))
    }
    
}
