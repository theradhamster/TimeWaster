//
//  SocialView.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/14/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct SocialView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var mediaManager: MediaManager
    @StateObject var viewModel = CKViewModel()
    @State private var username = ""
    @State private var text = ""
    @State private var reactions = [Reaction]()
    @State var showingPostAlert = false
    @State private var isAnimating = true
    @State private var didFail = false
    @State private var errorTitle: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("jerma1")
                    .resizable()
                    .ignoresSafeArea()
                    .opacity(0.3)
                AnimatedImage(name: "roll.gif", isAnimating: $isAnimating)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .opacity(0.6)
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.posts) { post in
                            NavigationLink(destination: PostDetailView(viewModel: viewModel, post: post)) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(post.username)
                                                .font(.custom("Minecraft", size: 22))
                                                .foregroundStyle(.gray)
                                            Text(post.creationDate.formatted())
                                                .font(.custom("CHILLER", size: 22))
                                                .foregroundStyle(.gray)
                                        }
                                        Text(post.text)
                                            .font(.custom("PAPYRUS", size: 28))
                                            .foregroundStyle(.primary)
                                            .multilineTextAlignment(.leading)
                                        if let media = post.media {
                                            Image(uiImage: media)
                                                .resizable()
                                                .scaledToFit()
                                        }
                                        ScrollView(.horizontal) {
                                            HStack {
                                                ReactionView(viewModel: viewModel, post: post)
                                            }
                                        }
                                    }
                                    Spacer()
                                    VStack {
                                        Image(systemName: "bubble.left")
                                            .font(.title2)
                                            .foregroundStyle(.gray)
                                        Text("\(post.comments.count)")
                                            .foregroundStyle(.gray)
                                    }
                                }
                                .foregroundStyle(Color.primary)
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(.ultraThinMaterial)
                                }
                                .padding()
                            }
                        }
                    }
                }
                .refreshable {
                    await viewModel.reload()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        HStack {
                            Text("Dorothy Network")
                                .font(.custom("PAPYRUS", size: 34))
                            Spacer()
                                Image("me")
                                    .resizable()
                                    .frame(width: 80, height: 40)
                                //.rotation3DEffect(.degrees(360), axis: (x: 0.0, y: 0.0, z: 1.0))
                        }
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            showingPostAlert.toggle()
                        } label: {
                            Image(systemName: "rectangle.and.pencil.and.ellipsis")
                        }
                    }
                }
                .sheet(isPresented: $showingPostAlert) {
                    PostCreationView(viewModel: viewModel, showingPostAlert: $showingPostAlert)
                }
            }
            .toolbarBackground(.hidden, for: .bottomBar)
        }
        .task {
            await viewModel.reload()
            mediaManager.playSound(for: .fnafambience)
        }
        .alert(errorTitle, isPresented: $didFail) {
            Button("OK") {
                dismiss()
            }
        }
    }
}

#Preview {
    SocialView(mediaManager: MediaManager())
}
