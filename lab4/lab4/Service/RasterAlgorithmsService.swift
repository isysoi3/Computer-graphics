//
//  RasterAlgorithmsService.swift
//  lab4
//
//  Created by Ilya Sysoi on 4/5/19.
//  Copyright © 2019 isysoi. All rights reserved.
//

import Foundation

enum RasterAlgorithmsTypeEnum: String {
    case linear = "Пошаговый"
    case bresenhamLine = "Брезенхема"
    case bresenhamCircle = "Брезенхема (окружность)"
    case DDA = "ЦДА"
}

typealias Line = (from: NSPoint, to: NSPoint)

class RasterAlgorithmsService {
    

    func performAlgorithmBasedOn(_ type: RasterAlgorithmsTypeEnum,
                                 line: Line) -> [CGPoint] {
        let points: [CGPoint]
        switch type {
        case .bresenhamLine:
            consolePrint("Draw bresenham line from \(line.from) to \(line.to)")
            points = bresenhamLine(startPoint: line.from,
                                   finishPoint: line.to)
        
        case .linear:
            consolePrint("Draw linear line from \(line.from) to \(line.to)")
            points = stepByStep(startPoint: line.from,
                                finishPoint: line.to)
        case .bresenhamCircle:
            let radius = Int(CGPoint.distance(line.from, line.to))
            consolePrint("Draw bresenham circle from \(line.from) with radius \(radius)")
            points = bresenhamCircle(startPoint: line.from,
                                     radius: radius)
        case .DDA:
            consolePrint("Draw Digital Differential Analyzer line from \(line.from) to \(line.to)")
            points = digitalDifferentialAnalyzer(startPoint: line.from,
                                                 finishPoint: line.to)
        }
        consolePrint("Points: \(points)")
        return points
    }
    
    func stepByStep(startPoint: CGPoint, finishPoint: CGPoint) -> [CGPoint] {
        var way = [startPoint]
        let dx = finishPoint.x - startPoint.x
        let dy = finishPoint.y - startPoint.y
        let k = dy/dx
        let b = startPoint.y - k * startPoint.x
        var currentXPoint = startPoint.x + 1
        
        while (currentXPoint != finishPoint.x) {
            way.append(CGPoint(x: Int(currentXPoint),
                               y: Int(k * currentXPoint + b)))
            currentXPoint += 1
        }
        way.append(finishPoint)
        
        return way
    }
    
    func bresenhamLine(startPoint: CGPoint, finishPoint: CGPoint) -> [CGPoint] {
        guard !startPoint.equalTo(finishPoint) else { return []}
        var way: [CGPoint] = []
        
        var dx = abs(Int(finishPoint.x - startPoint.x))
        var dy = abs(Int(finishPoint.y - startPoint.y))
        let xSign = Int(finishPoint.x - startPoint.x).sign()
        let ySign = Int(finishPoint.y - startPoint.y).sign()
        
        
        var isSwap = false
        if dy > dx {
            (dx, dy) = (dy, dx)
            isSwap = true
        }
        var e = 2 * dy - dx
        
        var x = Int(startPoint.x)
        var y = Int(startPoint.y)
        
        for _ in 0...dx {
            let pt = CGPoint(x: x, y: y)
            way.append(pt)
            
            if e >= 0 {
                if isSwap {
                    x += xSign
                } else {
                    y += ySign
                }
                e -= 2 * dx
            }
            
            if isSwap {
                y += ySign
            } else {
                x += xSign
            }

            e += 2 * dy
        }
        return way
    }
    
    func bresenhamCircle(startPoint: CGPoint, radius: Int) -> [CGPoint] {
        var way: [CGPoint] = []
        var x = 0
        var y = radius
        var d = 3 - 2 * radius
        
        while(x <= y) {
            for octant in 0...7 {
                let point = switchFromOctantZeroTo(octant: octant, point: CGPoint(x: x, y: y))
                way.append(startPoint.addToPoint(x: point.x, y: point.y))
            }
            
            if (d < 0){
                d = d + 4*x + 6;
            } else {
                d = d + 4*(x-y) + 10;
                y = y-1;
            }
            x = x + 1;
        }
        
        return way
    }

    
    func digitalDifferentialAnalyzer(startPoint: CGPoint, finishPoint: CGPoint) -> [CGPoint] {
        var way = [startPoint]
        let dx = finishPoint.x - startPoint.x
        let dy = finishPoint.y - startPoint.y
        let L = max(dx, dy)
        var currentPoint = startPoint
        let xOffset = dx/L
        let yOffset = dy/L
        
        var i: CGFloat = 0
        while (i < L) {
            currentPoint = currentPoint.addToPoint(x: xOffset, y: yOffset)
            way.append(currentPoint)
            i += 1
        }
        
        return way.map { CGPoint(x: round($0.x), y: round($0.y))}
    }
    
    func castePitveraAlgorithm(startPoint: CGPoint, finishPoint: CGPoint) -> [CGPoint] {
        var way = [startPoint]
        let a = abs(Int(finishPoint.x - startPoint.x))
        let b = abs(Int(finishPoint.y - startPoint.y))
        var y = b;
        var x = a - b;
        
        var m1 = "s", m2 = "d"
        while x != y {
            if (x > y){
                x = x - y;
                m2 = m1 + m2.reversed();
            } else {
                y = y - x;
                m1 = m2 + m1.reversed();
            }
        }
        let rez = m2 + m1.reversed();
        rez.forEach { step in
            way.append(way.last!.addToPoint(x: 1, y: step == "s" ? 0 : 1))
        }
        return way
    }
    
    func switchFromOctantZeroTo(octant: Int, point: CGPoint) -> CGPoint{
        switch(octant) {
        case 0:  return CGPoint(x: point.x,  y: point.y)
        case 1:  return CGPoint(x: point.y,  y: point.x)
        case 2:  return CGPoint(x: -point.y, y: point.x)
        case 3:  return CGPoint(x: -point.x, y: point.y)
        case 4:  return CGPoint(x: -point.x, y: -point.y)
        case 5:  return CGPoint(x: -point.y, y: -point.x)
        case 6:  return CGPoint(x: point.y,  y: -point.x)
        case 7:  return CGPoint(x: point.x,  y: -point.y)
        default: return CGPoint(x: point.x,  y: point.y)
        }
    }
    
    
}
