//
//  GameMenuView.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 12/7/23.
//

import SwiftUI
import UIKit
import SDWebImageSwiftUI

struct GameMenuView: View {
    @ObservedObject var mediaManager: MediaManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedImage(name: "monkeyphone.gif")
                    .ignoresSafeArea()
                VStack {
                    List {
                        NavigationLink {
                            TitleScreenView(mediaManager: mediaManager)
                        } label: {
                            Text("Ball Jump Game")
                        }
                        NavigationLink {
                            FlappyView()
                        } label: {
                            Text("Flappy Dorothy")
                        }
                    }
                    HStack {
                        Button {
                            
                        } label: {
                            AnimatedImage(name: "monkeyhaircut.gif")
                                .resizable()
                                .scaledToFit()
                        }
                        .frame(width: 120)
                        .padding()
                        Spacer()
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Games")
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    GameMenuView(mediaManager: MediaManager())
}
