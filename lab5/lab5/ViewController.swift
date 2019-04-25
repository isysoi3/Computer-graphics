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
            let text = try? String(contentsOf: file, encoding: .utf8) else {
                drawView.clear()
                return
        }
        
        switch algorithm {
        case .cohenSutherland:
            let infoFromFile = fileService.readFromFileWithRect(text)
            guard let (lines, rect) = infoFromFile else {
                drawView.clear()
                return
            }
            let result = lineClippingService.algorithmCohenSutherland(lines: lines,
                                                                      rect: rect)
            drawView.linesWithRect = (result, rect)
        case .byConvexPolygon:
            let infoFromFile = fileService.readFromFileWithPolygon(text)
            guard let (lines, polygon) = infoFromFile else {
                drawView.clear()
                return
            }
            let result = lineClippingService.byConvexPolygon(lines: lines,
                                                             polygon: polygon)
            drawView.linesWithPolygon = (result, polygon)
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

