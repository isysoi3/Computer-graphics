//
//  ViewController.swift
//  lab5
//
//  Created by Ilya Sysoi on 4/22/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var drawView: DrawView!
    
    private let fileService = FileService()
    private let lineClippingService = LineClippingService()
    
    var currentAlgorithm: LineClippingService.LineClippingAlgorithmEnum? {
        didSet {
            recountAll()
        }
    }
    
    var currentFile: URL? {
        didSet {
           recountAll()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func recountAll() {
        guard let algorithm = currentAlgorithm,
            let file = currentFile,
            let text = try? String(contentsOf: file, encoding: .utf8) else { return }
        
        switch algorithm {
        case .cohenSutherland:
            let infoFromFile = fileService.readFromFileWithRect(text)
            let result = lineClippingService.algorithmCohenSutherland(lines: infoFromFile!.lines, rect: infoFromFile!.rect)
            drawView.linesWithRect = (result, infoFromFile!.rect)
        case .byConvexPolygon:
            let infoFromFile = fileService.readFromFileWithPolygon(text)
            let result = lineClippingService.byConvexPolygon(lines: infoFromFile!.lines, polygon: infoFromFile!.polygon)
            drawView.linesWithPolygon = (result, infoFromFile!.polygon)
        }
    }
    
    func chooseDocument() {
        let dialog = NSOpenPanel();
        
        dialog.title = "Choose a file with points";
        dialog.showsResizeIndicator = false
        dialog.showsHiddenFiles = false
        dialog.canChooseDirectories = false
        dialog.canCreateDirectories = false
        dialog.allowsMultipleSelection = false
        dialog.allowedFileTypes = ["txt"]
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            guard let result = dialog.url else { return }
            currentFile = result
            NSDocumentController.shared.noteNewRecentDocumentURL(result)
        } else {
            return
        }
    }
    
}

