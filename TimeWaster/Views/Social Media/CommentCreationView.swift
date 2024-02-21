//
//  CommentCreationView.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/20/23.
//

import SwiftUI
import PhotosUI

struct CommentCreationView: View {
    @ObservedObject var viewModel: CKViewModel
    @State private var username = ""
    @State private var text = ""
    @State private var errorTitle = ""
    @State private var didFail = false
    @State private var showingImagePicker = false
    @State private var media: UIImage?
    @State private var selectedMedia: PhotosPickerItem?
    @Binding var makeCommentAlert: Bool
    let post: Post
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    TextField("Username", text: $username)
                        .padding()
                    TextField("Type something...", text: $text)
                        .padding()
//                    Button("Add Media") {
//                        showingImagePicker.toggle()
//                    }
//                    .padding()
                    if let media {
                        Image(uiImage: media)
                            .resizable()
                            .scaledToFit()
                            .padding()
                    }
                    Section {
                        Button("Post") {
                            Task {
                                do {
                                    if media == media {
                                        let comment = Comment(username: username, text: text, media: self.media)
                                        try await viewModel.makeNewComment(comment, post: post)
                                    } else {
                                        let comment = Comment(username: username, text: text)
                                        try await viewModel.makeNewComment(comment, post: post)
                                    }
                                } catch {
                                    errorTitle = error.localizedDescription
                                    didFail.toggle()
                                    print(error.localizedDescription)
                                }
                            }
                            makeCommentAlert.toggle()
                        }
                    }
                    .disabled(username.isEmpty)
                }
                .scrollContentBackground(.hidden)
                .background {
                    ZStack {
                        Image("me")
                            .resizable()
                            .scaledToFit()
                            .opacity(0.1)
                    }
                    .ignoresSafeArea()
                }
            }
            .navigationTitle("Add New Comment")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        makeCommentAlert.toggle()
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                VStack {
                    PhotosPicker("Select an image", selection: $selectedMedia, matching: .images)
                        .padding()
                    if let media {
                        Image(uiImage: media)
                            .resizable()
                            .scaledToFit()
                            .padding()
                    }
                }
                .presentationDetents([.height(300)])
                .presentationDragIndicator(.visible)
                .presentationBackground(Color.green)
//                ImagePicker(sourceType: .savedPhotosAlbum, selectedImage: self.$media)
            }
            .onChange(of: selectedMedia) { _ in
                Task {
                    if let data = try? await selectedMedia?.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data) {
                            media = uiImage
                        }
                    }
                }
            }
        }
    }
}

//#Preview {
//    CommentCreationView(viewModel: CKViewModel(), makeCommentAlert: PostDetailView(viewModel: CKViewModel(), post: Post(username: "dorothy", text: "hi").$makeCommentAlert, post: Post(username: "dorothy", text: "hi"))
//}
