//
//  ColorViewPresenter.swift
//  lab1
//
//  Created by Ilya Sysoi on 2/22/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation
import Cocoa

class ColorViewPresenter {
    
    //MARK: - properties
    private weak var view: ColorViewProtocol!
    
    private var currentColorModel: ColorModelEnum
    
    init() {
        currentColorModel = .CMYK
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(conversionFromRGBToXYZError),
                       name: Notification.Name("XYZtoRGBerror"),
                       object: nil)
    }
    
    //MARK: - deint
    deinit {
        let nc = NotificationCenter.default
        nc.removeObserver(self,
                          name: Notification.Name("XYZtoRGBerror"),
                          object: nil)
    }
    
    @objc private func conversionFromRGBToXYZError(notification: Notification) {
        guard let valueString = notification.userInfo?["value"] as? String,
            let value = Double(valueString) else { return }
        if value == -1 {
            view.showAlert(message: "Ошибка первода", text: "При переводе значение меньше 0 было округлено до 0")
        } else if value == 256 {
            view.showAlert(message: "Ошибка первода", text: "При переводе значение больше 255 было округлено до 255")
        }
    }
    
    private func validateText(_ string: String, componentIndex: Int) -> String {
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
        
        //        if let doubleValue = Double(stringValue),
        //            stringValue.last != ".",
        //            doubleValue != 0 {
        //            let maxValue: Double
        //            switch currentComponent {
        //            case 1:
        //                switch currentColorModel {
        //                case .CMYK:
        //                    maxValue = CMYKColor.MaxValueEnum.cyan
        //                case .HLS:
        //                    maxValue = HLSColor.MaxValueEnum.hue
        //                case .XYZ:
        //                    maxValue = XYZColor.MaxValueEnum.x
        //                }
        //            case 2:
        //                switch currentColorModel {
        //                case .CMYK:
        //                    maxValue = CMYKColor.MaxValueEnum.magenta
        //                case .HLS:
        //                    maxValue = HLSColor.MaxValueEnum.lightness
        //                case .XYZ:
        //                    maxValue = XYZColor.MaxValueEnum.y
        //                }
        //            case 3:
        //                switch currentColorModel {
        //                case .CMYK:
        //                    maxValue = CMYKColor.MaxValueEnum.yellow
        //                case .HLS:
        //                    maxValue = HLSColor.MaxValueEnum.saturation
        //                case .XYZ:
        //                    maxValue = XYZColor.MaxValueEnum.z
        //                }
        //            case 4:
        //                maxValue = CMYKColor.MaxValueEnum.key
        //            default:
        //                maxValue = 0
        //            }
        //            stringValue = doubleValue > maxValue ? "\(maxValue)" : stringValue
        //        }
        return stringValue
    }
    
    private func calculateCurrentColor() -> NSColor? {
        guard let firstComponent = Double(view.getFirstComponentValue()),
            let secondComponent = Double(view.getSecondComponentValue()),
            let thirdComponent = Double(view.getThirdComponentValue()) else { return nil }
        
        switch currentColorModel {
        case .CMYK:
            guard let keyComponent = Double(view.getFourthComponentValue()) else { return nil }
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
    
    private func updateViewCurrentInfo(color: NSColor) {
        view.setHLSescription(description: color.getHLSColor().description)
        view.setXYZDescription(description: color.getXYZColor().description)
        view.setCMYKDescription(description: color.getCMYKColor().description)
        if currentColorModel == .XYZ {
            guard let firstComponent = Double(view.getFirstComponentValue()),
                let secondComponent = Double(view.getSecondComponentValue()),
                let thirdComponent = Double(view.getThirdComponentValue()) else { return }
            let model = XYZColor(x: firstComponent, y: secondComponent, z: thirdComponent)
            view.setXYZDescription(description: model.description)
        }
        view.setColorPickerValue(value: color)
    }
    
    private func updateInputsBasedOnColor(_ color: NSColor) {
        let firstComponentValue: Double
        let secondComponentValue: Double
        let thirdComponentValue: Double
        
        switch currentColorModel {
        case .CMYK:
            let model = color.getCMYKColor()
            firstComponentValue = model.cyan.rounded(toPlaces: 2)
            secondComponentValue = model.magenta.rounded(toPlaces: 2)
            thirdComponentValue = model.yellow.rounded(toPlaces: 2)
            
            view.setFourthComponentVlalidStringValue("\(model.key.rounded(toPlaces: 2))")
            view.setFourthComponentSliderValue(model.key.rounded(toPlaces: 2))
        case .HLS:
            let model = color.getHLSColor()
            firstComponentValue = model.hue.rounded(toPlaces: 2)
            secondComponentValue = model.lightness.rounded(toPlaces: 2)
            thirdComponentValue = model.saturation.rounded(toPlaces: 2)
            
        case .XYZ:
            let model = color.getXYZColor()
            firstComponentValue = model.x.rounded(toPlaces: 2)
            secondComponentValue = model.y.rounded(toPlaces: 2)
            thirdComponentValue = model.z.rounded(toPlaces: 2)
        }
        
        view.setFirstComponentVlalidStringValue("\(firstComponentValue)")
        view.setFirstComponentSliderValue(firstComponentValue)
        
        view.setSecondComponentVlalidStringValue("\(secondComponentValue)")
        view.setSecondComponentSliderValue(secondComponentValue)
        
        view.setThirdComponentVlalidStringValue("\(thirdComponentValue)")
        view.setThirdComponentSliderValue(thirdComponentValue)
    }
    
}

//MARK: - view event handlig
extension ColorViewPresenter {
    
    func hanldeViewDidLoad(view: ColorViewProtocol) {
        self.view = view
        view.updatedViewsBasedOnColorModel(currentColorModel)
        
        let color = NSColor(cyan: 0,
                            magenta: 0,
                            yellow: 0,
                            key: 0)
        view.setColorPickerValue(value: color)
        view.setHLSescription(description: color.getHLSColor().description)
        view.setXYZDescription(description: color.getXYZColor().description)
        view.setCMYKDescription(description: color.getCMYKColor().description)
    }
    
    
    func handleSelectedColorModelChange(_ newColorModel: ColorModelEnum) {
        guard currentColorModel != newColorModel,
        let currentColor = calculateCurrentColor() else { return }
        currentColorModel = newColorModel
        
        view.updatedViewsBasedOnColorModel(currentColorModel)
        
        updateInputsBasedOnColor(currentColor)
        updateViewCurrentInfo(color: currentColor)
    }
    
    func handleColorSelectedFromPicker(_ newColor: NSColor) {
        updateInputsBasedOnColor(newColor)
        view.setHLSescription(description: newColor.getHLSColor().description)
        view.setXYZDescription(description: newColor.getXYZColor().description)
        view.setCMYKDescription(description: newColor.getCMYKColor().description)
    }
    
    func handleTextInputValueChanged(_ value: String, componentIndex: Int) {
        let validString = validateText(value, componentIndex: componentIndex)
        switch componentIndex {
        case 1:
            view.setFirstComponentVlalidStringValue(validString)
            view.setFirstComponentSliderValue(Double(validString) ?? 0)
        case 2:
            view.setSecondComponentVlalidStringValue(validString)
            view.setSecondComponentSliderValue(Double(validString) ?? 0)
        case 3:
            view.setThirdComponentVlalidStringValue(validString)
            view.setThirdComponentSliderValue(Double(validString) ?? 0)
        case 4:
            view.setFourthComponentVlalidStringValue(validString)
            view.setFourthComponentSliderValue(Double(validString) ?? 0)
        default:
            return
        }
        guard let currentColor = calculateCurrentColor() else { return }
        updateViewCurrentInfo(color: currentColor)
    }
    
    func handleSliderInputValueChanged(_ value: Double, componentIndex: Int) {
        let validString = "\(value.rounded(toPlaces: 2))"
        switch componentIndex {
        case 1:
            view.setFirstComponentVlalidStringValue(validString)
        case 2:
            view.setSecondComponentVlalidStringValue(validString)
        case 3:
            view.setThirdComponentVlalidStringValue(validString)
        case 4:
            view.setFourthComponentVlalidStringValue(validString)
        default:
            return
        }
        guard let currentColor = calculateCurrentColor() else { return }
        updateViewCurrentInfo(color: currentColor)
    }
    
}
