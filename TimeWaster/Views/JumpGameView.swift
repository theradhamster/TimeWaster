//
//  JumpGameView.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/5/23.
//

import SwiftUI
import SceneKit

struct JumpGameView: View {
    @ObservedObject var game: JumpGame
    @Binding var showing: Bool
    var sceneRendererDelegate = SceneRendererDelegate()
    
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
            SceneView(scene: game.scene, options: [.temporalAntialiasingEnabled], delegate: sceneRendererDelegate)
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
                GameOverView(game: JumpGame())
            }
        }
        .onDisappear(perform: {
            sceneRendererDelegate.onEachFrame = nil
        })
        .onAppear(perform: {
            sceneRendererDelegate.onEachFrame = game.onEachFrame
        })
    }
}

#Preview {
    JumpGameView(game: JumpGame(), showing: TitleScreenView().$showingGame)
}
