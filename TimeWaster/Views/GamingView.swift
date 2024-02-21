//
//  GamingView.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 12/1/23.
//

import SwiftUI

struct GamingView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    TitleScreenView(mediaManager: MediaManager())
                } label: {
                    Text("Ball Jump Game")
                }
            }
        }
    }
}

#Preview {
    GamingView()
}
