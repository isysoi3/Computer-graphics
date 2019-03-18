//
//  AppDelegate.swift
//  lab3
//
//  Created by Ilya Sysoi on 3/18/19.
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
    
    @IBAction func openDocument(_ sender: Any) {
        print("openDocument got called")
        guard let vc = rootViewController as? ViewController else { return }
        vc.chooseDocument()
    }
    
    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        if let vc = rootViewController as? ViewController {
            let fileUrl = URL(fileURLWithPath: filename)
            vc.workWithUrl(fileUrl)
        }
        
        return true
    }
    
}

