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
    
    var currentAlgorithm: LineClippingService.LineClippingAlgorithmEnum? {
        didSet {
            if let currentAlgorithm = currentAlgorithm {
                recountAllFor(currentAlgorithm)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    private func recountAllFor(_ algorithm: LineClippingService.LineClippingAlgorithmEnum) {
        switch algorithm {
        case .cohenSutherland:
            let path = Bundle.main.path(forResource: "cohenSutherland", ofType: "txt")
            guard let text = try? String(contentsOfFile: path!, encoding: .utf8) else { return }
            let infoFromFile = FileService().readFromFile(text)
            LineClippingService().algorithmCohenSutherland(lines: infoFromFile!.0, rect: infoFromFile!.1)
        case .byConvexPolygon:
            let path = Bundle.main.path(forResource: "convexPolygon", ofType: "txt")
            guard let text = try? String(contentsOfFile: path!, encoding: .utf8) else { return }
            let infoFromFile = FileService().readFromFile2(text)
            LineClippingService().byConvexPolygon(lines: infoFromFile!.0, polygon: infoFromFile!.1)
        }
    }
    
}

