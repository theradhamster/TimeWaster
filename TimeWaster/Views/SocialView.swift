//
//  SocialView.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/14/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct SocialView: View {
    @State private var username = ""
    @State private var text = ""
    @State private var posts = [Post]()
    @State private var showingPostAlert = false
    @State private var isAnimating = true
    
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
                    VStack {
                        ForEach(posts) { post in
                                HStack {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(post.username)
                                                .font(.custom("CHILLER", size: 20))
                                                .foregroundStyle(.gray)
                                        }
                                        Text(post.text)
                                            .font(.custom("PAPYRUS", size: 28))
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(.ultraThinMaterial)
                                }
                                .padding()
                        }
                    }
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
                    VStack {
                        List {
                            TextField("Username", text: $username)
                                .padding()
                            TextField("Type something...", text: $text)
                                .padding()
                        }
                        HStack {
                            Button("Cancel") {
                                showingPostAlert.toggle()
                            }
                            .padding()
                            Button("Post") {
                                let newPost = Post(username: username, text: text)
                                Task {
                                    do {
                                        try await CloudKitService.save(newPost)
                                        posts.append(newPost)
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                                showingPostAlert.toggle()
                            }
                            .padding()
                        }
                    }
                }
            }
            .toolbarBackground(.hidden, for: .bottomBar)
        }
        .onAppear {
            Task {
                do {
                    let posts = try await CloudKitService.fetch()
                    self.posts = posts
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    SocialView()
}
