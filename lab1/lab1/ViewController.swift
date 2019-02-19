//
//  ViewController.swift
//  lab1
//
//  Created by Ilya Sysoi on 2/19/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Cocoa
import SnapKit

class ViewController: NSViewController {

    enum ColorModelEnum {
        case CMYK
        case HLS
        case XYZ
    }
    
    //MARK: - properties
    private var currentColorModel: ColorModelEnum = .CMYK
    
    //MARK: - current color
    @IBOutlet weak var currentColorBox: NSBox!
    
    @IBOutlet weak var keyComponentOfCMYK: NSView!
    
    //MARK: - component labels
    @IBOutlet weak var firstComponentLabel: NSTextField!
    
    @IBOutlet weak var secondComponentLabel: NSTextField!
    
    @IBOutlet weak var thirdComponentLabel: NSTextField!
    
    //MARK: - component numbers inputs
    @IBOutlet weak var firstComponentInput: NSTextField!
    
    @IBOutlet weak var secondComponentInput: NSTextField!
    
    @IBOutlet weak var thirdComponentInput: NSTextField!
    
    @IBOutlet weak var fourthComponentInput: NSTextField!
    
    //MARK: - cloor models outputs

    @IBOutlet weak var CMYKoutput: NSTextField!
    @IBOutlet weak var HLSOutput: NSTextField!
    @IBOutlet weak var XYZOutput: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updatedViewsBasedOnColorModel(currentColorModel)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func modelSelectorValueChanged(_ sender: NSPopUpButton) {
        guard let selecteColordModelString = sender.titleOfSelectedItem else { return }
        let selecteColordModel: ColorModelEnum
        switch selecteColordModelString {
        case "CMYK":
            selecteColordModel = .CMYK
        case "HLS":
            selecteColordModel = .HLS
        case "XYZ":
            selecteColordModel = .XYZ
        default:
            return
        }
        guard selecteColordModel != currentColorModel else { return }
        currentColorModel = selecteColordModel
        updatedViewsBasedOnColorModel(selecteColordModel)
    }
    
    
    //MARK: - update view based on current model
    private func updatedViewsBasedOnColorModel(_ colorModel: ColorModelEnum) {
        switch colorModel {
        case .CMYK:
            keyComponentOfCMYK.isHidden = false
            firstComponentLabel.stringValue = "C"
            secondComponentLabel.stringValue = "M"
            thirdComponentLabel.stringValue = "Y"
        case .HLS:
            keyComponentOfCMYK.isHidden = true
            firstComponentLabel.stringValue = "H"
            secondComponentLabel.stringValue = "L"
            thirdComponentLabel.stringValue = "S"
        case .XYZ:
            keyComponentOfCMYK.isHidden = true
            firstComponentLabel.stringValue = "X"
            secondComponentLabel.stringValue = "Y"
            thirdComponentLabel.stringValue = "Z"
        }
        CMYKoutput.stringValue = "C: \(0)\nM: \(0)\nY: \(0)\nK: \(0)\n"
        XYZOutput.stringValue = "X: \(0)\nY: \(0)\nZ: \(0)\n"
        HLSOutput.stringValue = "H: \(0)\nL: \(0)\nS: \(0)\n"
//        currentColorBox.fillColor = NSColor(deviceCyan: ,
//                                            magenta: ,
//                                            yellow: ,
//                                            black: ,
//                                            alpha: )
    }
    
}

