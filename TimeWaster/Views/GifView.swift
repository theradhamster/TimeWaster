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
    @State private var animationAmount = 0.0
    @State private var location = CGPoint.zero
    @State private var isShowingEye = false
    @State private var showVideo = false
    @State private var societyCount = 0
    
    var body: some View {
        NavigationView {
            GeometryReader { geometryProxy in
                ZStack {
                    AnimatedImage(name: "screamingcrying.gif")
                        .ignoresSafeArea()
                    AnimatedImage(name: "jermabounce.gif")
                        .ignoresSafeArea()
                        .rotation3DEffect(.degrees(animationAmount), axis: (x: 0.0, y: 1.0, z: 0.0))
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
                    ZStack {
                        ForEach((0..<societyCount * Int.random(in: 1...5)), id: \.self) { _ in
                            Text("we live in a society")
                                .foregroundStyle(Color.white)
                                .offset(x: CGFloat((-200...200).randomElement()!), y: CGFloat((-500...500).randomElement()!))
                                .rotationEffect(Angle(degrees: Double((0...360).randomElement()!)))
                                .font([.headline, .caption, .largeTitle, .title, .title2, .title3].randomElement()!)
                                .fontWeight([.black, .bold, .heavy, .light, .medium, .ultraLight].randomElement()!)
                        }
                    }
                    VStack {
                            Button {
                                mediaManager.playSound(for: .speen)
                            } label: {
                                AnimatedImage(name: "gorillaspeen.gif")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 130)
                                    .rotation3DEffect(.degrees(animationAmount), axis: (x: 0.0, y: 1.5, z: 0.0))
                            }
                        HStack {
                            Button {
                                mediaManager.playSound(for: .teachernoise)
                                societyCount += 1
                            } label: {
                                AnimatedImage(name: "jermaintimidate.gif")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 200, height: 200)
                                    .clipShape(Circle())
                                    .rotationEffect(.degrees(animationAmount))
                            }
                            Spacer()
                            Button {
                                mediaManager.playSound(for: .bensounds)
                            } label: {
                                AnimatedImage(name: "stewie.gif")
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
                        }
                        VStack {
                            HStack {
                                Button {
                                        mediaManager.playSound(for: .buddyhollylick)
                                } label: {
                                    AnimatedImage(name: "steve.gif")
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
                            HStack {
                                Spacer()
                                Button {
                                    mediaManager.playSound(for: .augh)
                                } label: {
                                    Image("thom")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 90, height: 90)
                                        .clipShape(Heart())
                                }
                                .padding()
                            }
                        }
                        Spacer()
                        Button {
                            showVideo.toggle()
                        } label: {
                            AnimatedImage(name: "angrydog.gif")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200)
                        }
                        .popover(isPresented: $showVideo) {
                            PlayerView(videoFile: MediaManager.VideoFile.careatsshoe.rawValue)
                                .frame(width: 200, height: 200)
                                .presentationCompactAdaptation(.popover)
                        }
                        HStack {
                            Button {
                                mediaManager.playSound(for: .chipmunklaugh)
                            } label: {
                                AnimatedImage(name: "monkeypee.gif")
                                    .resizable()
                                    .scaledToFit()
                                    .rotation3DEffect(.degrees(animationAmount), axis: (x: 0.0, y: 6.0, z: 6.0))
                            }
                            .padding()
                            Spacer()
                            Button {
                                mediaManager.playSound(for: .jesse)
                            } label: {
                                AnimatedImage(name: "jermaburger.gif")
                                    .resizable()
                                    .scaledToFit()
                                    .rotation3DEffect(.degrees(animationAmount), axis: (x: 20.0, y: 0.0, z: 0.0))
                            }
                            .padding()
                        }
                    }
                }
            }
        }
    }
    
    func showEye() {
        self.isShowingEye = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isShowingEye = false
        }
    }
    
}

#Preview {
    GifView(mediaManager: MediaManager())
}
