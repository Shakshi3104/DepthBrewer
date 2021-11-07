//
//  DepthBrewView-macOS.swift
//  DepthBrewer (macOS)
//
//  Created by MacBook Pro on 2021/11/07.
//

import SwiftUI

struct DepthBrewView_macOS: View {
        
    var body: some View {
        NavigationView {
            Group {
                List {
                    Section {
                        Text("Brew Depth")
                    }
                }
                
                DepthBrewContentView()
            }
        }
    }
}

struct DepthBrewView_macOS_Previews: PreviewProvider {
    static var previews: some View {
        DepthBrewView_macOS()
    }
}
