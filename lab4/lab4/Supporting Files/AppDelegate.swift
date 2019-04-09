//
//  AppDelegate.swift
//  lab4
//
//  Created by Ilya Sysoi on 4/5/19.
//  Copyright © 2019 isysoi. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var rootViewController: NSViewController? {
        get {
            return NSApplication.shared.mainWindow?.windowController?.contentViewController
        }
    }
    
    @IBAction func changedAlgorithmType(_ sender: NSMenuItem) {
        let type: RasterAlgorithmsTypeEnum
        switch sender.title {
        case "Пошаговый":
            type = .linear
        case "ЦДА":
            type = .DDA
        case "Брезенхема":
            type = .bresenhamLine
        case "Брезенхема (окружность)":
            type = .bresenhamCircle
        default:
            return
        }
        sender.menu?.items.forEach { $0.state = .off}
        sender.state = .on
        if let vc = rootViewController as? DrawViewController {
            vc.currentAlgorithmType = type
        }
    }
    
}

