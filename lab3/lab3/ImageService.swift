//
//  ImageService.swift
//  lab3
//
//  Created by Ilya Sysoi on 3/18/19.
//  Copyright © 2019 isysoi. All rights reserved.
//

import Foundation
import Cocoa

class ImageService {
    
    func pixelValues(fromCGImage imageRef: CGImage?) -> (pixelValues: [UInt8]?, width: Int, height: Int) {
        var width = 0
        var height = 0
        var pixelValues: [UInt8]?
        guard let imageRef = imageRef else {
            return (pixelValues, width, height)
        }
        
        width = imageRef.width
        height = imageRef.height
        let bitsPerComponent = imageRef.bitsPerComponent
        let bytesPerRow = imageRef.bytesPerRow
        let totalBytes = height * bytesPerRow
        
        let colorSpace = CGColorSpaceCreateDeviceGray()
        var intensities = [UInt8](repeating: 0, count: totalBytes)
        
        let contextRef = CGContext(data: &intensities, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: 0)
        contextRef?.draw(imageRef, in: CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height)))
        
        pixelValues = intensities
        return (pixelValues, width, height)
    }
    
    func image(fromPixelValues pixelValues: [UInt8]?, width: Int, height: Int) -> CGImage? {
        var imageRef: CGImage?
        guard var pixelValues = pixelValues else {
            return imageRef
        }
        
        let bitsPerComponent = 8
        let bytesPerPixel = 1
        let bitsPerPixel = bytesPerPixel * bitsPerComponent
        let bytesPerRow = bytesPerPixel * width
        let totalBytes = height * bytesPerRow
        
        imageRef = withUnsafePointer(to: &pixelValues) { ptr -> CGImage? in
            var imageRef: CGImage?
            let colorSpaceRef = CGColorSpaceCreateDeviceGray()
            let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue).union(CGBitmapInfo())
            let data = UnsafeRawPointer(ptr.pointee).assumingMemoryBound(to: UInt8.self)
            let releaseData: CGDataProviderReleaseDataCallback = {
                (info: UnsafeMutableRawPointer?, data: UnsafeRawPointer, size: Int) -> () in
            }
            
            if let providerRef = CGDataProvider(dataInfo: nil, data: data, size: totalBytes, releaseData: releaseData) {
                imageRef = CGImage(width: width,
                                   height: height,
                                   bitsPerComponent: bitsPerComponent,
                                   bitsPerPixel: bitsPerPixel,
                                   bytesPerRow: bytesPerRow,
                                   space: colorSpaceRef,
                                   bitmapInfo: bitmapInfo,
                                   provider: providerRef,
                                   decode: nil,
                                   shouldInterpolate: false,
                                   intent: CGColorRenderingIntent.defaultIntent)
            }
            
            return imageRef
        }
        return imageRef
    }
    
    func linearContrast(image: CGImage?) -> (CGImage?, CGSize)? {
        let info = pixelValues(fromCGImage: image)
        guard let pixels = info.pixelValues,
            let max = pixels.max(),
            let min = pixels.min() else {
                return nil
        }
        
        let tmp = UInt8.max / (max - min)
        
        let newPixels = pixels.map { tmp * ($0 - min)}
        
        return (self.image(fromPixelValues: newPixels,
                           width: info.width,
                           height: info.height),
                CGSize(width: info.width,
                       height: info.height)
        )
    }
    
}

/*
 func linearContrast(imageData: Data) -> Data? {
 guard let max = imageData.max(),
 let min = imageData.min() else {
 return nil
 }
 
 let tmp = UInt8.max / (max - min)
 
 let newImageData = imageData.map{$0}.map { tmp * ($0 - min)}
 print(imageData.map{$0}.prefix(30))
 print(newImageData.prefix(30))
 
 return Data(bytes: newImageData, count: newImageData.count)
 }
 */
