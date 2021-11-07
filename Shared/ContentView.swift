//
//  ContentView.swift
//  Shared
//
//  Created by MacBook Pro on 2021/11/07.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        #if os(iOS)
        DepthBrewView_iOS()
        #elseif os(macOS)
        Text("Hello, world!")
            .padding()
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
