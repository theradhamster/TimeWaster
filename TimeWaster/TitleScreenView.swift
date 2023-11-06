//
//  TitleScreenView.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/5/23.
//

import SwiftUI

struct TitleScreenView: View {
    @State var showingGame = false
    @State var showingInstructions = false
    
    var body: some View {
        ZStack {
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
                    Text("Swipe left and right to bounce from platform to platform.\n\nIf the ball falls, exit and reopen the game to start again.\n\nIf the game opens and there are no platforms, reopen the game.")
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
    TitleScreenView()
}
