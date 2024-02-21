//
//  WeezerView.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/14/23.
//

import SwiftUI
import SDWebImageSwiftUI
import AVKit

struct WeezerView: View {
    @ObservedObject var mediaManager: MediaManager
    
    var body: some View {
        ZStack {
            AnimatedImage(name: "riversdance.gif")
                .resizable()
                .ignoresSafeArea()
            VStack {
                    AnimatedImage(name: "brianchokesontoast.gif")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                Spacer()
                List {
                    Section {
                        Button("The World Has Turned And Left Me Here") {
                            mediaManager.playSound(for: .theworldhasturned)
                        }
                        .listRowBackground(Color.white.opacity(0.7))
                        Button("Only In Dreams") {
                            mediaManager.playSound(for: .onlyindreams)
                        }
                        .listRowBackground(Color.white.opacity(0.7))
                        Button("Falling For You") {
                            mediaManager.playSound(for: .fallingforyou)
                        }
                        .listRowBackground(Color.white.opacity(0.7))
                        Button("Smile") {
                            mediaManager.playSound(for: .smile)
                        }
                        .listRowBackground(Color.white.opacity(0.7))
                        Button("Take Control") {
                            mediaManager.playSound(for: .takecontrol)
                        }
                        .listRowBackground(Color.white.opacity(0.7))
                        Button("Slave") {
                            mediaManager.playSound(for: .slave)
                        }
                        .listRowBackground(Color.white.opacity(0.7))
                        Button("California Kids") {
                            mediaManager.playSound(for: .californiakids)
                        }
                        .listRowBackground(Color.white.opacity(0.7))
                    } header: {
                        Text("Dorothy's Favorite Weezer Songs")
                            .foregroundStyle(.black)
                    }
                }
                .scrollContentBackground(.hidden)
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.white.opacity(0.7))
                        .frame(width: 100, height: 50)
                HStack(alignment: .center) {
                        Button {
                            mediaManager.resumeSound()
                        } label: {
                            Image(systemName: "play.fill")
                        }
                        .padding(.horizontal)
                        Button {
                            mediaManager.pauseSound()
                        } label: {
                            Image(systemName: "pause.fill")
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

#Preview {
    WeezerView(mediaManager: MediaManager())
}
