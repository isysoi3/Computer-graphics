//
//  RasterAlgorithmsService.swift
//  lab4
//
//  Created by Ilya Sysoi on 4/5/19.
//  Copyright © 2019 isysoi. All rights reserved.
//

import Foundation

enum RasterAlgorithmsTypeEnum {
    case linear
    case bresenhamLine
    case bresenhamCircle
    case DDA
}

typealias Line = (from: NSPoint, to: NSPoint)

class RasterAlgorithmsService {
    

    func performAlgorithmBasedOn(_ type: RasterAlgorithmsTypeEnum,
                                 line: Line) -> [CGPoint] {
        let points: [CGPoint]
        switch type {
        case .bresenhamLine:
            points = bresenhamLine(startPoint: line.from,
                                   finishPoint: line.to)
        
        case .linear:
            points = stepByStep(startPoint: line.from,
                                finishPoint: line.to)
        case .bresenhamCircle:
            points = bresenhamCircle(startPoint: line.from, radius: Int(CGPoint.distance(line.from, line.to)))
        case .DDA:
            points = digitalDifferentialAnalyzer(startPoint: line.from,
                                                 finishPoint: line.to)
        }
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
            let point = switchFromOctantZeroTo(octant: 0, point: CGPoint(x: x, y: y))
            way.append(startPoint.addToPoint(x: point.x, y: point.y))
            
            if (d < 0){
                d = d + 4*x + 6;
            } else {
                d = d + 4*(x-y) + 10;
                y = y-1;
            }
            x = x + 1;
        }
//        let wayReversed = way.reversed()
//        let tmp = Array(0...7).map { octant -> [CGPoint] in
//            return wayReversed.map {switchFromOctantZeroTo(octant: octant, point: $0)}
//        }.reduce(into: [], {$0.append(contentsOf: $1)})
//        way.append(contentsOf: tmp)
        
        return way
    }
    
    func switchFromOctantZeroTo(octant: Int, point: CGPoint) -> CGPoint{
        switch(octant){
        case 0: return CGPoint(x: point.x, y: point.y)
        case 1: return CGPoint(x: point.y, y: point.x)
        case 2: return CGPoint(x: -point.y, y: point.x)
        case 3: return CGPoint(x: -point.x, y: point.y)
        case 4: return CGPoint(x: -point.x, y: -point.y)
        case 5: return CGPoint(x: -point.y, y: -point.x)
        case 6: return CGPoint(x: point.y, y: -point.x)
        case 7: return CGPoint(x: point.x, y: -point.y)
        default:
            return CGPoint(x: point.x, y: point.y)
        }
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
    
}
