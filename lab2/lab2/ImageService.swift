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
            "PixelWidth : \(metadata["PixelWidth"] ?? "")",
            "PixelHeight : \(metadata["PixelHeight"] ?? "")",
            "DPIWidth : \(metadata["DPIWidth"] ?? "")",
            "DPIHeight : \(metadata["DPIHeight"] ?? "")",
            "ColorModel : \(metadata["ColorModel"] ?? "")",
            "Depth : \(metadata["Depth"] ?? "")"
        ]
        
        return info.joined(separator: "\n")
    }
    
}

/*
 1:  512х480х96.bmp
 Width: 512
 Height: 480
 Width DPI: 0
 Height DPI: 0
 Color depth: 8
 Compression: BI_RGB
 
 2:  512х480х96fax3.tif
 Width: 512
 Height: 480
 Width DPI: 96
 Height DPI: 96
 Color depth: 1
 Compression: BI_RGB
 
 3:  512х480х96fax4.tif
 Width: 512
 Height: 480
 Width DPI: 72
 Height DPI: 72
 Color depth: 1
 Compression: BI_RGB
 
 4:  512х480х96lzw.tif
 Width: 512
 Height: 480
 Width DPI: 72
 Height DPI: 72
 Color depth: 24
 Compression: BI_RGB
 
 5:  512х480х96RLE.tif
 Width: 512
 Height: 480
 Width DPI: 72
 Height DPI: 72
 Color depth: 1
 Compression: BI_RGB
 
 6:  1305х864х183.gif
 Width: 1305
 Height: 864
 Width DPI: 72
 Height DPI: 72
 Color depth: 6
 Compression: lzw
 
 7:  1305х864х183.jpg
 Width: 1305
 Height: 864
 Width DPI: 183
 Height DPI: 183
 Color depth: 24
 Compression: JPEG
 
 8:  1305х864х183.tif
 Width: 1305
 Height: 864
 Width DPI: 183
 Height DPI: 183
 Color depth: 4
 Compression: JPEG
 
 9:  1305х864х183LZW+diff.tif
 Width: 1305
 Height: 864
 Width DPI: 183
 Height DPI: 183
 Color depth: 24
 Compression: JPEG
 
 10:  1305х864х183none.pcx
 Width: 1305
 Height: 864
 Width DPI: 183
 Height DPI: 183
 Color depth: 24
 Compression: JPEG
 
 11:  1305х864х183palette.png
 Width: 1305
 Height: 864
 Width DPI: 183
 Height DPI: 183
 Color depth: 8
 Compression: deflate
 
 12:  1305х864х183RLE.bmp
 Width: 1305
 Height: 864
 Width DPI: 0
 Height DPI: 0
 Color depth: 24
 Compression: BI_RGB
 
 13:  1305х864х183RLE.pcx
 Width: 1305
 Height: 864
 Width DPI: 0
 Height DPI: 0
 Color depth: 24
 Compression: BI_RGB
 
 14:  3888х2592х72.jpg
 Width: 3888
 Height: 2592
 Width DPI: 72
 Height DPI: 72
 Color depth: 24
 Compression: JPEG
 
 */
