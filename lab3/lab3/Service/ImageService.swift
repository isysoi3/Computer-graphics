//
//  ImageService.swift
//  lab3
//
//  Created by Ilya Sysoi on 3/18/19.
//  Copyright © 2019 isysoi. All rights reserved.
//

import Foundation
import Cocoa
import EasyImagy

class ImageService {
    
    typealias MinAndMax = (min: UInt8, max: UInt8)
    
    private func getMinAndMaxForComponents(image: Image<RGBA<UInt8>>)
        -> (red: MinAndMax, green: MinAndMax, blue: MinAndMax) {
            var maxRed: UInt8 = UInt8.min
            var minRed: UInt8 = UInt8.max
            var maxGreen: UInt8 = UInt8.min
            var minGreen: UInt8 = UInt8.max
            var maxBlue: UInt8 = UInt8.min
            var minBlue: UInt8 = UInt8.max
            
            for pixel in image {
                if pixel.red < minRed {
                    minRed = pixel.red
                }
                if pixel.red > maxRed {
                    maxRed = pixel.red
                }
                if pixel.green < minGreen {
                    minGreen = pixel.green
                }
                if pixel.green > maxGreen {
                    maxGreen = pixel.green
                }
                if pixel.blue < minBlue {
                    minBlue = pixel.blue
                }
                if pixel.blue > maxBlue {
                    maxBlue = pixel.blue
                }
            }
            
            return (red: (minRed, maxRed),
                    green: (minGreen, maxGreen),
                    blue: (minBlue, maxBlue))
    }
    
    func linearContrast(image: CGImage?) -> NSImage? {
        guard let image = image else { return nil }
        let info = Image<RGBA<UInt8>>(cgImage: image)
        let (red, green, blue) = getMinAndMaxForComponents(image: info)
       
        let redTmp = UInt8.max / (red.max - red.min)
        let greenTmp = UInt8.max / (green.max - green.min)
        let blueTmp = UInt8.max / (blue.max - blue.min)
        
        return info.map { pixel in
            return RGBA<UInt8>(red: redTmp * (pixel.red - red.min),
                               green: greenTmp * (pixel.green - green.min),
                               blue: blueTmp * (pixel.blue - blue.min),
                               alpha: pixel.alpha)
            }.nsImage
    }
    
    func negative(image: CGImage?) -> NSImage? {
        guard let image = image else { return nil }
        let info = Image<RGBA<UInt8>>(cgImage: image)
        
        
        return info.map { pixel in
            return RGBA<UInt8>(red: UInt8.max - pixel.red,
                               green: UInt8.max - pixel.green,
                               blue: UInt8.max - pixel.blue,
                               alpha: pixel.alpha)
            }.nsImage
    }
    
    func addingValue(image: CGImage?, constant: Int16) -> NSImage? {
        guard let image = image else { return nil }
        let info = Image<RGBA<UInt8>>(cgImage: image)
        
        return info.map{ pixel -> RGBA<UInt8> in
            let redValue = Int16(pixel.red) + constant
            let greenValue = Int16(pixel.green) + constant
            let blueValue = Int16(pixel.blue) + constant
            return RGBA<UInt8>(red: (redValue > UInt8.max ? UInt8.max : (redValue < UInt8.min ? UInt8.min : UInt8(redValue))),
                               green: (greenValue > UInt8.max ? UInt8.max : (greenValue < UInt8.min ? UInt8.min : UInt8(greenValue))),
                               blue: (blueValue > UInt8.max ? UInt8.max : (blueValue < UInt8.min ? UInt8.min : UInt8(blueValue))),
                               alpha: pixel.alpha)
            }.nsImage
    }
    
    func multipleValue(image: CGImage?, constant: Float) -> NSImage? {
        guard let image = image,
            constant > 1,
            constant < 1 else { return nil }
        let info = Image<RGBA<UInt8>>(cgImage: image)
        
        return info.map{ pixel -> RGBA<UInt8> in
            let redValue = UInt8(Float(pixel.red) * constant)
            let greenValue = UInt8(Float(pixel.green) * constant)
            let blueValue = UInt8(Float(pixel.blue) * constant)
            return RGBA<UInt8>(red: redValue,
                               green: greenValue,
                               blue: blueValue,
                               alpha: pixel.alpha)
//            return RGBA<UInt8>(red: (redValue > UInt8.max ? UInt8.max : (redValue < UInt8.min ? UInt8.min : UInt8(redValue))),
//                               green: (greenValue > UInt8.max ? UInt8.max : (greenValue < UInt8.min ? UInt8.min : UInt8(greenValue))),
//                               blue: (blueValue > UInt8.max ? UInt8.max : (blueValue < UInt8.min ? UInt8.min : UInt8(blueValue))),
//                               alpha: pixel.alpha)
            }.nsImage
    }
    
    func powValue(image: CGImage?, constant: Float) -> NSImage? {
        guard let image = image,
            constant > 1,
            constant < 1 else { return nil }
        let info = Image<RGBA<UInt8>>(cgImage: image)
        let (red, green, blue) = getMinAndMaxForComponents(image: info)
        
        return info.map{ pixel -> RGBA<UInt8> in
            let redValue = UInt8.max * UInt8(pow(Double((pixel.red/red.max)),
                                                 Double(constant)))
            let greenValue = UInt8.max * UInt8(pow(Double((pixel.green/green.max)),
                                                   Double(constant)))
            let blueValue = UInt8.max * UInt8(pow(Double((pixel.blue/blue.max)),
                                                  Double(constant)))
            return RGBA<UInt8>(red: redValue,
                               green: greenValue,
                               blue: blueValue,
                               alpha: pixel.alpha)
            }.nsImage
    }
    
    func logValue(image: CGImage?, constant: Float) -> NSImage? {
        guard let image = image else { return nil }
        let info = Image<RGBA<UInt8>>(cgImage: image)
        let (red, green, blue) = getMinAndMaxForComponents(image: info)
        
        return info.map{ pixel -> RGBA<UInt8> in
            let redValue = UInt8.max * UInt8(log(Float(1+pixel.red)) / log(Float(1+red.max)))
            let greenValue = UInt8.max * UInt8(log(Float(1+pixel.green)) / log(Float(1+green.max)))
            let blueValue = UInt8.max * UInt8(log(Float(1+pixel.blue)) / log(Float(1+blue.max)))
            return RGBA<UInt8>(red: redValue,
                               green: greenValue,
                               blue: blueValue,
                               alpha: pixel.alpha)
            }.nsImage
    }
    
}
