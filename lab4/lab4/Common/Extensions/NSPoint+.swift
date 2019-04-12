//
//  NSPoint+.swift
//  lab4
//
//  Created by Ilya Sysoi on 4/8/19.
//  Copyright © 2019 isysoi. All rights reserved.
//

import Foundation

extension NSPoint {
    
    func round() -> NSPoint {
        return NSPoint(x: Int(self.x), y: Int(self.y))
    }
    
}
