//
//  PostDetailView.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/16/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: CKViewModel
    @State private var username = ""
    @State private var text = ""
    @State private var didFail = false
    @State private var errorTitle: String = ""
    @State var makeCommentAlert = false
    let post: Post
    
    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedImage(name: "turtletouch.gif")
                    .ignoresSafeArea()
                    .opacity(0.4)
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(post.username)
                                    .font(.custom("CHILLER", size: 22))
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
                    }
                    .padding()
                    .foregroundStyle(Color.primary)
                    .background {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.ultraThinMaterial)
                    }
                    .padding()
                    Divider()
                    ScrollView {
                        ForEach(post.comments) { comment in
                            CommentView(viewModel: viewModel, post: post, comment: comment)
                        }
                    }
                    .refreshable {
                        await viewModel.reload()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            makeCommentAlert.toggle()
                        } label: {
                            Image(systemName: "plus.bubble.fill")
                        }
                        .sheet(isPresented: $makeCommentAlert) {
                            CommentCreationView(viewModel: viewModel, makeCommentAlert: $makeCommentAlert, post: post)
                        }
                    }
                }
                .task {
                    await viewModel.reload()
                }
                .alert(errorTitle, isPresented: $didFail) {
                    Button("OK") {
                        dismiss()
                    }
                }
            }
        }
    }
}

//#Preview {
//    PostDetailView(viewModel: CKViewModel(), post: Post(username: "dorothy", text: "hi"))
//}
