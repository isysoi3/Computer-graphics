//
//  ViewController.swift
//  lab5
//
//  Created by Ilya Sysoi on 4/22/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        let path = Bundle.main.path(forResource: "test", ofType: "txt") // file path for file "data.txt"
//        guard let text = try? String(contentsOfFile: path!, encoding: .utf8) else { return }
//        let tmp = FileService().readFromFile(text)
//        LineClippingService().algorithmCohenSutherland(lines: tmp!.0, rect: tmp!.1)
        
        let path = Bundle.main.path(forResource: "test2", ofType: "txt") // file path for file "data.txt"
        guard let text = try? String(contentsOfFile: path!, encoding: .utf8) else { return }
        let tmp = FileService().readFromFile2(text)
        LineClippingService().byConvexPolygon(lines: tmp!.0, polygon: tmp!.1)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

