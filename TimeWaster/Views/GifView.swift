//
//  GifView.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/5/23.
//

import SwiftUI
import SDWebImageSwiftUI
import AVFoundation
import AVKit

struct GifView: View {
    @ObservedObject var mediaManager: MediaManager
    @State var isAnimating = true
    @State private var animationAmount = 0.0
    @State private var location = CGPoint.zero
    @State private var isShowingEye = false
    @State private var showVideo = false
    func showEye() {
        self.isShowingEye = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isShowingEye = false
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometryProxy in
                ZStack {
                    AnimatedImage(name: "saulgoodman.gif", isAnimating: $isAnimating)
                        .ignoresSafeArea()
                        .gesture(DragGesture(minimumDistance: 0).onEnded { value in
                            self.location = value.location
                            self.showEye()
                        })
                    if self.isShowingEye {
                        Image("creepyeye")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .position(self.location)
                    }
                    VStack {
                        HStack {
                            Button {
                                mediaManager.playSound(for: .speen)
                            } label: {
                                AnimatedImage(name: "gorillaspeen.gif", isAnimating: $isAnimating)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 130)
                                    .rotation3DEffect(.degrees(animationAmount), axis: (x: 0.0, y: 1.0, z: 0.0))
                            }
                            Spacer()
                            Button {
                                mediaManager.playSound(for: .balloonboy)
                            } label: {
                                AnimatedImage(name: "creepyeye.gif", isAnimating: $isAnimating)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 200, height: 100)
                                    .clipShape(Circle())
                            }
                        }
                        Button {
                            mediaManager.playSound(for: .fart)
                        } label: {
                            Image("areyoustupid")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 160)
                                .rotation3DEffect(.degrees(animationAmount), axis: (x: 3.5, y: 1.5, z: 2.9))
                                .rotationEffect(.degrees(animationAmount))
                                .onAppear {
                                    withAnimation(.linear(duration: 0.09)
                                        .speed(0.04).repeatForever(autoreverses: false)) {
                                            animationAmount = 360.0
                                        }
                                }
                        }
                        HStack {
                            NavigationLink {
                                WeezerView(mediaManager: mediaManager)
                                    .onAppear {
                                        mediaManager.playSound(for: .buddyhollylick)
                                    }
                            } label: {
                                AnimatedImage(name: "riversstare.gif", isAnimating: $isAnimating)
                                    .resizable()
                                    .scaledToFit()
                            }
                            .frame(width: 100, height: 100)
                            .padding()
                            Spacer()
                            Button {
                                mediaManager.playSound(for: .whatthedogdoin)
                            } label: {
                                Image("sabit1")
                                    .resizable()
                                    .frame(width: 100, height: 150)
                            }
                        }
                        Spacer()
                        Button {
                            showVideo.toggle()
                        } label: {
                            Image("soyjak")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200)
                        }
                        .popover(isPresented: $showVideo) {
                            PlayerView(videoFile: MediaManager.VideoFile.careatsshoe.rawValue)
                                .frame(width: 200, height: 200)
                                .presentationCompactAdaptation(.popover)
                        }
                        Button {
                            mediaManager.playSound(for: .chipmunklaugh)
                        } label: {
                            AnimatedImage(name: "thinkingemoji.gif", isAnimating: $isAnimating)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    GifView(mediaManager: MediaManager())
}
