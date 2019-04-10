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
    case castePitvera = "Кастла-Питвея"
}

typealias Line = (from: NSPoint, to: NSPoint)

class RasterAlgorithmsService {
    

    func performAlgorithmBasedOn(_ type: RasterAlgorithmsTypeEnum,
                                 line: Line) -> [CGPoint] {
        let points: [CGPoint]
        switch type {
        case .bresenhamLine:
            consolePrint("Draw bresenham line from \(line.from.addToPoint(x: -250, y: -250)) to \(line.to.addToPoint(x: -250, y: -250))")
            points = bresenhamLine(startPoint: line.from,
                                   finishPoint: line.to)
        
        case .linear:
            consolePrint("Draw linear line from \(line.from.addToPoint(x: -250, y: -250)) to \(line.to.addToPoint(x: -250, y: -250))")
            points = stepByStep(startPoint: line.from,
                                finishPoint: line.to)
        case .bresenhamCircle:
            let radius = Int(CGPoint.distance(line.from, line.to))
            consolePrint("Draw bresenham circle from \(line.from.addToPoint(x: -250, y: -250)) with radius \(radius)")
            points = bresenhamCircle(centerPoint: line.from,
                                     radius: radius)
        case .DDA:
            consolePrint("Draw Digital Differential Analyzer line from \(line.from.addToPoint(x: -250, y: -250)) to \(line.to.addToPoint(x: -250, y: -250))")
            points = digitalDifferentialAnalyzer(startPoint: line.from,
                                                 finishPoint: line.to)
        case .castePitvera:
            consolePrint("Draw Caste-Pitvera line from \(line.from.addToPoint(x: -250, y: -250)) to \(line.to.addToPoint(x: -250, y: -250))")
            points = castePitveraAlgorithm(startPoint: line.from,
                                           finishPoint: line.to)
        }
        consolePrint("Points: \(points.map {$0.addToPoint(x: -250, y: -250)})")
        return points
    }
    
    func stepByStep(startPoint: CGPoint, finishPoint: CGPoint) -> [CGPoint] {
        var way: [CGPoint] = []
        var startPoint = startPoint
        var finishPoint = finishPoint
        if startPoint.x > finishPoint.x {
            (startPoint, finishPoint) = (finishPoint, startPoint)
        }
        let dx = finishPoint.x - startPoint.x
        let dy = finishPoint.y - startPoint.y
        let k = dx == 0 ? 0 : dy/dx
        let b = startPoint.y - k * startPoint.x
        
        var x = startPoint.x
        while x <= finishPoint.x {
            let y = Int(k * x + b)
            way.append(CGPoint(x: Int(x), y: y))
            x += 1
        }
        
        return way
    }
    
    func bresenhamLine(startPoint: CGPoint, finishPoint: CGPoint) -> [CGPoint] {
        guard !startPoint.equalTo(finishPoint) else { return [startPoint]}
        var way: [CGPoint] = []
        
        var dx = Int(finishPoint.x - startPoint.x)
        var dy = Int(finishPoint.y - startPoint.y)
        let xSign = dx.sign()
        let ySign = dy.sign()
        dx = abs(dx)
        dy = abs(dy)
        
        var isSwap = false
        if dy > dx {
            (dx, dy) = (dy, dx)
            isSwap = true
        }
        var e = 2 * dy - dx
        
        var x = Int(startPoint.x)
        var y = Int(startPoint.y)
        
        for _ in 0...dx {
            let point = CGPoint(x: x, y: y)
            way.append(point)
            
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
    
    func bresenhamCircle(centerPoint: CGPoint, radius: Int) -> [CGPoint] {
        var way: [CGPoint] = []
        var x = 0
        var y = radius
        var d = 3 - 2 * radius
        
        while(x <= y) {
            for octant in 0...7 {
                let point = switchFromOctantZeroTo(octant: octant, point: CGPoint(x: x, y: y))
                way.append(centerPoint.addToPoint(x: point.x, y: point.y))
            }
            
            if (d < 0) {
                d = d + 4 * x + 6;
            } else {
                d = d + 4 * (x-y) + 10;
                y -= 1;
            }
            x += 1;
        }
        
        return way
    }

    func digitalDifferentialAnalyzer(startPoint: CGPoint, finishPoint: CGPoint) -> [CGPoint] {
        var way = [startPoint]
        let dx = finishPoint.x - startPoint.x
        let dy = finishPoint.y - startPoint.y
        let L = abs(dx) >= abs(dy) ? abs(dx) : abs(dy)
        let xOffset = dx/L
        let yOffset = dy/L
        var currentPoint = startPoint
        
        var i: CGFloat = 1
        while (i <= L) {
            currentPoint = currentPoint.addToPoint(x: xOffset, y: yOffset)
            way.append(currentPoint)
            i += 1
        }
        
        return way.map { CGPoint(x: $0.x.rounded(), y: $0.y.rounded())}
    }
    
    func castePitveraAlgorithm(startPoint: CGPoint, finishPoint: CGPoint) -> [CGPoint] {
        var startPoint = startPoint
        var finishPoint = finishPoint
        if startPoint.x > finishPoint.x {
            (startPoint, finishPoint) = (finishPoint, startPoint)
        }
        var way = [startPoint]
        let a = Int(finishPoint.x - startPoint.x)
        let b = Int(finishPoint.y - startPoint.y)
        if b > a || b < 0 || a <= 0 {
            consolePrint("Failed to draw line")
            return []
        }
       
        var y = b
        var x = a - b
        
        var m1 = "s", m2 = "d"
        if y == 0 {
            Array(0..<x).forEach { step in
                way.append(way.last!.addToPoint(x: 1, y: 0))
            }
        } else if  x == 0 {
            Array(0..<y).forEach { step in
                way.append(way.last!.addToPoint(x: 1, y: 1))
            }
        } else {
            while x != y {
                if x > y {
                    x -= y
                    m2 = m1 + m2.reversed()
                } else {
                    y -= x
                    m1 = m2 + m1.reversed()
                }
            }
            let rez = m2 + m1.reversed()
            String(repeating: rez, count: x).forEach { step in
                way.append(way.last!.addToPoint(x: 1, y: step == "s" ? 0 : 1))
            }
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
