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
    
    func getGrayImageFromURL(_ url: URL) -> NSImage? {
        let image = Image<UInt8>(contentsOfFile: url.path)
        return image?.nsImage
    }
    
    func linearContrast(image: NSImage) -> NSImage? {
        let info = Image<UInt8>(nsImage: image)
        guard let min = info.min(), let max = info.max() else { return nil }
        let mult = UInt8.max / (max - min)
        
        return info.map { mult * ($0 - min)}.nsImage
    }
    
    func negative(image: NSImage) -> NSImage? {
        let info = Image<UInt8>(nsImage: image)
        
        return info.map { UInt8.max - $0 }.nsImage
    }
    
    func addingValue(image: NSImage, constant: CGFloat) -> NSImage? {
        let info = Image<UInt8>(nsImage: image)
        
        return info.map { nearestPixelValue(CGFloat($0) + constant) }.nsImage
    }
    
    func multipleValue(image: NSImage, constant: CGFloat) -> NSImage? {
        let info = Image<UInt8>(nsImage: image)
        let lut = (0...255).map {  nearestPixelValue(CGFloat($0) * constant) }
        
        return info.map { lut[Int($0)] }.nsImage
    }
    
    func powValue(image: NSImage, constant: CGFloat) -> NSImage? {
        let info = Image<UInt8>(nsImage: image)
        guard let max = info.max() else { return nil }
        let lut = (0...255).map { nearestPixelValue(255 * pow(CGFloat($0)/CGFloat(max), constant)) }
        
        return info.map { lut[Int($0)] }.nsImage
    }
    
    func logValue(image: NSImage) -> NSImage? {
        let info = Image<UInt8>(nsImage: image)
        guard let max = info.max() else { return nil }
        let lut = (0...255).map { nearestPixelValue(255 * (log(CGFloat($0)) / log(CGFloat(max)))) }
        
        return info.map { lut[Int($0)] }.nsImage
    }
    
    func morphologicalErosion(image: NSImage, type: Int) -> NSImage? {
        let info = Image<UInt8>(nsImage: image)
        var newImage = info
        
        for i in info.xRange {
            for j in info.yRange {
                switch type {
                case 1:
                    if  i - 1 > 0, i + 1 < info.width,
                        j - 1 > 0,  j + 1 < info.height,
                        isWhite(info[i - 1, j - 1]), isWhite(info[i, j - 1]), isWhite(info[i + 1, j - 1]),
                        isWhite(info[i - 1, j]), isWhite(info[i, j]), isWhite(info[i + 1, j]),
                        isWhite(info[i - 1, j + 1]), isWhite(info[i, j + 1]), isWhite(info[i + 1, j + 1]) {
                        newImage[i, j] = 255
                    } else {
                        newImage[i, j] = 0
                    }
                case 2:
                    if  i - 1 > 0, i + 1 < info.width,
                        j - 1 > 0,  j + 1 < info.height,
                        isWhite(info[i, j - 1]),
                        isWhite(info[i - 1, j]), isWhite(info[i, j]), isWhite(info[i + 1, j]),
                        isWhite(info[i, j+1]) {
                        newImage[i, j] = 255
                    } else {
                        newImage[i, j] = 0
                    }
                case 3:
                    if  i - 1 > 0, i + 1 < info.width,
                        j - 1 > 0,  j + 1 < info.height,
                        isWhite(info[i - 1, j - 1]), isWhite(info[i, j - 1]), isWhite(info[i + 1, j - 1]),
                        isWhite(info[i - 1, j + 1]), isWhite(info[i, j + 1]), isWhite(info[i + 1, j + 1]) {
                        newImage[i, j - 1] = 255
                    } else {
                        if j != 0 {
                            newImage[i, j - 1] = 0
                        }
                    }
                default:
                    return nil
                }
            }
        }
        return newImage.nsImage
    }

    func morphologicalDilatation(image: NSImage, type: Int) -> NSImage? {
        let info = Image<UInt8>(nsImage: image)
        var newImage = info
        
        for i in info.xRange {
            for j in info.yRange {
                switch type {
                case 1:
                    if  i - 1 > 0, i + 1 < info.width,
                        j - 1 > 0, j + 1 < info.height,
                        isBlack(info[i - 1, j - 1]), isBlack(info[i, j - 1]), isBlack(info[i + 1, j - 1]),
                        isBlack(info[i - 1, j]), isBlack(info[i, j]), isBlack(info[i + 1, j]),
                        isBlack(info[i - 1, j + 1]), isBlack(info[i, j + 1]), isBlack(info[i + 1, j + 1]) {
                        newImage[i, j] = 0
                    } else {
                        newImage[i, j] = 255
                    }
                case 2:
                    if  i - 1 > 0, i + 1 < info.width,
                        j - 1 > 0,  j + 1 < info.height,
                        isBlack(info[i - 1, j - 1]), isBlack(info[i, j - 1]), isBlack(info[i + 1, j - 1]),
                        isBlack(info[i - 1, j]), isBlack(info[i, j]), isBlack(info[i + 1, j]),
                        isBlack(info[i - 1, j + 1]), isBlack(info[i, j + 1]), isBlack(info[i + 1, j + 1]) {
                        newImage[i, j] = 0
                    } else {
                        newImage[i, j] = 255
                    }
                case 3:
                    if  i - 1 > 0, i + 1 < info.width,
                        j - 1 > 0,  j + 1 < info.height,
                        isBlack(info[i - 1, j - 1]), isBlack(info[i, j - 1]), isBlack(info[i + 1, j - 1]),
                        isBlack(info[i - 1, j + 1]), isBlack(info[i, j + 1]), isBlack(info[i + 1, j + 1]) {
                        newImage[i, j - 1] = 0
                    } else {
                        if j != 0 {
                            newImage[i, j - 1] = 255
                        }
                    }
                default:
                    return nil
                }
            }
        }
        
        return newImage.nsImage
    }
    
}

private extension ImageService {
    
    func getMinAndMaxForComponents(image: Image<RGBA<UInt8>>)
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
    
    func nearestPixelValue(_ value: CGFloat) -> UInt8 {
        return value > 255 ? UInt8.max : (value < 0 ? UInt8.min : UInt8(value))
    }
    
    func isBlack(_ pixel: UInt8) -> Bool {
        return pixel >= 0 && pixel <= 10
    }
    
    func isWhite(_ pixel: UInt8) -> Bool {
        return pixel >= 245 && pixel <= 255
    }
}
