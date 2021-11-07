//
//  AVDepthData+Extensions-macOS.swift
//  DepthBrewer (macOS)
//
//  Created by MacBook Pro on 2021/11/07.
//

import Foundation
import AVFoundation
import CoreImage

extension AVDepthData {
    // load AVDepthData? from URL via CIImage
    static func fromURL(_ url: URL) -> AVDepthData? {
        let ciImage = CIImage(contentsOf: url,
                              options: [CIImageOption.auxiliaryDepth: true,
                                        CIImageOption.applyOrientationProperty: true])
        
        guard let ciImage = ciImage else { return nil }
        
        let exifDictionary = ciImage.properties
        print(exifDictionary)
        
        return ciImage.depthData
    }
    
    // load AVDepthData? from Data via CIImage
    static func fromData(_ data: Data) -> AVDepthData? {
        let ciImage = CIImage(data: data,
                              options: [CIImageOption.auxiliaryDepth: true,
                                        CIImageOption.applyOrientationProperty: true])
        guard let ciImage = ciImage else { return nil }
        
        let exifDictionary = ciImage.properties
        print(exifDictionary)
        
        return ciImage.depthData
    }
}
