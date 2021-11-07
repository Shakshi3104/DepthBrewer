//
//  DepthBrewContentView.swift
//  DepthBrewer (macOS)
//
//  Created by MacBook Pro on 2021/11/07.
//

import SwiftUI

struct DepthBrewContentView: View {
    /// original image
    @State private var image: NSImage?
    /// depth data image
    @State private var depthDataImage: NSImage?
    
    /// depth data processor
    @State private var depthDataProcessor: DepthDataProcessor?
    
    // depth data availability status
    @State private var isDepthDataAvailable = false
    
    @State private var depthTypeSelection = 0
    
    var body: some View {
        VStack {
            HStack {
                if let image = image {
                    Image(nsImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 200)
                        .padding()
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
                        Text("Drop here")
                    }
                        .frame(minWidth: 200, minHeight: 200)
                        .padding()
                }
                
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
                Button {
                    // brew depth data image
                } label: {
                    Image(systemName: "arrowtriangle.right.fill")
                }
                .disabled(!isDepthDataAvailable)
            }
            
            // Select the depth type
            ToolbarItemGroup(placement: .confirmationAction) {
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
            
            // Save the depth data image
            ToolbarItem(placement: .primaryAction) {
                Button {
                    // save depth data image
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
}

struct DepthBrewContentView_Previews: PreviewProvider {
    static var previews: some View {
        DepthBrewContentView()
            .frame(width: 600, height: 400, alignment: .center)
    }
}
