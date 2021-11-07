//
//  AVDepthData+Extensions.swift
//  DepthBrewer
//
//  Created by MacBook Pro on 2021/11/07.
//

import Foundation
import AVFoundation

extension AVDepthData {
    // convert to AVDepthData (kCVPixelFormatType_DisparityFloat32)
    var asDisparityFloat32: AVDepthData {
        var convertedDepthData: AVDepthData
        
        if self.depthDataType != kCVPixelFormatType_DisparityFloat32 {
            convertedDepthData = self.converting(toDepthDataType: kCVPixelFormatType_DisparityFloat32)
        } else {
            convertedDepthData = self
        }
        
        return convertedDepthData
    }
    
    // convert to AVDepthData (kCVPixelFormatType_DepthFloat32)
    var asDepthFloat32: AVDepthData {
        var convertedDepthData: AVDepthData
        
        if self.depthDataType != kCVPixelFormatType_DepthFloat32 {
            convertedDepthData = self.converting(toDepthDataType: kCVPixelFormatType_DepthFloat32)
        } else {
            convertedDepthData = self
        }
        
        return convertedDepthData
    }
}
