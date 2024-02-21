//
//  TitleScreenView.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/5/23.
//

import SwiftUI

struct TitleScreenView: View {
    @ObservedObject var mediaManager: MediaManager
    @State var showingGame = false // ask yourself "is this related to how the view is presented (it should live in your view layer) or is it related to how the game functions (it should like in your viewmodel layer)
        // if the game showing is ALWAYS tied to some condition in your game. make it a computed property based on those parameters in your game
    @State var showingInstructions = false // ask yourself "is this related to how the view is presented (it should live in your view layer) or is it related to how the game functions (it should like in your viewmodel layer)
    @State private var animationAmount = 0.0
    
    var body: some View {
        ZStack {
            Image("uh oh stinky")
                .resizable()
                .rotationEffect(.degrees(animationAmount))
                .rotation3DEffect(.degrees(animationAmount), axis: (x: 0.7, y: 2.0, z: 0.5))
                .onAppear {
                    withAnimation(.linear(duration: 0.1)
                        .speed(0.02).repeatForever(autoreverses: false)) {
                            animationAmount = 360.0
                        }
                }
            VStack {
                Spacer()
                Button {
                    withAnimation {
                        showingGame.toggle()
                    }
                } label: {
                    Text("Play")
                }
                .font(.largeTitle)
                .buttonStyle(MaterialButtonStyle())
                .padding()
                Button {
                    showingInstructions.toggle()
                } label: {
                    Text("How to Play")
                }
                .font(.title3)
                .buttonStyle(MaterialButtonStyle())
                .padding()
                NavigationLink {
                    GameMenuView(mediaManager: mediaManager)
                } label: {
                    Text("Menu")
                }
                .font(.title3)
                .buttonStyle(MaterialButtonStyle())
                Spacer()
                    .sheet(isPresented: $showingInstructions) {
                        Text("Swipe left and right to bounce from platform to platform.\n\nIf the game opens and there are no platforms, reopen the game.")
                            .padding()
                    }
            }
            if showingGame {
                JumpGameView(game: JumpGame(), showing: $showingGame)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TitleScreenView(mediaManager: MediaManager())
}
