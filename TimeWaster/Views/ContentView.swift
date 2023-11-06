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
            GifView(viewModel: ViewModel())
                .tabItem {
                    Label("Fun", systemImage: "house")
                }
            TitleScreenView()
                .tabItem {
                    Label("Bounce Game", systemImage: "house")
                }
        }
    }
}

#Preview {
    ContentView()
}
