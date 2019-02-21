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
    
    //MARK: - sliders inputs
    @IBOutlet weak var firstComponentSliderInput: NSSlider!
    
    @IBOutlet weak var secondComponentSliderInput: NSSlider!
    
    @IBOutlet weak var thirdComponentSliderInput: NSSlider!
    
    @IBOutlet weak var fourthComponentSliderInput: NSSlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubviews()
        updatedViewsBasedOnColorModel(currentColorModel)
    }
    
    private func configureSubviews() {
        firstComponentInput.delegate = self
        secondComponentInput.delegate = self
        thirdComponentInput.delegate = self
        fourthComponentInput.delegate = self
        
        firstComponentSliderInput.isContinuous = true
        secondComponentSliderInput.isContinuous = true
        thirdComponentSliderInput.isContinuous = true
        fourthComponentSliderInput.isContinuous = true
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
        
        updateColor()
    }
    
    private func updateColor() {
        guard let currentColor = calculateCurrentColor(colorModel: currentColorModel) else { return }
        CMYKoutput.stringValue = currentColor.stringDescriptionCMYK()
        XYZOutput.stringValue = "X: \(0)\nY: \(0)\nZ: \(0)\n"
        HLSOutput.stringValue = currentColor.stringDescriptionHLS()
        currentColorBox.fillColor = currentColor
    }
    
    private func calculateCurrentColor(colorModel: ColorModelEnum) -> NSColor? {
        guard let firstComponent = Double(firstComponentInput.stringValue),
            let secondComponent = Double(secondComponentInput.stringValue),
            let thirdComponent = Double(thirdComponentInput.stringValue) else { return nil }
        
        firstComponentSliderInput.doubleValue = firstComponent
        secondComponentSliderInput.doubleValue = secondComponent
        thirdComponentSliderInput.doubleValue = thirdComponent
        
        switch colorModel {
        case .CMYK:
            guard let keyComponent = Double(fourthComponentInput.stringValue) else { return nil }
            fourthComponentSliderInput.doubleValue = keyComponent
            return NSColor(deviceCyan: CGFloat(firstComponent)/100,
                           magenta: CGFloat(secondComponent)/100,
                           yellow: CGFloat(thirdComponent)/100,
                           black: CGFloat(keyComponent)/100,
                           alpha: 1.0)
        case .HLS:
           return nil
        case .XYZ:
            return nil
        }
    }
    
}

extension ViewController: NSTextFieldDelegate {
    
    func controlTextDidChange(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField else { return }
        
        var stringValue = textField.stringValue
        
        let characterSet = NSCharacterSet(charactersIn: "0123456789.").inverted
        stringValue = textField.stringValue.components(separatedBy: characterSet).joined()
        
        let comma = NSCharacterSet(charactersIn: ".")
        let chuncks = stringValue.components(separatedBy: comma as CharacterSet)
        switch chuncks.count {
        case 0:
            stringValue = ""
        case 1:
            stringValue = String("\(chuncks[0])".prefix(3))
        default:
            stringValue = String("\(chuncks[0]).\(chuncks[1])".prefix(5))
        }
        textField.stringValue = stringValue
        updateColor()
    }
    
    func controlTextDidEndEditing(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField else { return }
        if textField.stringValue.isEmpty {
            textField.stringValue = "0"
        } else {
            //validateTextFields()
        }
        updateColor()
    }
    
    @IBAction func firstComponentSliderValueChanged(_ sender: NSSlider) {
        firstComponentInput.stringValue = "\(sender.doubleValue.rounded(toPlaces: 2))"
        updateColor()
    }
    
    @IBAction func secondComponentSliderValueChanged(_ sender: NSSlider) {
        secondComponentInput.stringValue = "\(sender.doubleValue.rounded(toPlaces: 2))"
        updateColor()
    }
    
    @IBAction func thirdComponentSliderValueChanged(_ sender: NSSlider) {
        thirdComponentInput.stringValue = "\(sender.doubleValue.rounded(toPlaces: 2))"
        updateColor()
    }
    
    
    @IBAction func fourthComponentSliderValueChanged(_ sender: NSSlider) {
        fourthComponentInput.stringValue = "\(sender.doubleValue.rounded(toPlaces: 2))"
        updateColor()
    }
    
    
}

