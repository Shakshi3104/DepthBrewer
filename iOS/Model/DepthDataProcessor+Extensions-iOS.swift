//
//  DepthDataProcessor+Extensions-iOS.swift
//  DepthBrewer (iOS)
//
//  Created by MacBook Pro on 2021/11/07.
//

import Foundation
import UIKit
import AVFoundation

extension DepthDataProcessor {
    
    // convert AVDepthData.depthDataMap to UIImage?
    func uiImage(orientation: UIImage.Orientation, depthType: DepthType = .depth) -> UIImage? {
        // if depth data's UIImage is not nil
        if depthType == .depth && depthImage != nil {
            print("🎛 depth cache")
            return depthImage
        }
        
        if depthType == .disparity && dispariyImage != nil {
            print("🎛 disparity cache")
            return dispariyImage
        }
        
        // MARK: -
        var convertedDepthData: AVDepthData
        
        // Convert AVDepthData as `depthType`
        switch depthType {
        case .depth:
            convertedDepthData = depthData.asDepthFloat32
        case .disparity:
            convertedDepthData = depthData.asDisparityFloat32
        }
        
        // Convert AVDepthData.depthDataMap to UIImage
        let normaizedDepthMap = convertedDepthData.depthDataMap.normalize()
        let depthDataImage = normaizedDepthMap.uiImage(orientation: orientation)
        
        // cache
        switch depthType {
        case .depth:
            self.depthImage = depthDataImage
        case .disparity:
            self.dispariyImage = depthDataImage
        }
        
        return depthDataImage
    }
    
    // save depth data image to photo library
    func saveToPhotoLibrary(depthType: DepthType = .depth) {
        var uiImage: UIImage?
        
        switch depthType {
        case .depth:
            uiImage = depthImage
        case .disparity:
            uiImage = dispariyImage
        }
        
        guard let uiImage = uiImage else {
            print("🎛 No depth data image")
            return
        }
        
        // write to photo library
        UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
    }
}
