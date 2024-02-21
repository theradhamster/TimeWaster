//
//  PostCreationView.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/20/23.
//

import SwiftUI
import CloudKit
import PhotosUI

struct PostCreationView: View {
    @ObservedObject var viewModel: CKViewModel
    @State private var username = ""
    @State private var text = ""
    @State private var media: UIImage?
    @State private var selectedMedia: PhotosPickerItem?
    @State private var errorTitle = ""
    @State private var didFail = false
    @State private var showingImagePicker = false
    @Binding var showingPostAlert: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    TextField("Username", text: $username)
                        .padding()
                    TextField("Type something...", text: $text)
                        .padding()
                    Button("Add Media") {
                        showingImagePicker.toggle()
                    }
                    .padding()
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
                                        try await viewModel.makeNewPost(username: username, text: text, media: self.media)
                                    } else {
                                        try await viewModel.makeNewPost(username: username, text: text)
                                    }
                                } catch {
                                    errorTitle = error.localizedDescription
                                    didFail.toggle()
                                    print(error.localizedDescription)
                                }
                            }
                            showingPostAlert.toggle()
                        }
                    }
                    .disabled(username.isEmpty)
                }
                .scrollContentBackground(.hidden)
            }
            .background {
                ZStack {
                    LinearGradient(colors: [.red, .green, .blue], startPoint: .topTrailing, endPoint: .bottomLeading)
                        .ignoresSafeArea()
                    Image("me")
                        .resizable()
                        .scaledToFit()
                        .opacity(0.1)
                }
                .ignoresSafeArea()
            }
            .navigationTitle("Create New Post")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        showingPostAlert.toggle()
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
                .presentationBackground {
                    Image("me")
                        .resizable()
                        .scaledToFit()
                }
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

#Preview {
    PostCreationView(viewModel: CKViewModel(), showingPostAlert: SocialView(mediaManager: MediaManager()).$showingPostAlert)
}
