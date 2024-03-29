//
//  NSImage+Extensions.swift
//  DepthBrewer (macOS)
//
//  Created by MacBook Pro M1 on 2021/11/09.
//

import Foundation
import AppKit
import UniformTypeIdentifiers

extension NSImage {
    // https://zenn.dev/link/comments/87ff25f41f8cea
    func saveFile(at url: URL, filename: String, fileType: NSBitmapImageRep.FileType) {
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
        
        var saveURL = url.appendingPathComponent(filename).appendingPathExtension(fileExtension)
        var cnt = 2
        while FileManager.default.fileExists(atPath: saveURL.path) {
            saveURL = url.appendingPathComponent("\(filename) \(cnt)").appendingPathExtension(fileExtension)
            cnt += 1
        }
        try? imageData.write(to: saveURL, options: .atomic)
    }
    
    // https://software.small-desk.com/development/2021/01/23/swiftui-image-app-step5/
    func savePanel(filename: String, contentType: UTType = .jpeg) {
        let fileType: NSBitmapImageRep.FileType
        switch contentType {
        case .jpeg: fileType = .jpeg
        case .tiff: fileType = .tiff
        case .bmp: fileType = .bmp
        case .gif: fileType = .jpeg
        case .png: fileType = .png
        default: fileType = .jpeg
        }
        
        guard let data = self.tiffRepresentation,
              let bitmapRep = NSBitmapImageRep(data: data),
              let imageData = bitmapRep.representation(using: fileType, properties: [:])
        else { return }
        
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        savePanel.showsTagField = false
        savePanel.isExtensionHidden = false
        savePanel.nameFieldStringValue = filename
        savePanel.canSelectHiddenExtension = true
        savePanel.allowedContentTypes = [contentType]
        savePanel.begin { result in
            if result == .OK {
                guard let saveFileURL = savePanel.url else { return }
                
                try? imageData.write(to: saveFileURL)
            }
        }
    }
}
