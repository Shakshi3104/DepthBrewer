//
//  DepthBrewContentView.swift
//  DepthBrewer (macOS)
//
//  Created by MacBook Pro on 2021/11/07.
//

import SwiftUI
import UniformTypeIdentifiers
import AVFoundation

struct DepthBrewContentView: View {
    /// original image
    @State private var image: NSImage?
    /// depth data
    @State private var depthData: AVDepthData?
    /// depth data image
    @State private var depthDataImage: NSImage?
    
    /// depth data processor
    @State private var depthDataProcessor: DepthDataProcessor?
    
    // depth data availability status
    @State private var isDepthDataAvailable = false
    
    @State private var depthTypeSelection = 0
    private let depthTypes = DepthType.allCases
    
    @State private var isTargeted = false
    @State private var isPresented = false
    
    var body: some View {
        VStack {
            HStack(spacing: 5) {
                // MARK: - original image
                if let image = image {
                    Image(nsImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 200)
                        .padding()
                        // onDrop
                        .onDrop(of: [.jpeg, .heic, .url, .fileURL],
                                isTargeted: $isTargeted) { providers, cgPoint in
                            processDroppedImage(providers: providers)
                        }
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                Color.primary,
                                style: StrokeStyle(
                                    lineWidth: 1,
                                    dash: [2, 2, 2, 2]
                                )
                            )
                        
                        VStack {
                            Text("Drop here")
                            Text("or")
                            Button {
                                isPresented.toggle()
                            } label: {
                                Text("Open")
                            }
                        }
                    }
                    // MARK: - fileImporter
                    .fileImporter(isPresented: $isPresented, allowedContentTypes: [.heic, .jpeg], onCompletion: { result in
                        switch result {
                        case .success(let url):
                            guard let nsImage = NSImage(contentsOf: url) else { return }
                            image = nsImage
                            
                            depthData = AVDepthData.fromURL(url)
                            isDepthDataAvailable = depthData != nil
                        case .failure:
                            print("failure")
                        }
                    })
                    // MARK: - onDrop (init)
                    .onDrop(of: [.jpeg, .heic, .url, .fileURL],
                            isTargeted: $isTargeted) { providers, cgPoint in
                        processDroppedImage(providers: providers)
                    }
                    .frame(minWidth: 200, minHeight: 200)
                    .padding()
                }
                
                // MARK: - depth data image
                if let depthDataImage = depthDataImage {
                    Image(nsImage: depthDataImage)
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 200)
                        .padding()
                } else {
                    Image(nsImage: NSImage())
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 200)
                        .padding()
                }
            }
        }
        // MARK: -  Touch Bar
        // FIXME: Not displaying buttons on Touch Bar
        .focusable()
        .touchBar {
            runButton
            
            depthTypePicker
            
            saveButton
        }
        // MARK: - Tool Bar
        .toolbar {
            // Close the sidebar
            ToolbarItem(placement: .navigation) {
                Button {
                    // https://sarunw.com/posts/how-to-toggle-sidebar-in-macos/
                    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                } label: {
                    Image(systemName: "sidebar.leading")
                }
            }
            
            // Brew depth data image
            ToolbarItem(placement: .navigation) {
                runButton
            }
            
            // Select the depth type
            ToolbarItemGroup(placement: .confirmationAction) {
                depthTypePicker
            }
            
            // Save the depth data image
            ToolbarItem(placement: .primaryAction) {
                saveButton
            }
        }
    }
    
    // MARK: - Tool Bar Item & Touch Bar Item
    /// Button to brew a depth data image
    private var runButton: some View {
        Button {
            // brew depth data image
            let selectedDeptyType = depthTypes[depthTypeSelection]
            brewDepthDataImage(selectedDeptyType)
        } label: {
            Image(systemName: "arrowtriangle.right.fill")
        }
        .disabled(!isDepthDataAvailable)
    }
    
    /// Picker to select a depth type
    private var depthTypePicker: some View {
        Picker(selection: $depthTypeSelection,
               label: Text("Select the depth type")) {
            Label {
                Text("Depth")
            } icon: {
                Image(systemName: "squareshape.squareshape.dashed")
            }
            .tag(0)

            Label {
                Text("Disparity")
            } icon: {
                Image(systemName: "square.on.square.dashed")
            }
            .tag(1)
        }
               .pickerStyle(SegmentedPickerStyle())
    }
    
    /// Button to save the depth data image
    private var saveButton: some View {
        Button {
            // save depth data image
        } label: {
            Image(systemName: "square.and.arrow.up")
        }
    }
    
    // MARK: -
    // Clean depthData
    private func cleanDepthData() {
        depthData = nil
        depthDataImage = nil
        depthDataProcessor = nil
    }
    
    // MARK: - Process a dropped image
    // https://genjiapp.com/blog/2021/09/06/swiftui-open-file.html
    private func processDroppedImage(providers: [NSItemProvider]) -> Bool {
        cleanDepthData()
        
        guard let provider = providers.first else { return false }
        
        if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
            provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { data, error in
                guard let data = data as? Data,
                      let nsImage = NSImage(data: data)
                else { return }
                image = nsImage
                
                depthData = AVDepthData.fromData(data)
                isDepthDataAvailable = depthData != nil
            }
        }
        else if provider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
            provider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { data, error in
                guard let data = data as? Data,
                      let url = URL(dataRepresentation: data, relativeTo: nil),
                      let nsImage = NSImage(contentsOf: url)
                else { return }
                image = nsImage
                
                depthData = AVDepthData.fromURL(url)
                isDepthDataAvailable = depthData != nil
            }
        }
        
        return true
    }
    
    // MARK: - Brew depth data image
    private func brewDepthDataImage(_ depthType: DepthType) {
        // init DepthDataBrewer
        if let depthData = depthData, depthDataProcessor == nil {
            depthDataProcessor = DepthDataProcessor(depthData)
        }
        
        // brew depth data image
        depthDataImage = depthDataProcessor?.nsImage(depthType: depthType)
    }
}

struct DepthBrewContentView_Previews: PreviewProvider {
    static var previews: some View {
        DepthBrewContentView()
            .frame(width: 600, height: 400, alignment: .center)
    }
}
