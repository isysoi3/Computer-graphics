//
//  ViewController.swift
//  lab1
//
//  Created by Ilya Sysoi on 2/19/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Cocoa
import SnapKit

class ColorViewController: NSViewController {
    
    //MARK: - properties
    private let presenter: ColorViewPresenter = ColorViewPresenter()
    
    //MARK: - current color
    @IBOutlet weak var colorPicker: NSColorWell!
    
    private var colorPickerObservation: NSKeyValueObservation?
    
    //MARK: - keyComponentOfCMY
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

    
    //MARK: - configure subviews
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubviews()
        presenter.hanldeViewDidLoad(view: self)
    }
    
    private func configureSubviews() {
//        colorPickerObservation = observe(
//            \.colorPicker.color,
//            options: [.new]) { [weak self] picker, value in
//                guard let newColor = value.newValue else { return }
//                self?.presenter.handleColorSelectedFromPicker(newColor)
//        }
        
        firstComponentInput.delegate = self
        secondComponentInput.delegate = self
        thirdComponentInput.delegate = self
        fourthComponentInput.delegate = self
    }

    //MARK: - handling selected new model
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
        
        presenter.handleSelectedColorModelChange(selecteColordModel)
    }
    
    //MARK: - slider valuess updates
    @IBAction func firstComponentSliderValueChanged(_ sender: NSSlider) {
        presenter.handleSliderInputValueChanged(sender.doubleValue,
                                                componentIndex: 1)
    }
    
    @IBAction func secondComponentSliderValueChanged(_ sender: NSSlider) {
        presenter.handleSliderInputValueChanged(sender.doubleValue,
                                                componentIndex: 2)
    }
    
    @IBAction func thirdComponentSliderValueChanged(_ sender: NSSlider) {
        presenter.handleSliderInputValueChanged(sender.doubleValue,
                                                componentIndex: 3)
    }
    
    @IBAction func fourthComponentSliderValueChanged(_ sender: NSSlider) {
        presenter.handleSliderInputValueChanged(sender.doubleValue,
                                                componentIndex: 4)
    }
    
    //MARK: - deint
    deinit {
        colorPickerObservation?.invalidate()
    }
    
}

extension ColorViewController:  ColorViewProtocol {
    
    //MARK: - update view based on current model
    func updatedViewsBasedOnColorModel(_ colorModel: ColorModelEnum) {
        switch colorModel {
        case .CMYK:
            keyComponentOfCMYK.isHidden = false
            
            firstComponentLabel.stringValue = "C"
            secondComponentLabel.stringValue = "M"
            thirdComponentLabel.stringValue = "Y"
            
            firstComponentSliderInput.maxValue = CMYKColor.MaxValueEnum.cyan
            secondComponentSliderInput.maxValue = CMYKColor.MaxValueEnum.magenta
            thirdComponentSliderInput.maxValue = CMYKColor.MaxValueEnum.cyan
            
            firstComponentSliderInput.isContinuous = true
            secondComponentSliderInput.isContinuous = true
            thirdComponentSliderInput.isContinuous = true
            fourthComponentSliderInput.isContinuous = true
        case .HLS:
            keyComponentOfCMYK.isHidden = true
            
            firstComponentLabel.stringValue = "H"
            secondComponentLabel.stringValue = "L"
            thirdComponentLabel.stringValue = "S"
            
            firstComponentSliderInput.maxValue = HLSColor.MaxValueEnum.hue
            secondComponentSliderInput.maxValue = HLSColor.MaxValueEnum.lightness
            thirdComponentSliderInput.maxValue = HLSColor.MaxValueEnum.saturation
            
            firstComponentSliderInput.isContinuous = true
            secondComponentSliderInput.isContinuous = true
            thirdComponentSliderInput.isContinuous = true
            fourthComponentSliderInput.isContinuous = true
        case .XYZ:
            keyComponentOfCMYK.isHidden = true
            
            firstComponentLabel.stringValue = "X"
            secondComponentLabel.stringValue = "Y"
            thirdComponentLabel.stringValue = "Z"
            
            firstComponentSliderInput.maxValue = XYZColor.MaxValueEnum.x
            secondComponentSliderInput.maxValue = XYZColor.MaxValueEnum.y
            thirdComponentSliderInput.maxValue = XYZColor.MaxValueEnum.z
            
            firstComponentSliderInput.isContinuous = false
            secondComponentSliderInput.isContinuous = false
            thirdComponentSliderInput.isContinuous = false
            fourthComponentSliderInput.isContinuous = false
        }
    }
    
    func showAlert(message: String, text: String) {
        let alert = NSAlert()
        alert.messageText = message
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    //MARK: - set color descriptions
    func setCMYKDescription(description: String) {
        CMYKoutput.stringValue = description
    }
    
    func setXYZDescription(description: String) {
        XYZOutput.stringValue = description
    }
    
    func setHLSescription(description: String) {
        HLSOutput.stringValue = description
    }
    
    //MARK: - set valid values to inputs
    func setFirstComponentVlalidStringValue(_ string: String) {
        firstComponentInput.stringValue = string
    }
    
    func setSecondComponentVlalidStringValue(_ string: String) {
        secondComponentInput.stringValue = string
    }
    
    func setThirdComponentVlalidStringValue(_ string: String) {
        thirdComponentInput.stringValue = string
    }
    
    func setFourthComponentVlalidStringValue(_ string: String) {
        fourthComponentInput.stringValue = string
    }
    
    //MARK: - set sliders values to inputs
    func setFirstComponentSliderValue(_ value: Double) {
        firstComponentSliderInput.doubleValue = value
    }
    
    func setSecondComponentSliderValue(_ value: Double) {
        secondComponentSliderInput.doubleValue = value
    }
    
    func setThirdComponentSliderValue(_ value: Double) {
        thirdComponentSliderInput.doubleValue = value
    }
    
    func setFourthComponentSliderValue(_ value: Double) {
        fourthComponentSliderInput.doubleValue = value
    }
    
    //MARK: - set color picket
    func setColorPickerValue(value: NSColor) {
        colorPicker.color = value
    }
    
    //MARK: - get component values
    func getFirstComponentValue() -> String {
        return firstComponentInput.stringValue
    }
    
    func getSecondComponentValue() -> String {
        return secondComponentInput.stringValue
    }
    
    func getThirdComponentValue() -> String {
        return thirdComponentInput.stringValue
    }
    
    func getFourthComponentValue() -> String {
        return fourthComponentInput.stringValue
    }
    
}

extension ColorViewController: NSTextFieldDelegate {
    
    func controlTextDidChange(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField else { return }

        let currentComponentInputIndex: Int
        switch textField {
        case firstComponentInput:
            currentComponentInputIndex = 1
        case secondComponentInput:
            currentComponentInputIndex = 2
        case thirdComponentInput:
            currentComponentInputIndex = 3
        case fourthComponentInput:
            currentComponentInputIndex = 4
        default:
            return
        }
        presenter.handleTextInputValueChanged(textField.stringValue,
                                              componentIndex: currentComponentInputIndex)
        
    }
    
    func controlTextDidEndEditing(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField else { return }
        if textField.stringValue.isEmpty {
            textField.stringValue = "0.0"
        }
    }
    
}
