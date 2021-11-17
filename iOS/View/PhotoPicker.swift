//
//  PhotoPicker.swift
//  DepthBrewer (iOS)
//
//  Created by MacBook Pro on 2021/11/07.
//

import Foundation
import SwiftUI
import PhotosUI
import Espresso

// MARK: - PhotoPicker: Wrapper of PHPickerViewController
// https://qiita.com/lcr/items/f9e98f76a48af0920bb1
struct PhotoPicker: UIViewControllerRepresentable {
    let configuration: PHPickerConfiguration
    @Binding var pickeredImage: UIImage?
    @Binding var pickeredImageDepthData: AVDepthData?
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> PHPickerViewController {
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - PHPickerViewControllerDelegate -> Coordinator
    class Coordinator: PHPickerViewControllerDelegate {
        private let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // MARK: Get AVDepthData from CIImage by PHAsset
            // https://www.fixes.pub/program/198512.html
            // https://stackoverflow.com/questions/62625797/how-to-retrieve-phasset-from-phpicker
            let identifiers = results.compactMap(\.assetIdentifier)
            let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
            
            let firstObject = fetchResult.firstObject
            if let firstObject = firstObject {
                // https://developer.apple.com/documentation/photokit/phasset/1624775-mediasubtypes
                if firstObject.mediaSubtypes != .photoDepthEffect {
                    return
                }
                
                print("🎛 This image's mediaSubtypes is photoDepthEffect.")
                
                firstObject.requestContentEditingInput(with: nil) { contentEditingInput, _ in
                    guard let inputURL = contentEditingInput?.fullSizeImageURL else { return }
                    
                    print("🎛 URL from PHAsset: \(inputURL)")
                    
                    let depthData = AVDepthData.fromURL(inputURL)
                    
                    if let depthData = depthData {
                        print(depthData)
                        self.parent.pickeredImageDepthData = depthData
                    } else {
                        print("🎛 No depth data.")
                    }
                }
            }
            
            // MARK: Get UIImage
            for image in results {
                image.itemProvider.loadObject(ofClass: UIImage.self) { selectedImage, error in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                        return
                    }

                    guard let selectedImage = selectedImage as? UIImage else {
                        print("UIImage wrap error")
                        return
                    }

                    DispatchQueue.main.async {
                        self.parent.pickeredImage = selectedImage
                    }
                }
                
//                image.itemProvider.loadFileRepresentation(forTypeIdentifier: "public.item") { url, error in
//                    if let error = error {
//                        print("error: \(error.localizedDescription)")
//                    }
//
//                    guard let selectedImageURL = url else {
//                        print("URL wrap error")
//                        return
//                    }
//
//                    print("🎛 URL: \(selectedImageURL)")
//                }
            }
            
            // dismiss PhotoPicker
            parent.isPresented = false
        }
    }
}
