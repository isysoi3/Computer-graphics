//
//  Array+Chunk.swift
//  lab2
//
//  Created by Ilya Sysoi on 3/13/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
