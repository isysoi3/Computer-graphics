//
//  ViewController.swift
//  lab2
//
//  Created by Ilya Sysoi on 3/8/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var infoTextView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureSubviews()
    }
    
    private func configureSubviews() {
        infoTextView.string = ""
        infoTextView.isEditable = false
    }
    
}


extension ViewController {
    
    func chooseDocument() {
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
            
            workWithUrl(result)
            NSDocumentController.shared.noteNewRecentDocumentURL(result)
        } else {
            return
        }
    }
    
    func workWithUrl(_ url: URL) {
        let imageService = ImageService()
        infoTextView.string = ""
        
        let start = Date()
        imageService.getInfoFromUrl(url) { result in
            let end = Date()
            let timeInterval: Double = end.timeIntervalSince(start)
            print("\(timeInterval) seconds")
            DispatchQueue.main.async { [weak self] in
                 self?.infoTextView.string = result
            }
        }
    }
    
}
