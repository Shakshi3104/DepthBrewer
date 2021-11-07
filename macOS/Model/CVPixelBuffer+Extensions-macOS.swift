//
//  CVPixelBuffer+Extensions-macOS.swift
//  DepthBrewer (macOS)
//
//  Created by MacBook Pro on 2021/11/07.
//

import Foundation
import CoreVideo
import CoreImage
import Cocoa

extension CVPixelBuffer {
    // convert CVPixelBuffer to NSImage
    func nsImage() -> NSImage {
        let ciImage = CIImage(cvPixelBuffer: self)
        let rep = NSCIImageRep(ciImage: ciImage)
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        return nsImage
    }
}
