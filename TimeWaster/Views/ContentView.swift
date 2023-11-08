//
//  ContentView.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/5/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            GifView(mediaManager: MediaManager())
                .tabItem {
                    Label("Fun", systemImage: "face.smiling.inverse")
                }
            TitleScreenView()
                .tabItem {
                    Label("Bounce Game", systemImage: "brain.head.profile")
                }
        }
    }
}

#Preview {
    ContentView()
}
