//
//  TimeService.swift
//  lab4
//
//  Created by Ilya Sysoi on 4/5/19.
//  Copyright © 2019 isysoi. All rights reserved.
//

import Foundation

class TimeService {
    
    func timeMeasure(_ f: () -> ()){
        let start = Date()
        f()
        let timeInterval: Double = Date().timeIntervalSince(start)
        print("\(timeInterval) seconds")
    }
    
    
}
