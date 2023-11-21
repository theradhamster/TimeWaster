//
//  PostCreationView.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/20/23.
//

import SwiftUI
import CloudKit
import _PhotosUI_SwiftUI

struct PostCreationView: View {
    @ObservedObject var viewModel: CKViewModel
    @State private var username = ""
    @State private var text = ""
    @State private var media = UIImage()
    @State private var errorTitle = ""
    @State private var didFail = false
    @State private var posts = [Post]()
    @State private var showingImagePicker = false
    @Binding var showingPostAlert: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    TextField("Username", text: $username)
                        .padding()
                    TextField("Type something...", text: $text)
                        .padding()
                    Button("Add Media") {
                        showingImagePicker.toggle()
                    }
                    Image(uiImage: self.media)
                        .resizable()
                        .scaledToFit()
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
                        showingPostAlert.toggle()
                    }
                    .padding()
                    Button("Post") {
                        Task {
                            do {
                                try await viewModel.makeNewPost(username: username, text: text, media: self.media)
                            } catch {
                                errorTitle = error.localizedDescription
                                didFail.toggle()
                                print(error.localizedDescription)
                            }
                        }
                        showingPostAlert.toggle()
                    }
                    .padding()
                }
            }
            .navigationTitle("Create New Post")
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(sourceType: .savedPhotosAlbum, selectedImage: self.$media)
            }
        }
    }
}

#Preview {
    PostCreationView(viewModel: CKViewModel(), showingPostAlert: SocialView(mediaManager: MediaManager()).$showingPostAlert)
}
