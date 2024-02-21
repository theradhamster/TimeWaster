//
//  PostView.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/22/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostView: View {
    @ObservedObject var viewModel: CKViewModel
    let post: Post
    
    var body: some View {
        NavigationLink(destination: PostDetailView(viewModel: viewModel, post: post)) {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(post.username)
                            .font(.custom("Jokerman", size: 22))
                            .foregroundStyle(.gray)
                        Text(post.creationDate.formatted())
                            .font(.custom("CHILLER", size: 22))
                            .foregroundStyle(.gray)
                    }
                    Text(post.text)
                        //.font(.custom("OldLondon", size: 28))
                        .fontWeight(.black)
                        .foregroundStyle(.purple)
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

#Preview {
    PostView(viewModel: CKViewModel(), post: Post(username: "dorothy", text: "i hate previews"))
}
