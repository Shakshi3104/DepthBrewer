//
//  CVPixelBuffer+Extensions-iOS.swift
//  DepthBrewer (iOS)
//
//  Created by MacBook Pro on 2021/11/07.
//

import Foundation
import CoreVideo
import CoreImage
import UIKit

extension CVPixelBuffer {
    // convert CVPixelBuffer to UIImage
    func uiImage(orientation: UIImage.Orientation) -> UIImage? {
        let ciImage = CIImage(cvPixelBuffer: self)
        let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent)
        guard let image = cgImage else { return nil }
        let uiImage = UIImage(cgImage: image, scale: 0, orientation: orientation)
        return uiImage
    }
}
