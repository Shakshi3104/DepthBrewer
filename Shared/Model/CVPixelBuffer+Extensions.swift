//
//  CVPixelBuffer+Extensions.swift
//  DepthBrewer
//
//  Created by MacBook Pro on 2021/11/07.
//

import Foundation
import CoreVideo

extension CVPixelBuffer {
    // normalize CVPixelBuffer
    func normalize() -> CVPixelBuffer {
        let cvPixelBuffer = self
        
        let width = CVPixelBufferGetWidth(cvPixelBuffer)
        let height = CVPixelBufferGetHeight(cvPixelBuffer)
        
        CVPixelBufferLockBaseAddress(cvPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let floatBuffer = unsafeBitCast(CVPixelBufferGetBaseAddress(cvPixelBuffer), to: UnsafeMutablePointer<Float>.self)
        
        var minPixel: Float = 1.0
        var maxPixel: Float = 0.0
        
        for y in stride(from: 0, to: height, by: 1) {
          for x in stride(from: 0, to: width, by: 1) {
            let pixel = floatBuffer[y * width + x]
            minPixel = min(pixel, minPixel)
            maxPixel = max(pixel, maxPixel)
          }
        }
        
        let range = maxPixel - minPixel
        for y in stride(from: 0, to: height, by: 1) {
          for x in stride(from: 0, to: width, by: 1) {
            let pixel = floatBuffer[y * width + x]
            floatBuffer[y * width + x] = (pixel - minPixel) / range
          }
        }
        
        CVPixelBufferUnlockBaseAddress(cvPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        return cvPixelBuffer
    }
}
