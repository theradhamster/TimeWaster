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
    @State var showingPostAlert = false
    @State private var didFail = false
    @State private var errorTitle: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("jerma1")
                    .resizable()
                    .ignoresSafeArea()
                    .opacity(0.3)
                AnimatedImage(name: "roll.gif")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .opacity(0.6)
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.posts) { post in
                            PostView(viewModel: viewModel, post: post)
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
