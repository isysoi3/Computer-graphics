//
//  CGContext+Pixels.swift
//  lab4
//
//  Created by Ilya Sysoi on 4/8/19.
//  Copyright © 2019 isysoi. All rights reserved.
//

import Foundation

extension CGContext {
    
    func fillPixels(_ pixels: [CGPoint], with size: CGSize = CGSize(width: 1.0, height: 1.0)) {
        pixels.forEach { fill($0, size: size) }
    }
    
    func fill(_ pixel: CGPoint, size: CGSize) {
        fill(CGRect(origin: pixel, size: size))
    }
}
