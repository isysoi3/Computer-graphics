//
//  AppDelegate.swift
//  lab5
//
//  Created by Ilya Sysoi on 4/22/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
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
        sender.menu?.items.forEach { $0.state = .off}
        sender.state = .on
        switch sender.title {
        case "Сазерленда-Коэна":
            (rootViewController as? ViewController)?.currentAlgorithm = .cohenSutherland
        case "Отсечения отрезков выпуклым многоугольником":
            (rootViewController as? ViewController)?.currentAlgorithm = .byConvexPolygon
        default:
            break
        }
    }
    
    @IBAction func openDocument(_ sender: Any) {
        print("openDocument got called")
        guard let vc = rootViewController as? ViewController else { return }
        vc.chooseDocument()
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        NSApplication.shared.helpMenu = nil
    }
    
    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        if let vc = rootViewController as? ViewController {
            let fileUrl = URL(fileURLWithPath: filename)
            vc.currentFile = fileUrl
        }
        
        return true
    }

}

