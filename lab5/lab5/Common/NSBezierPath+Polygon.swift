//
//  NSBezierPath+Polygon.swift
//  lab5
//
//  Created by Ilya Sysoi on 4/24/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Cocoa

extension NSBezierPath {
    
    convenience init(polygon: Polygon) {
        self.init()
        
        guard let firstPoint = polygon.lines.first?.from else {return}
        move(to: firstPoint)
        polygon.lines.forEach {
            line(to: $0.to)
        }
        line(to: firstPoint)
    }
    
}
