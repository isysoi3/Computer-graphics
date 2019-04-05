//
//  Int+Sign.swift
//  lab4
//
//  Created by Ilya Sysoi on 4/5/19.
//  Copyright © 2019 isysoi. All rights reserved.
//

import Foundation

extension Int {
    
    func sign() -> Int {
        return (self < 0 ? -1 : 1)
    }
    
}

