//
//  NSImage+Extensions.swift
//  DepthBrewer (macOS)
//
//  Created by MacBook Pro M1 on 2021/11/09.
//

import Foundation
import AppKit

// https://zenn.dev/link/comments/87ff25f41f8cea
extension NSImage {
    func saveFile(at url: URL, fileName: String, fileType: NSBitmapImageRep.FileType) {
        guard let data = self.tiffRepresentation,
              let bitmapRep = NSBitmapImageRep(data: data),
              let imageData = bitmapRep.representation(using: fileType, properties: [:])
        else { return }
        
        let fileExtension: String
        switch fileType {
        case .tiff: fileExtension = "tiff"
        case .bmp: fileExtension = "bmp"
        case .gif: fileExtension = "gif"
        case .jpeg: fileExtension = "jpg"
        case .png: fileExtension = "png"
        case .jpeg2000: fileExtension = "jp2"
        @unknown default: fileExtension = ""
        }
        
        var saveURL = url.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
        var cnt = 2
        while FileManager.default.fileExists(atPath: saveURL.path) {
            saveURL = url.appendingPathComponent("\(fileName) \(cnt)").appendingPathExtension(fileExtension)
            cnt += 1
        }
        try? imageData.write(to: saveURL, options: .atomic)
    }
    
    func savePanel(fileName: String, fileType: NSBitmapImageRep.FileType) {
        guard let data = self.tiffRepresentation,
              let bitmapRep = NSBitmapImageRep(data: data),
              let imageData = bitmapRep.representation(using: fileType, properties: [:])
        else { return }
        
        let fileExtension: String
        switch fileType {
        case .tiff: fileExtension = "tiff"
        case .bmp: fileExtension = "bmp"
        case .gif: fileExtension = "gif"
        case .jpeg: fileExtension = "jpg"
        case .png: fileExtension = "png"
        case .jpeg2000: fileExtension = "jp2"
        @unknown default: fileExtension = ""
        }
        
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        savePanel.showsTagField = false
        savePanel.isExtensionHidden = false
        savePanel.nameFieldStringValue = "\(fileName).\(fileExtension)"
        savePanel.begin { result in
            if result == .OK {
                guard let saveFileURL = savePanel.url else { return }
                
                try? imageData.write(to: saveFileURL)
            }
        }
    }
}
