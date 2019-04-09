//
//  ConsolePrint.swift
//  lab4
//
//  Created by Ilya Sysoi on 4/8/19.
//  Copyright © 2019 isysoi. All rights reserved.
//


import Foundation

func consolePrint<T>(
    _ message: @autoclosure () -> T,
    file: String   = #file,
    method: String = #function,
    line: Int      = #line) {
    #if DEBUG
        let msg = message()
        print("^ \((file as NSString).lastPathComponent)[\(line)], \(method): \(msg)", terminator: "\n")
    #endif
}
