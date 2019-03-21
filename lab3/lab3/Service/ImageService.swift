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
    
    private func nearestPixelValue(_ value: CGFloat) -> UInt8 {
        return value > 255 ? UInt8.max : (value < 0 ? UInt8.min : UInt8(value))
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
        
        return info.map { nearestPixelValue(CGFloat($0) * constant) }.nsImage
    }
    
    func powValue(image: NSImage, constant: CGFloat) -> NSImage? {
        let info = Image<UInt8>(nsImage: image)
        guard let max = info.max() else { return nil }
        
        return info.map { nearestPixelValue(pow(CGFloat(($0/max)), constant)) }.nsImage
    }
    
    func logValue(image: NSImage, constant: CGFloat) -> NSImage? {
        let info = Image<UInt8>(nsImage: image)
        guard let max = info.max() else { return nil }
        
        return info.map {nearestPixelValue(255 * (log(CGFloat($0)) / log(CGFloat(max)))) }.nsImage
    }
    
    func morphologicalErosion(image: NSImage) -> NSImage? {
        var info = Image<UInt8>(nsImage: image)
        for i in info.xRange {
            for j in info.yRange {
                if !isBlack(info[i, j]) {
                    if i > 0 && isBlack(info[i - 1, j]) {
                        info[i - 1, j] = 0
                    }
                    if i + 1 < info.width && isBlack(info[i + 1, j]) {
                        info[i + 1, j] = 0
                    }
                    if j > 0 && isBlack(info[i, j - 1]) {
                        info[i, j - 1] = 0
                    }
                    if j + 1 < info.height && isBlack(info[i, j + 1]) {
                        info[i, j + 1] = 0
                    }
                    info[i, j] = 255
                } else {
                   info[i, j] = 0
                }
            }
        }
        
        return info.nsImage
    }
    
    func morphologicalDilatation(image: NSImage) -> NSImage? {
        var info = Image<UInt8>(nsImage: image)
        for i in info.xRange {
            for j in info.yRange {
                if !isBlack(info[i, j]) {
                    if i > 0 && isBlack(info[i - 1, j]) {
                        info[i - 1, j] = 255
                    }
                    if i + 1 < info.width && isBlack(info[i + 1, j]) {
                        info[i + 1, j] = 255
                    }
                    if j > 0 && isBlack(info[i, j - 1]) {
                        info[i, j - 1] = 255
                    }
                    if j + 1 < info.height && isBlack(info[i, j + 1]) {
                        info[i, j + 1] = 255
                    }
                    info[i, j] = 255
                } else {
                    info[i, j] = 0
                }
            }
        }
        
        return info.nsImage
    }
    
    func isBlack(_ pixel: UInt8) -> Bool {
        return pixel == 0
    }
    
    func isWhite(_ pixel: UInt8) -> Bool {
        return pixel == 255
    }
    
}
