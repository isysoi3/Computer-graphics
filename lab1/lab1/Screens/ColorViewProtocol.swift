//
//  ColorViewProtocol.swift
//  lab1
//
//  Created by Ilya Sysoi on 2/22/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation
import Cocoa

protocol ColorViewProtocol: class {
    
    func showAlert(message: String, text: String)
    
    func updatedViewsBasedOnColorModel(_ colorModel: ColorModelEnum)
    
    func setColorPickerValue(value: NSColor)
    
    func setCMYKDescription(description: String)
    
    func setXYZDescription(description: String)
    
    func setHLSescription(description: String)
    
    func setFirstComponentVlalidStringValue(_ string: String)
    
    func setSecondComponentVlalidStringValue(_ string: String)
    
    func setThirdComponentVlalidStringValue(_ string: String)
    
    func setFourthComponentVlalidStringValue(_ string: String)
    
    func setFirstComponentSliderValue(_ value: Double)
    
    func setSecondComponentSliderValue(_ value: Double)
    
    func setThirdComponentSliderValue(_ value: Double)
    
    func setFourthComponentSliderValue(_ value: Double)
    
    func getFirstComponentValue() -> String
    
    func getSecondComponentValue() -> String
    
    func getThirdComponentValue() -> String
    
    func getFourthComponentValue() -> String
    
}
