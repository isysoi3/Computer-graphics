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
        case morf
    }
    
    var currentMode: ImageOperationsEnum = .linearContrast
    
    @IBOutlet weak var inputImageView: NSImageView!
    
    @IBOutlet weak var outputImageView: NSImageView!
    
    var mouseDownEvent: NSEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func popUpValueChanged(_ sender: NSPopUpButton) {
        switch sender.title {
        case "Линейное контрастирование":
            currentMode = .linearContrast
        case "Добавление константы":
            currentMode = .adding
        case "Негатив":
            currentMode = .negative
        case "Умножение на константу":
            currentMode = .multiple
        case "Степенное преобразование":
            currentMode = .pow
        case "Логарифмическое преобразование":
            currentMode = .log
        case "Морфологическая обработка":
            currentMode = .morf
        default:
            return
        }
        workWithResultImage(fromImage: inputImageView.image?.cgImage)
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
        let image = NSImage(byReferencing: url)
        inputImageView.image = image
       
        workWithResultImage(fromImage: image.cgImage)
    }

    func workWithResultImage(fromImage image: CGImage?) {
        let service = ImageService()
        let resultImage: NSImage?
        
        switch currentMode {
        case .adding:
            guard let result = service.addingValue(image: image, constant: 10) else { return }
            resultImage = result
        case .linearContrast:
            guard let result = service.linearContrast(image: image) else { return }
            resultImage = result
        case .negative:
            guard let result = service.negative(image: image) else { return }
            resultImage = result
        case .multiple:
            guard let result = service.multipleValue(image: image, constant: 25) else { return }
            resultImage = result
        case .log:
            guard let result = service.logValue(image: image, constant: 1.5) else { return }
            resultImage = result
        case .pow:
            guard let result = service.powValue(image: image, constant: 1.5) else { return }
            resultImage = result
        case .morf:
            return
        }
        switch resultImage {
        case .some(let output):
            outputImageView.image = output
        default:
            showAlert(message: "test", text: "tee")
        }
    }
    
    
    
    /*
     func workWithUrl(_ url: URL) {
     guard let imageData = try? Data(contentsOf: url),
     let result = ImageService().linearContrast(imageData: imageData) else { return }
     let image = NSImage(data: imageData)
     inputImageView.image = image
     
     outputImageView.image = NSImage(data: result)
     
     }
     */
    
}

