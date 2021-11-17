//
//  DepthBrewView-iOS.swift
//  DepthBrewer (iOS)
//
//  Created by MacBook Pro on 2021/11/07.
//

import SwiftUI
import PhotosUI
import Espresso

struct DepthBrewView_iOS: View {
    /// original image
    @State private var image: UIImage?
    /// depth data
    @State private var depthData: AVDepthData?
    /// depth data image
    @State private var depthDataImage: UIImage?
    
    // depth data availability status
    @State private var isDepthDataAvailable = false
    
    @State private var isPresented = false
    
    /// depth data processor
    @State private var depthDataProcessor: DepthDataProcessor?
    
    // for tool button's color
    @State private var depthTypeSelection: DepthType = .depth
    @State private var isCleared = true
    
    // configuration for PHPickerViewController
    private var configuration: PHPickerConfiguration {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.selectionLimit = 1
        config.preferredAssetRepresentationMode = .current
        return config
    }
    
    private let iconSize: CGFloat = 20
    private let iconPadding: CGFloat = 5
    
    var body: some View {
        VStack {
            HStack {
                // MARK: - Tool buttons
                // brew depth image
                Button {
                    isCleared = false
                    depthTypeSelection = .depth
                    brewDepthDataImage(.depth)
                } label: {
                    Image(systemName: "squareshape.squareshape.dashed")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20, alignment: .center)
                        .tint(!isCleared && depthTypeSelection == .depth ? .yellow : .primary)
                        .padding(.horizontal, 5)
                }
                .disabled(!isDepthDataAvailable)
                
                // brew disparity image
                Button {
                    isCleared = false
                    depthTypeSelection = .disparity
                    brewDepthDataImage(.disparity)
                } label: {
                    Image(systemName: "square.on.square.dashed")
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconSize, height: iconSize, alignment: .center)
                        .tint(!isCleared && depthTypeSelection == .disparity ? .yellow : .primary)
                        .padding(.horizontal, iconPadding)
                }
                .disabled(!isDepthDataAvailable)
                
                Spacer()
                
                // clean to display a depth image
                Button {
                    isCleared = true
                    depthDataImage = nil
                } label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconSize, height: iconSize, alignment: .center)
                        .tint(.red)
                        .padding(.horizontal, iconPadding)
                }
                .disabled(depthDataImage == nil)
                
                // pick a photo
                Button {
                    isPresented.toggle()
                } label: {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconSize, height: iconSize, alignment: .center)
                        .tint(.primary)
                        .padding(.horizontal, iconPadding)
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 10)
            
            Spacer()
            
            // MARK: - Display image
            // Depth Data Image
            if let image = depthDataImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .edgesIgnoringSafeArea(.all)
                    .contextMenu {
                        Button {
                            // Save the depth data image
                            if let depthDataImage = depthDataImage {
                                UIImageWriteToSavedPhotosAlbum(depthDataImage, nil, nil, nil)
                            }
                        } label: {
                            HStack {
                                Image(systemName: "square.and.arrow.down")
                                Text("Save")
                            }
                        }
                    }
            }
            // Original Image
            else if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        // For the app is lanched initiality
                        isDepthDataAvailable = depthData != nil
                    }
            } else {
                Image(uiImage: UIImage())
                    .resizable()
                    .scaledToFit()
                    .edgesIgnoringSafeArea(.all)
            }
            
            Spacer()
        }
        .sheet(isPresented: $isPresented) {
            // onDismiss
            depthDataImage = nil
            depthDataProcessor = nil
            isDepthDataAvailable = depthData != nil
            print("🎛 isDepthDataAvailable = \(isDepthDataAvailable)")
        } content: {
            PhotoPicker(
                configuration: configuration,
                pickeredImage: $image,
                pickeredImageDepthData: $depthData,
                isPresented: $isPresented
            )
        }
    }
    
    // MARK: - Brew depth data image
    private func brewDepthDataImage(_ depthType: DepthType) {
        // init DepthDataBrewer
        if let depthData = depthData, depthDataProcessor == nil {
            depthDataProcessor = DepthDataProcessor(depthData)
        }
        
        // brew depth data image
        if let orientation = image?.imageOrientation {
            depthDataImage = depthDataProcessor?.uiImage(orientation: orientation, depthType: depthType)
        }
    }
}

struct DepthBrewView_iOS_Previews: PreviewProvider {
    static var previews: some View {
        DepthBrewView_iOS()
    }
}
