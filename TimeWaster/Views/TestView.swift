//
//  TestView.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/10/23.
//

import SwiftUI

struct TestView: View {
    @State private var username = ""
    @State private var text = ""
    @State private var posts = [Post]()
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
            TextField("Post", text: $text)
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
            }
            List(posts) { post in
                VStack {
                    Text(post.username)
                    Text(post.text)
                }
            }
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
        .padding()
    }
}

#Preview {
    TestView()
}
