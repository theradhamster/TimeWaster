//
//  GameOverView.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/5/23.
//

import SwiftUI

struct GameOverView: View {
    @ObservedObject var game: JumpGame
    
    var body: some View {
            VStack {
                Button("Game Over!") {
                }
                .buttonStyle(MaterialButtonStyle())
                .disabled(true)
                Button("Score: \(game.score)") {
                }
                .buttonStyle(MaterialButtonStyle())
                .disabled(true)
                Spacer()
                    .frame(height: 70)
                //                Button("Play Again?") {
                //                }
                //                .buttonStyle(MaterialButtonStyle())
                //                .padding(.bottom)
                //                HStack {
                //                    Button("Yes") {
                //                        //game.doNewGame()
                //                    }
                //                    Button("No") {
                //                        showing = false
                //                    }
                //                }
            }
        }
    }

#Preview {
    GameOverView(game: JumpGame())
}
