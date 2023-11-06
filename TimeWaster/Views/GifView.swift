//
//  GifView.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/5/23.
//

import SwiftUI
import SDWebImageSwiftUI
import AVFoundation

struct GifView: View {
    @ObservedObject var viewModel: ViewModel
    @State var isAnimating = true
    @State private var animationAmount = 0.0
    @State private var location = CGPoint.zero
    @State private var isShowingEye = false
    func showEye() {
        self.isShowingEye = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
            self.isShowingEye = false
        }
    }
    
    var body: some View {
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
                        AnimatedImage(name: "gorillaspeen.gif", isAnimating: $isAnimating)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130)
                        Spacer()
                        Button {
                            viewModel.current = viewModel.soundFiles[1]
                            viewModel.playSound()
                        } label: {
                            AnimatedImage(name: "creepyeye.gif", isAnimating: $isAnimating)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 100)
                                .clipShape(Circle())
                        }
                    }
                    Button {
                        viewModel.current = viewModel.soundFiles[2]
                        viewModel.playSound()
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
                    Spacer()
                    Button {
                        viewModel.current = viewModel.soundFiles[0]
                        viewModel.playSound()
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

#Preview {
    GifView(viewModel: ViewModel())
}
