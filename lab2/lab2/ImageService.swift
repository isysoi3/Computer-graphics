//
//  ImageService.swift
//  lab2
//
//  Created by Ilya Sysoi on 3/13/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

class ImageService {
    
    func getInfoFromUrl(_ url: URL) -> String {
        if url.hasDirectoryPath {
            let values = getImageInfoFromDirectory(url: url)
            return values?
                .enumerated()
                .map {
                    return "\($0) : \($1)"
                }.joined(separator: "\n\n\n") ?? "Ничего не найдено"
        } else {
            let value = getImageInfoFromFile(url: url)
            return value ?? "Ничего не найдено"
        }
    }
    
    private func getImageInfoFromDirectory(url: URL) -> [String]? {
        guard let fileURLs = try? FileManager.default
            .contentsOfDirectory(at: url,
                                 includingPropertiesForKeys: nil) else { return nil }
        var result: [String] = []
        
        fileURLs.forEach { fileUrl in
            guard fileUrl.isFileURL,
                ["jpg" , "gif", "tif", "bmp", "png", "pcx"].contains(fileUrl.pathExtension),
                let imageInfo = getImageInfoFromFile(url: fileUrl) else { return }
            result.append(imageInfo)
        }
        return result
    }
    
    private func getImageInfoFromFile(url: URL) -> String? {
        guard let imageData = try? Data(contentsOf: url),
            let source = CGImageSourceCreateWithData((imageData as! CFMutableData), nil),
            let metadata = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String:Any] else {
                return nil
        }
        
        print(metadata)
        
        let info: [String] = [
            "Name : \(url.lastPathComponent)",
            "DPIWidth : \(metadata["DPIWidth"] ?? "")",
            "DPIHeight : \(metadata["DPIHeight"] ?? "")",
            "PixelWidth : \(metadata["PixelWidth"] ?? "")",
            "PixelHeight : \(metadata["PixelHeight"] ?? "")",
            "ColorModel : \(metadata["ColorModel"] ?? "")",
            "Depth : \(metadata["Depth"] ?? "")"
        ]
        
        return info.joined(separator: "\n")
    }
    
}
