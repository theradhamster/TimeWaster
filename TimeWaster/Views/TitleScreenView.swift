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
    
    var body: some View {
        ZStack {
            Button {
                mediaManager.playSound(for: .uhohstinky)
            } label: {
                Image("uh oh stinky")
                    .resizable()
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
    }
}

#Preview {
    TitleScreenView(mediaManager: MediaManager())
}
