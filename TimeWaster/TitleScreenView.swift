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
                    Text("")
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
