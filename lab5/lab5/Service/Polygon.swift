//
//  Polygon.swift
//  lab5
//
//  Created by Ilya Sysoi on 4/22/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

struct Polygon {
    
    let lines: [Line]
    
    var xMax: CGFloat {
        var max = -CGFloat.infinity
        lines.forEach {
            max = CGFloat.maximum(max, $0.to.x)
            max = CGFloat.maximum(max, $0.from.x)
        }
        return max
    }
    
    var xMin: CGFloat {
        var min = CGFloat.infinity
        lines.forEach {
            min = CGFloat.minimum(min, $0.to.x)
            min = CGFloat.minimum(min, $0.from.x)
        }
        return min
    }
    
    var yMax: CGFloat {
        var max = -CGFloat.infinity
        lines.forEach {
            max = CGFloat.maximum(max, $0.to.y)
            max = CGFloat.maximum(max, $0.from.y)
        }
        return max
    }
    
    var yMin: CGFloat {
        var min = CGFloat.infinity
        lines.forEach {
            min = CGFloat.minimum(min, $0.to.y)
            min = CGFloat.minimum(min, $0.from.y)
        }
        return min
    }
    
    func isPointInside(_ p: CGPoint) -> Bool {
        if (p.x < xMin || p.x > xMax || p.y < yMin || p.y > yMax) {
            return false
        }
        return true
    }
    
}
