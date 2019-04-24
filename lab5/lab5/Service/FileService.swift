//
//  FileService.swift
//  lab5
//
//  Created by Ilya Sysoi on 4/22/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

class FileService {
    
    func readFromFile(_ file: String) -> (lines: [Line], rect: NSRect)? {
        //        guard let string = try? String(contentsOfFile: file) else {
        //            return nil
        //        }
        let stringLines = file.trimmingCharacters(in: .newlines)
            .components(separatedBy: .newlines)
        guard let numberOfLinesString = stringLines.first,
            let numberOfLines = Int(numberOfLinesString),
            numberOfLines > 0 else { return nil }
        var lines: [Line] = []
        var rect: NSRect!
        
        stringLines.enumerated().forEach { index, element in
            switch index {
            case 0:
                break
            case stringLines.count-1:
                let points = element.components(separatedBy: " ")
                guard points.count == 4,
                    let xMin = Int(points[0]), let yMin = Int(points[1]),
                    let xMax = Int(points[2]), let yMax = Int(points[3]) else { return }
                rect = NSRect(x: xMin, y: yMin,
                              width: (xMax - xMin), height: (yMax - yMin))
            default:
                let points = element.components(separatedBy: " ")
                guard points.count == 4,
                let x1 = Int(points[0]), let y1 = Int(points[1]),
                let x2 = Int(points[2]), let y2 = Int(points[3]) else { return }
                lines.append((from: NSPoint(x: x1, y: y1),
                              to: NSPoint(x: x2, y: y2)))
            }
        }
        
        return (lines, rect)
    }
    
    func readFromFile2(_ file: String) -> ([(Line, CGFloat)], Polygon)? {
        //        guard let string = try? String(contentsOfFile: file) else {
        //            return nil
        //        }
        let stringLines = file.trimmingCharacters(in: .newlines)
            .components(separatedBy: .newlines)
        guard let numberOfLinesString = stringLines.first,
            let numberOfLines = Int(numberOfLinesString),
            numberOfLines > 0 else { return nil }
        var lines: [(Line, CGFloat)] = []
        var polygon: Polygon!
        
        stringLines.enumerated().forEach { index, element in
            switch index {
            case 0:
                break
            case stringLines.count-1:
                let points = element.components(separatedBy: " ")
                var polygonPoints: [NSPoint] = []
                var polygonLines: [Line] = []
                for i in stride(from: 0, to: points.count, by: 2) {
                    guard let x = Int(points[i]), let y = Int(points[i+1]) else { return }
                    polygonPoints.append(NSPoint(x: x, y: y))
                }
                for i in 0..<polygonPoints.count-1 {
                    polygonLines.append((polygonPoints[i], polygonPoints[i+1]))
                }
                 polygonLines.append((polygonPoints[polygonPoints.count-1], polygonPoints[0]))
                
                polygon = Polygon(lines: polygonLines)
            default:
                let points = element.components(separatedBy: " ")
                guard points.count == 5,
                    let x1 = Int(points[0]), let y1 = Int(points[1]),
                    let x2 = Int(points[2]), let y2 = Int(points[3]),
                    let n = NumberFormatter().number(from: points[4]) else { return }
                lines.append((( from: NSPoint(x: x1, y: y1),
                                to: NSPoint(x: x2, y: y2)),
                              CGFloat(n.floatValue)))
            }
        }
        
        return (lines, polygon)
    }
    
}
