//
//  AppDelegate.swift
//  lab2
//
//  Created by Ilya Sysoi on 3/8/19.
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

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func openDocument(_ sender: Any) {
        print("openDocument got called")
        guard let vc = rootViewController as? ViewController else { return }
        
        let dialog = NSOpenPanel();
        
        dialog.title = "Choose a image file or directory";
        dialog.showsResizeIndicator = false;
        dialog.showsHiddenFiles = false;
        dialog.canChooseDirectories = true;
        dialog.canCreateDirectories = false;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes = ["jpg" ,
                                   "gif",
                                   "tif",
                                   "bmp",
                                   "png",
                                   "pcx"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            guard let result = dialog.url else { return }
            
            vc.infoTextView.string = ""
            let imageService = ImageService()
            vc.infoTextView.string = imageService.getInfoFromUrl(result)
          
//            NSDocumentController.shared..append(result)
        } else {
            return
        }
    }
    
}

