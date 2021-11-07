//
//  DepthDataProcessor.swift
//  DepthBrewer
//
//  Created by MacBook Pro on 2021/11/07.
//

import Foundation
import AVFoundation

// https://qiita.com/codelynx/items/9551d8382f4a47fad6c7
#if os(iOS)
import UIKit
typealias XImage = UIImage
#elseif os(macOS)
import Cocoa
typealias XImage = NSImage
#endif

enum DepthType: CaseIterable {
    case depth
    case disparity
}

// MARK: - DepthDataProcessor: Shared
public class DepthDataProcessor {
    var depthImage: XImage?
    var dispariyImage: XImage?
    
    var depthData: AVDepthData
    
    init(_ depthData: AVDepthData) {
        self.depthData = depthData
    }
}
