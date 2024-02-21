//
//  FlappyView.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 12/7/23.
//

import SwiftUI
import SpriteKit

struct FlappyView: View {
    var scene: SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: 400, height: 900)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .frame(width: 400, height: 900)
                .ignoresSafeArea()
            VStack {
                HStack {
                    NavigationLink {
                        GameMenuView(mediaManager: MediaManager())
                    } label: {
                        Text("Menu")
                    }
                    .font(.title3)
                    .buttonStyle(MaterialButtonStyle())
                    .padding()
                    Spacer()
                }
                Spacer()
                    .frame(height: 650)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    FlappyView()
}
