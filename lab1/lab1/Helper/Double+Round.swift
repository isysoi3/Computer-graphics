//
//  Double+Round.swift
//  lab1
//
//  Created by Ilya Sysoi on 2/21/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

extension Double {
    
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
}
