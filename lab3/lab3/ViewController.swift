//
//  ViewController.swift
//  lab3
//
//  Created by Ilya Sysoi on 3/18/19.
//  Copyright © 2019 isysoi. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var inputImageView: NSImageView!
    
    @IBOutlet weak var outputImageView: NSImageView!
    
    var mouseDownEvent: NSEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension ViewController {
    
    func chooseDocument() {
        let dialog = NSOpenPanel();
        
        dialog.title = "Choose a image file or directory";
        dialog.showsResizeIndicator = false
        dialog.showsHiddenFiles = false
        dialog.canChooseDirectories = true
        dialog.canCreateDirectories = false
        dialog.allowsMultipleSelection = false
//        dialog.allowedFileTypes = imageService.allowedImageFormats
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            guard let result = dialog.url else { return }
            
            workWithUrl(result)
            NSDocumentController.shared.noteNewRecentDocumentURL(result)
        } else {
            return
        }
    }
    
    func workWithUrl(_ url: URL) {
        let image = NSImage(byReferencing: url)
        inputImageView.image = image
        guard let result = ImageService().linearContrast(image: image.cgImage),
            let resultImage = result.0 else { return }
        
        outputImageView.image = NSImage(cgImage: resultImage,
                                        size: result.1)

    }
    
}

