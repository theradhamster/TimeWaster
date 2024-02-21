//
//  CommentView.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/28/23.
//

import SwiftUI

struct CommentView: View {
    @ObservedObject var viewModel: CKViewModel
    let post: Post
    let comment: Comment
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(comment.username)
                        .font(.custom("CHILLER", size: 22))
                        .foregroundStyle(.gray)
                    Text(comment.creationDate.formatted())
                        .font(.custom("PAPYRUS", size: 22))
                        .foregroundStyle(.gray)
                }
                Text(comment.text)
                    .font(.custom("Jokerman", size: 28))
                    .foregroundStyle(.black)
                if let media = comment.media {
                    Image(uiImage: media)
                        .resizable()
                        .scaledToFit()
                }
                ScrollView(.horizontal) {
                    HStack {
                        ReactionView(viewModel: viewModel, post: Post(username: "dorothy", text: "we live in a society"))
                    }
                }
            }
        }
        .foregroundStyle(.primary)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(.ultraThinMaterial)
        }
        .padding()
    }
}

#Preview {
    CommentView(viewModel: CKViewModel(), post: Post(username: "dorothy", text: "i hate my life"), comment: Comment(username: "dorothy", text: "yeah"))
}
