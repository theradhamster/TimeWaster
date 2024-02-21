//
//  ReactionView.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/20/23.
//

import SwiftUI

struct ReactionView: View {
//    @State private var content = ""
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: CKViewModel
    @State private var didFail = false
    @State private var errorTitle: String = ""
    let post: Post
    
    var body: some View {
        ForEach(Reaction.Content.allCases) { content in
            Button {
                Task {
                    do {
                        let reaction = Reaction(content: content)
                        try await viewModel.addNewReaction(reaction.content, post: post)
                    } catch {
                        errorTitle = error.localizedDescription
                        didFail.toggle()
                        print(error.localizedDescription)
                    }
                }
            } label: {
                HStack {
                    Image(content.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 25)
                    Text("\(post.reactions.filter({ $0.content == content }).count)")
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 13)
                        .fill(.ultraThinMaterial)
                }
            }
        }
    }
}

//#Preview {
//    ReactionView(viewModel: CKViewModel(), post: Post(username: "dorothy", text: "hi"))
//}
