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
            if result.hasDirectoryPath {
                let values = workWithDirectory(url: result)
                vc.infoTextView.string = values?
                    .enumerated()
                    .map {
                        return "\($0) : \($1)"
                    }.joined(separator: "\n\n\n") ?? "Ничего не найдено"
            } else {
                let value = workWithFile(url: result)
                vc.infoTextView.string = value  ?? "Ничего не найдено"
            }
            
//            NSDocumentController.shared..append(result)
        } else {
            return
        }
    }
    
    private func workWithDirectory(url: URL) -> [String]? {
        guard let fileURLs = try? FileManager.default
            .contentsOfDirectory(at: url,
                                 includingPropertiesForKeys: nil) else { return nil }
        var result: [String] = []
        
        fileURLs.forEach { fileUrl in
            guard fileUrl.isFileURL,
                ["jpg" , "gif", "tif", "bmp", "png", "pcx"].contains(fileUrl.pathExtension),
                let imageInfo = workWithFile(url: fileUrl) else { return }
            result.append(imageInfo)
        }
        return result
    }
    
    private func workWithFile(url: URL) -> String? {
        guard let imageData = try? Data(contentsOf: url),
         let source = CGImageSourceCreateWithData((imageData as! CFMutableData), nil) else { return nil }
        
        let metadata = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as! [String:Any]
        print(metadata)
        
        let info: [String] = [
            "Name : \(url.lastPathComponent)",
            "DPIWidth : \(metadata["DPIWidth"] ?? "")",
            "DPIHeight : \(metadata["DPIHeight"] ?? "")",
            "PixelWidth : \(metadata["PixelWidth"] ?? "")",
            "PixelHeight : \(metadata["PixelHeight"] ?? "")",
            "ColorModel : \(metadata["ColorModel"] ?? "")",
            "Depth : \(metadata["Depth"] ?? "")"
        ]

        return info.joined(separator: "\n")
    }
    
}

