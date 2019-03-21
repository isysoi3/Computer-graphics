//
//  ViewController.swift
//  lab3
//
//  Created by Ilya Sysoi on 3/18/19.
//  Copyright © 2019 isysoi. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    enum ImageOperationsEnum {
        case linearContrast
        case negative
        case adding
        case multiple
        case log
        case pow
        case erosion
        case dilatation
        case closing
        case breaking
    }
    
    var currentMode: ImageOperationsEnum = .linearContrast
    
    let service = ImageService()
    
    @IBOutlet weak var inputImageView: NSImageView!
    
    @IBOutlet weak var outputImageView: NSImageView!
    
    @IBOutlet weak var slideValueTextField: NSTextField!
    
    @IBOutlet weak var slider: NSSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider.isHidden = true
        slideValueTextField.stringValue = ""
        slideValueTextField.isContinuous = false
    }

    @IBAction func sliderValueChanged(_ sender: NSSlider) {
        slideValueTextField.doubleValue = sender.doubleValue.rounded(toPlaces: 2)
        
        workWithImage(fromImage: inputImageView.image)
    }
    
    @IBAction func popUpValueChanged(_ sender: NSPopUpButton) {
        switch sender.title {
        case "Линейное контрастирование":
            currentMode = .linearContrast
            
            slideValueTextField.stringValue = ""
            slider.isHidden = true
        case "Морфологическая обработка. Дилатация":
            currentMode = .dilatation
            
            slideValueTextField.stringValue = ""
            slider.isHidden = true
        case "Морфологическая обработка. Эрозия":
            currentMode = .erosion
            
            slideValueTextField.stringValue = ""
            slider.isHidden = true
        case "Негатив":
            currentMode = .negative
            
            slideValueTextField.stringValue = ""
            slider.isHidden = true
        case "Добавление константы":
            currentMode = .adding
            
            slider.maxValue = 255
            slider.minValue = -255
            slider.doubleValue = 0
            slideValueTextField.doubleValue = 0
            slider.isHidden = false
        case "Умножение на константу":
            currentMode = .multiple
            
            slider.maxValue = 3
            slider.minValue = 0
            slider.doubleValue = 1
            slideValueTextField.doubleValue = 1
            slider.isHidden = false
        case "Степенное преобразование":
            currentMode = .pow
            
            slider.maxValue = 10
            slider.minValue = 0
            slider.doubleValue = 1
            slideValueTextField.doubleValue = 1
            slider.isHidden = false
        case "Логарифмическое преобразование":
            currentMode = .log
            
            slideValueTextField.stringValue = ""
            slider.isHidden = true
        case "Замыкание":
            currentMode = .closing
            
            slideValueTextField.stringValue = ""
            slider.isHidden = true
        case "Размыкание":
            currentMode = .breaking
            
            slideValueTextField.stringValue = ""
            slider.isHidden = true
        default:
            return
        }
        workWithImage(fromImage: inputImageView.image)
    }
    
    private func showAlert(message: String, text: String) {
        let alert = NSAlert()
        alert.messageText = message
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
}

extension ViewController {
    
    func chooseDocument() {
        let dialog = NSOpenPanel();
        
        dialog.title = "Choose a image file or directory";
        dialog.showsResizeIndicator = false
        dialog.showsHiddenFiles = false
        dialog.canChooseDirectories = true
        dialog.canCreateDirectories = false
        dialog.allowsMultipleSelection = false
//        dialog.allowedFileTypes = imageService.allowedImageFormats
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            guard let result = dialog.url else { return }
            
            workWithUrl(result)
            NSDocumentController.shared.noteNewRecentDocumentURL(result)
        } else {
            return
        }
    }
    
    func workWithUrl(_ url: URL) {
        let image = service.getGrayImageFromURL(url)
        inputImageView.image = image
       
        workWithImage(fromImage: image)
    }

    func workWithImage(fromImage image: NSImage?) {
        guard let image = image else { return }
     
        let resultImage: NSImage?
        
        switch currentMode {
        case .adding:
            resultImage = service.addingValue(image: image,
                                              constant: CGFloat(slider.doubleValue.rounded(toPlaces: 2)))
        case .linearContrast:
            resultImage = service.linearContrast(image: image)
        case .negative:
            resultImage = service.negative(image: image)
        case .multiple:
            resultImage = service.multipleValue(image: image,
                                                constant: CGFloat(slider.doubleValue.rounded(toPlaces: 2)))
        case .log:
            resultImage = service.logValue(image: image)
        case .pow:
            resultImage = service.powValue(image: image,
                                           constant: CGFloat(slider.doubleValue.rounded(toPlaces: 2)))
        case .erosion:
            resultImage = service.morphologicalErosion(image: image)
        case .dilatation:
            resultImage = service.morphologicalDilatation(image: image)
        case .closing:
            if let rmpResultImage = service.morphologicalDilatation(image: image) {
                resultImage = service.morphologicalErosion(image: rmpResultImage)
            } else {
                resultImage = .none
            }
        case .breaking:
            if let rmpResultImage = service.morphologicalErosion(image: image) {
                resultImage = service.morphologicalDilatation(image: rmpResultImage)
            } else {
                resultImage = .none
            }
        }
        
        switch resultImage {
        case .some(let output):
            outputImageView.image = output
        case .none:
            showAlert(message: "Ошибка", text: "Не удалось обработать изображение")
        }
    }
}

