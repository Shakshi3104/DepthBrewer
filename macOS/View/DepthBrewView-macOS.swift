//
//  DepthBrewView-macOS.swift
//  DepthBrewer (macOS)
//
//  Created by MacBook Pro on 2021/11/07.
//

import SwiftUI

struct DepthBrewView_macOS: View {
    
    @State private var filename: String?
        
    var body: some View {
        NavigationView {
            Group {
                List {
                    Section {
                        Text(filename ?? "No filename")
                    }
                }
                
                DepthBrewContentView(imageFilename: $filename)
            }
        }
    }
}

struct DepthBrewView_macOS_Previews: PreviewProvider {
    static var previews: some View {
        DepthBrewView_macOS()
    }
}
