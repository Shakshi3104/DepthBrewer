//
//  DepthDataProcessor+Extensions-macOS.swift
//  DepthBrewer (macOS)
//
//  Created by MacBook Pro on 2021/11/07.
//

import Foundation
import Cocoa

extension DepthDataProcessor {
    
    // convert AVDepthData.depthDataMap to NSImage
    func nsImage(depthType: DepthType = .depth) -> NSImage {
        // if depth data's NSImage is not nil
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
        
        // Convert AVDepthData.depthDataMap to NSImage
        let normaizedDepthMap = convertedDepthData.depthDataMap.normalize()
        let depthDataImage = normaizedDepthMap.nsImage()
        
        // cache
        switch depthType {
        case .depth:
            self.depthImage = depthDataImage
        case .disparity:
            self.dispariyImage = depthDataImage
        }
        
        return depthDataImage
    }
    
    // save depth data image to ...
    func save(depthType: DepthType = .depth) {
        print("Not implemented yet.")
    }
    
}
