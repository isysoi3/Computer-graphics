//
//  ImageService.swift
//  lab2
//
//  Created by Ilya Sysoi on 3/13/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

class ImageService {
    
    private let compressions = [1 : "Uncompressed",
                                2 : "CCITT 1D",
                                3 : "T4/Group 3 Fax",
                                4 : "T6/Group 4 Fax",
                                5 : "LZW",
                                6 : "JPEG (old-style)",
                                7 : "JPEG",
                                8 : "Adobe Deflate",
                                9 : "JBIG B&W",
                                10 : "JBIG Color",
                                99 : "JPEG",
                                262 : "Kodak 262",
                                32766 : "Next",
                                32767 : "Sony ARW Compressed",
                                32769 : "Packed RAW",
                                32770 : "Samsung SRW Compressed",
                                32771 : "CCIRLEW",
                                32772 : "Samsung SRW Compressed 2",
                                32773 : "PackBits",
                                32809 : "Thunderscan",
                                32867 : "Kodak KDC Compressed",
                                32895 : "IT8CTPAD",
                                32896 : "IT8LW",
                                32897 : "IT8MP",
                                32898 : "IT8BL",
                                32908 : "PixarFilm",
                                32909 : "PixarLog",
                                32946 : "Deflate",
                                32947 : "DCS",
                                33003 : "Aperio JPEG 2000 YCbCr",
                                33005 : "Aperio JPEG 2000 RGB",
                                34661 : "JBIG",
                                34676 : "SGILog",
                                34677 : "SGILog24",
                                34712 : "JPEG 2000",
                                34713 : "Nikon NEF Compressed",
                                34715 : "JBIG2 TIFF FX",
                                34718 : "Microsoft Document Imaging (MDI) Binary Level Codec",
                                34719 : "Microsoft Document Imaging (MDI) Progressive Transform Codec",
                                34720 : "Microsoft Document Imaging (MDI) Vector",
                                34887 : "ESRI Lerc",
                                34892 : "Lossy JPEG",
                                34925 : "LZMA2",
                                34926 : "Zstd",
                                34927 : "WebP",
                                34933 : "PNG",
                                34934 : "JPEG XR",
                                65000 : "Kodak DCR Compressed",
                                65535 : "Pentax PEF Compressed"
    ]
    
    let allowedImageFormats = ["jpg" , "gif", "tif", "bmp", "png", "pcx"]
    
    func getInfoFromUrl(_ url: URL,
                        completionBlock: @escaping (String) -> ()){
        if url.hasDirectoryPath {
            getImageInfoFromDirectory(url: url) { values in
                completionBlock(values?
                    .enumerated()
                    .map {
                        return "\($0+1) : \($1)"
                    }.joined(separator: "\n\n\n") ?? "Ничего не найдено")
            }
        } else {
            let value = getImageInfoFromFile(url: url)
            completionBlock(value ?? "Ничего не найдено")
        }
    }
    
    private func getImageInfoFromDirectory(url: URL,
                                           completionBlock: @escaping ([String]?) -> ())  {
        let backgroundQueue = DispatchQueue.global(qos: .background)
        let group = DispatchGroup()
        guard let fileURLs = try? FileManager.default
            .contentsOfDirectory(at: url,
                                 includingPropertiesForKeys: nil) else { return completionBlock(nil) }
        var result: [String] = []
        
        fileURLs.chunked(into: 50).forEach { fileURLChunk in
            backgroundQueue.async(group: group) {
                fileURLChunk.forEach { [weak self] fileUrl in
                    guard fileUrl.isFileURL,
                        self!.allowedImageFormats.contains(fileUrl.pathExtension),
                        let imageInfo = self?.getImageInfoFromFile(url: fileUrl) else { return }
                    result.append(imageInfo)
                }
            }
        }
        
        group.notify(queue: .main) {
            completionBlock(result)
        }
    }
    
    private func getImageInfoFromFile(url: URL) -> String? {
        if url.pathExtension == "pcx",
            let imageData = try? Data(contentsOf: url) {
            var buffer = [UInt8](repeating: 0, count: imageData.count)
            imageData.copyBytes(to: &buffer, count: imageData.count)
            let intBytes = buffer.map { Int($0) }
            
            print(intBytes.prefix(30))
            
            if !intBytes.isEmpty,
                intBytes.first == 10 {
                let xmin = UInt16(buffer[5]) << 8 | UInt16(buffer[4])
                let ymin = UInt16(buffer[7]) << 8 | UInt16(buffer[6])
                let xmax = UInt16(buffer[9]) << 8 | UInt16(buffer[8])
                let ymax = UInt16(buffer[11]) << 8 | UInt16(buffer[10])
                let hRes = UInt16(buffer[13]) << 8 | UInt16(buffer[12])
                let vRes = UInt16(buffer[15]) << 8 | UInt16(buffer[14])
                
                let info: [String] = [
                    "Name : \(url.lastPathComponent)",
                    "PixelWidth : \(xmax - xmin + 1)",
                    "PixelHeight : \(ymax - ymin + 1)",
                    "DPIWidth : \(vRes)",
                    "DPIHeight : \(hRes)",
                    "Depth : \(intBytes[3])",
                    intBytes[2] == 1 ? "Compression : true" : "false"
                ]
                return info.joined(separator: "\n")
            } else {
                let info: [String] = [
                    "Name : \(url.lastPathComponent)",
                    "Не получается узнать информацию о файле",
                    ]
                return info.joined(separator: "\n")
            }
        }
        
        guard let imageData = try? Data(contentsOf: url),
            let source = CGImageSourceCreateWithData((imageData as! CFMutableData), nil),
            let metadata = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String:Any] else {
                return nil
        }
        
        print(metadata)
        
        var info: [String] = [
            "Name : \(url.lastPathComponent)",
            "PixelWidth : \(metadata["PixelWidth"] ?? "")",
            "PixelHeight : \(metadata["PixelHeight"] ?? "")"
        ]
        
        if metadata["DPIWidth"] != nil {
            info.append("DPIWidth : \(metadata["DPIWidth"]!)")
        }
        if metadata["DPIHeight"] != nil {
            info.append("DPIHeight : \(metadata["DPIHeight"]!)")
        }
        if metadata["ColorModel"] != nil {
            info.append("ColorModel : \(metadata["ColorModel"]!)")
        }
        if metadata["ProfileName"] != nil {
            info.append("ProfileName : \(metadata["ProfileName"]!)")
        }
        if metadata["Depth"] != nil {
            info.append("Depth : \(metadata["Depth"]!)")
        }
        
        if let tiffData = metadata["{TIFF}"] as? [String : Any],
            let compressionId = tiffData["Compression"] as? Int,
            let compressionType = compressions[compressionId] {
            
            info.append("Compression : \(compressionType)")
        }
        
        return info.joined(separator: "\n")
    }
    
}

