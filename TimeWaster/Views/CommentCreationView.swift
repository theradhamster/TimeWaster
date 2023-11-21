//
//  CommentCreationView.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/20/23.
//

import SwiftUI

struct CommentCreationView: View {
    @ObservedObject var viewModel: CKViewModel
    @State private var username = ""
    @State private var text = ""
    @State private var errorTitle = ""
    @State private var didFail = false
    @Binding var makeCommentAlert: Bool
    let post: Post
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    TextField("Username", text: $username)
                        .padding()
                    TextField("Type something...", text: $text)
                        .padding()
                }
                .background {
                    ZStack {
                        Image("me")
                            .resizable()
                            .scaledToFit()
                            .opacity(0.1)
                    }
                    .ignoresSafeArea()
                }
                .scrollContentBackground(.hidden)
                HStack {
                    Button("Cancel") {
                        makeCommentAlert.toggle()
                    }
                    .padding()
                    Button("Post") {
                        Task {
                            do {
                                let comment = Comment(username: username, text: text)
                                try await viewModel.makeNewComment(comment, post: post)
                            } catch {
                                errorTitle = error.localizedDescription
                                didFail.toggle()
                                print(error.localizedDescription)
                            }
                        }
                        makeCommentAlert.toggle()
                    }
                    .padding()
                }
            }
            .navigationTitle("Add New Comment")
        }
    }
}

//#Preview {
//    CommentCreationView(viewModel: CKViewModel(), makeCommentAlert: PostDetailView(viewModel: CKViewModel(), post: Post(username: "dorothy", text: "hi").$makeCommentAlert, post: Post(username: "dorothy", text: "hi"))
//}
