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
    
    //MARK: - properties
    private var currentColorModel: ColorModelEnum = .CMYK
    
    private var currentComponent: Int = 0
    
    //MARK: - current color
    @IBOutlet weak var currentColorPicker: NSColorWell!
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubviews()
        updatedViewsBasedOnColorModel(currentColorModel)
    }
    
    
    //MARK: - configure subviews
    private func configureSubviews() {
        colorPickerObservation = observe(
            \.currentColorPicker.color,
            options: [.new]) { [weak self] picker, value in
                guard let newColor = value.newValue else { return }
                self?.setColorToInputs(newColor)
        }
        
        currentColorPicker.color = NSColor(cyan: 0,
                                           magenta: 0,
                                           yellow: 0,
                                           key: 0)
        
        firstComponentInput.delegate = self
        secondComponentInput.delegate = self
        thirdComponentInput.delegate = self
        fourthComponentInput.delegate = self
        
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(conversionFromRGBToXYZError),
                       name: Notification.Name("XYZtoRGBerror"),
                       object: nil)
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
        
        updateColor()
    }
    
    private func setColorToInputs(_ color: NSColor) {
        let firstComponentValue: Double
        let secondComponentValue: Double
        let thirdComponentValue: Double
        
        switch currentColorModel {
        case .CMYK:
            let cymkModel = color.getCMYKColor()
            firstComponentInput.stringValue = "\(cymkModel.cyan.rounded(toPlaces: 2))"
            secondComponentInput.stringValue = "\(cymkModel.magenta.rounded(toPlaces: 2))"
            thirdComponentInput.stringValue = "\(cymkModel.yellow.rounded(toPlaces: 2))"
            fourthComponentInput.stringValue = "\(cymkModel.key.rounded(toPlaces: 2))"
            
            firstComponentValue = cymkModel.cyan
            secondComponentValue = cymkModel.magenta
            thirdComponentValue = cymkModel.yellow
            fourthComponentSliderInput.doubleValue = cymkModel.key
        case .HLS:
            let hlsModel = color.getHLSColor()
            firstComponentInput.stringValue = "\(hlsModel.hue.rounded(toPlaces: 2))"
            secondComponentInput.stringValue = "\(hlsModel.lightness.rounded(toPlaces: 2))"
            thirdComponentInput.stringValue = "\(hlsModel.saturation.rounded(toPlaces: 2))"
            
            firstComponentValue = hlsModel.hue
            secondComponentValue = hlsModel.lightness
            thirdComponentValue = hlsModel.saturation
        case .XYZ:
            let xyzModel = color.getXYZColor()
            firstComponentInput.stringValue = "\(xyzModel.x.rounded(toPlaces: 2))"
            secondComponentInput.stringValue = "\(xyzModel.y.rounded(toPlaces: 2))"
            thirdComponentInput.stringValue = "\(xyzModel.z.rounded(toPlaces: 2))"
            
            firstComponentValue = xyzModel.x
            secondComponentValue = xyzModel.y
            thirdComponentValue = xyzModel.z
        }
        
        CMYKoutput.stringValue = color.getCMYKColor().description
        XYZOutput.stringValue = color.getXYZColor().description
        HLSOutput.stringValue = color.getHLSColor().description
        
        firstComponentSliderInput.doubleValue = firstComponentValue
        secondComponentSliderInput.doubleValue = secondComponentValue
        thirdComponentSliderInput.doubleValue = thirdComponentValue
    }
    
    private func updateColor() {
        guard let currentColor = calculateCurrentColor() else { return }
        setColorToInputs(currentColor)
        currentColorPicker.color = currentColor
    }
    
    private func calculateCurrentColor() -> NSColor? {
        guard let firstComponent = Double(firstComponentInput.stringValue),
            let secondComponent = Double(secondComponentInput.stringValue),
            let thirdComponent = Double(thirdComponentInput.stringValue) else { return nil }

        switch currentColorModel {
        case .CMYK:
            guard let keyComponent = Double(fourthComponentInput.stringValue) else { return nil }
            return NSColor(cyan: firstComponent,
                           magenta: secondComponent,
                           yellow: thirdComponent,
                           key: keyComponent)
        case .HLS:
            return NSColor(hue: firstComponent,
                           lightness: secondComponent,
                           saturation: thirdComponent)

        case .XYZ:
            return NSColor(x: firstComponent,
                           y: secondComponent,
                           z: thirdComponent)
        }
    }
    
    //MARK: - slider valuess updates
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
    
    //MARK: - inputs values updates
    @IBAction func firstComponentInputFocused(_ sender: NSTextField) {
        currentComponent = 1
    }
    
    @IBAction func secondComponentInputFocused(_ sender: NSTextField) {
        currentComponent = 2
    }
    
    @IBAction func thirdComponentInputFocused(_ sender: NSTextField) {
        currentComponent = 3
    }
    
    @IBAction func fourthComponentInputFocused(_ sender: NSTextField) {
        currentComponent = 4
    }
    
    private func validateText(_ string: String) -> String {
        var stringValue = string
        
        let characterSet = NSCharacterSet(charactersIn: "0123456789.").inverted
        stringValue = string.components(separatedBy: characterSet).joined()
        
        let comma = NSCharacterSet(charactersIn: ".")
        let chuncks = stringValue.components(separatedBy: comma as CharacterSet)
        switch chuncks.count {
        case 0:
            stringValue = ""
        case 1:
            stringValue = String("\(chuncks[0])".prefix(3))
        default:
            let decimalPart = String(chuncks[1].prefix(2))
            let floorPart = String(chuncks[0].prefix(5 - decimalPart.count))
            stringValue = String("\(floorPart).\(decimalPart)")
        }
        
        if let doubleValue = Double(stringValue),
            stringValue.last != ".",
            doubleValue != 0 {
            let maxValue: Double
            switch currentComponent {
            case 1:
                switch currentColorModel {
                case .CMYK:
                    maxValue = CMYKColor.MaxValueEnum.cyan
                case .HLS:
                    maxValue = HLSColor.MaxValueEnum.hue
                case .XYZ:
                    maxValue = XYZColor.MaxValueEnum.x
                }
            case 2:
                switch currentColorModel {
                case .CMYK:
                    maxValue = CMYKColor.MaxValueEnum.magenta
                case .HLS:
                    maxValue = HLSColor.MaxValueEnum.lightness
                case .XYZ:
                    maxValue = XYZColor.MaxValueEnum.y
                }
            case 3:
                switch currentColorModel {
                case .CMYK:
                    maxValue = CMYKColor.MaxValueEnum.yellow
                case .HLS:
                    maxValue = HLSColor.MaxValueEnum.saturation
                case .XYZ:
                    maxValue = XYZColor.MaxValueEnum.z
                }
            case 4:
                maxValue = CMYKColor.MaxValueEnum.key
            default:
                maxValue = 0
            }
            stringValue = doubleValue > maxValue ? "\(maxValue)" : stringValue
        }
        return stringValue
    }
    
    
    //MARK: - colors convert errro handel
    @objc private func conversionFromRGBToXYZError(notification: Notification) {
        guard let valueString = notification.userInfo?["value"] as? String,
            let value = Double(valueString) else { return }
        if value == -1 {
            showAlert(message: "Ошибка первода", text: "При переводе значение меньше 0 было округлено до 0")
        } else if value == 256 {
            showAlert(message: "Ошибка первода", text: "При переводе значение больше 255 было округлено до 255")
        }
    }
    
    //MARK: - deint
    deinit {
        colorPickerObservation?.invalidate()
        let nc = NotificationCenter.default
        nc.removeObserver(self,
                          name: Notification.Name("XYZtoRGBerror"),
                          object: nil)
    }
}

extension ViewController: NSTextFieldDelegate {
    
    func controlTextDidChange(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField else { return }
        let validString = validateText(textField.stringValue)
        textField.stringValue = validString
        updateColor()
    }
    
    func controlTextDidEndEditing(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField else { return }
        if textField.stringValue.isEmpty {
            textField.stringValue = "0.0"
        }
        updateColor()
    }

}

extension ViewController {
    
    func showAlert(message: String, text: String) {
        let alert = NSAlert()
        alert.messageText = message
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
}
