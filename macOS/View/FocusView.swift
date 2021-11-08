//
//  FocusView.swift
//  DepthBrewer (macOS)
//
//  Created by MacBook Pro M1 on 2021/11/08.
//

import Foundation
import SwiftUI
import Cocoa

// https://stackoverflow.com/questions/59919050/how-can-i-display-touch-bar-buttons-using-swiftui
class FocusNSView: NSView {
    override var acceptsFirstResponder: Bool {
        return true
    }
}

struct FocusView: NSViewRepresentable {

    func makeNSView(context: NSViewRepresentableContext<FocusView>) -> FocusNSView {
        return FocusNSView()
    }

    func updateNSView(_ nsView: FocusNSView, context: Context) {

        // Delay making the view the first responder to avoid SwiftUI errors.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if let window = nsView.window {

                // Only set the focus if nothing else is focused.
                if let _ = window.firstResponder as? NSWindow {
                    window.makeFirstResponder(nsView)
                }
            }
        }
    }
}
