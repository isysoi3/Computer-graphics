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
            if let currentAlgorithm = currentAlgorithm {
                recountAllFor(currentAlgorithm)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()qwe123
    }

    private func recountAllFor(_ algorithm: LineClippingService.LineClippingAlgorithmEnum) {
        switch algorithm {
        case .cohenSutherland:
            let path = Bundle.main.path(forResource: "cohenSutherland", ofType: "txt")
            guard let text = try? String(contentsOfFile: path!, encoding: .utf8) else { return }
            let infoFromFile = fileService.readFromFileWithRect(text)
            let result = lineClippingService.algorithmCohenSutherland(lines: infoFromFile!.lines, rect: infoFromFile!.rect)
            drawView.linesWithRect = (result, infoFromFile!.rect)
        case .byConvexPolygon:
            let path = Bundle.main.path(forResource: "convexPolygon", ofType: "txt")
            guard let text = try? String(contentsOfFile: path!, encoding: .utf8) else { return }
            let infoFromFile = fileService.readFromFileWithPolygon(text)
            lineClippingService.byConvexPolygon(lines: infoFromFile!.0, polygon: infoFromFile!.1)
        }
    }
    
}

