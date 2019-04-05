//
//  ViewController.swift
//  lab4
//
//  Created by Ilya Sysoi on 4/5/19.
//  Copyright © 2019 isysoi. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let startPont = CGPoint(x: 0, y: 0)
        let finishPoint = CGPoint(x: 6, y: 4)
        TimeService().timeMeasure {
            print(RasterAlgorithmsService().stepByStep(startPoint: startPont, finishPoint: finishPoint))
        }
        
        TimeService().timeMeasure {
            print(RasterAlgorithmsService().bresenhamLine(startPoint: startPont, finishPoint: finishPoint))
        }
        TimeService().timeMeasure {
           print((RasterAlgorithmsService().digitalDifferentialAnalyzer(startPoint: startPont, finishPoint: finishPoint)))
        }
        TimeService().timeMeasure {
            print((RasterAlgorithmsService().bresenhamCircle(startPoint: startPont, radius: 6)))
        }
        
        
        
        
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

