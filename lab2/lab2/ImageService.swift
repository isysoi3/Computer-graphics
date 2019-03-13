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
    
    func getInfoFromUrl(_ url: URL,
                        completionBlock: @escaping (String) -> ()){
        if url.hasDirectoryPath {
            getImageInfoFromDirectory(url: url) { values in
                completionBlock(values?
                    .enumerated()
                    .map {
                        return "\($0) : \($1)"
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
        
        fileURLs.chunked(into: 100).forEach { fileURLChunk in
            backgroundQueue.async(group: group) {
                fileURLChunk.forEach { [weak self] fileUrl in
                    guard fileUrl.isFileURL,
                        ["jpg" , "gif", "tif", "bmp", "png", "pcx"].contains(fileUrl.pathExtension),
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
        guard let imageData = try? Data(contentsOf: url),
            let source = CGImageSourceCreateWithData((imageData as! CFMutableData), nil),
            let metadata = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String:Any] else {
                return nil
        }
        
        print(metadata)
        
        var info: [String] = [
            "Name : \(url.lastPathComponent)",
            "PixelWidth : \(metadata["PixelWidth"] ?? "")",
            "PixelHeight : \(metadata["PixelHeight"] ?? "")",
            "DPIWidth : \(metadata["DPIWidth"] ?? "")",
            "DPIHeight : \(metadata["DPIHeight"] ?? "")",
            "ColorModel : \(metadata["ColorModel"] ?? "")",
            "Depth : \(metadata["Depth"] ?? "")"
        ]
        
        
        if let tiffData = metadata["{TIFF}"] as? [String : Any],
            let compressionId = tiffData["Compression"] as? Int,
            let compressionType = compressions[compressionId] {
            
            info.append("Compression : \(compressionType)")
        }
        
        return info.joined(separator: "\n")
    }
    
}
/*
 
 */

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
