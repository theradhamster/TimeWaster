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
            GameMenuView(mediaManager: MediaManager())
                .tabItem {
                    Label("Games", systemImage: "brain.head.profile")
                }
            SocialView(mediaManager: MediaManager())
                .tabItem {
                    Label("Dorothy Network", systemImage: "figure.walk")
                }
        }
    }
}

#Preview {
    ContentView()
}
