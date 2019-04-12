//
//  CGPoint+Add.swift
//  lab4
//
//  Created by Ilya Sysoi on 4/5/19.
//  Copyright © 2019 isysoi. All rights reserved.
//

import Foundation

extension CGPoint {
    
    func addToPoint(x: CGFloat = 0, y: CGFloat = 0) -> CGPoint {
        return CGPoint(x: self.x + x, y: self.y + y)
    }
    
    func addToPoint(x: Int = 0, y: Int = 0) -> CGPoint {
        return CGPoint(x: self.x + CGFloat(x), y: self.y + CGFloat(y))
    }
    
    static func distance(_ a: CGPoint, _ b: CGPoint) -> Int {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return Int(sqrt(xDist * xDist + yDist * yDist))
    }
    
}
