//
//  JumpGameView.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/5/23.
//

import SwiftUI
import SceneKit
import PhotosUI

struct JumpGameView: View {
    @ObservedObject var game: JumpGame
    @Binding var showing: Bool
    
    var body: some View {
        let drag = DragGesture()
            .onChanged({ gesture in
                let horizontalTranslation = gesture.translation.width
                game.onControlChange(newValue: horizontalTranslation)
            })
            .onEnded { gesture in
                game.onControlEnd()
            }
        ZStack {
            SceneView(scene: game.scene, options: [.temporalAntialiasingEnabled], delegate: game.sceneRendererDelegate)
                .gesture(drag)
                .ignoresSafeArea()
            VStack {
                HStack(alignment: .top) {
                    Button {
                        withAnimation {
                            showing.toggle()
                        }
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .font(.title2)
                    .buttonStyle(MaterialButtonStyle())
                    Spacer()
                    Button {
                    } label: {
                        Text("Score \(game.score)")
                    }
                    .font(.title2)
                    .buttonStyle(MaterialButtonStyle())
                    .disabled(true)
                }
                Spacer()
            }
                .padding()
            if game.gameOver {
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
                    Button("Play Again?") {
                    }
                    .buttonStyle(MaterialButtonStyle())
                    .padding(.bottom)
                    HStack {
                        Button("Yes") {
                            game.doNewGame()
                        }
                        .buttonStyle(YesButton())
                        Button("No") {
                            withAnimation {
                                showing = false
                            }
                        }
                        .buttonStyle(NoButton())
                    }
                }
            }
        }
        .onDisappear(perform: {
            game.sceneRendererDelegate.onEachFrame = nil
        })
        .onAppear(perform: {
            game.sceneRendererDelegate.onEachFrame = game.onEachFrame
        })
    }
}

#Preview {
    JumpGameView(game: JumpGame(), showing: TitleScreenView(mediaManager: MediaManager()).$showingGame)
}
