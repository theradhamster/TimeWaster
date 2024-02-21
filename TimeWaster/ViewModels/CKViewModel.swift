//
//  CKViewModel.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/14/23.
//

import Foundation
import UIKit
import CloudKit

@MainActor class CKViewModel: ObservableObject {
    @Published var posts: [Post] = []
    
    func reload() async {
        do {
            let posts = try await CloudKitService.fetch()
            self.posts = posts
            for post in posts {
                let comments: [Comment] = try await CloudKitService.children(of: post)
                let reactions: [Reaction] = try await CloudKitService.children(of: post)
                if let index = self.posts.firstIndex(where: { $0.id == post.id }) {
                    self.posts[index].comments = comments
                    self.posts[index].reactions = reactions
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func makeNewPost(username: String, text: String, media: UIImage? = nil) async throws {
        let newPost = Post(username: username, text: text, media: media)
        try await CloudKitService.save(newPost)
                posts.append(newPost)
        }

    func makeNewComment(_ comment: Comment, post: Post) async throws {
        try await CloudKitService.save(comment, with: post)
        if let index = self.posts.firstIndex(where: { $0.id == post.id }) {
            self.posts[index].comments.append(comment)
        }
    }

    func addNewReaction(_ content: Reaction.Content, post: Post) async throws {
        let newReaction = Reaction(content: Reaction.Content(rawValue: content.rawValue)!)
            try await CloudKitService.addReaction(newReaction, to: post)
        if let index = self.posts.firstIndex(where: { $0.id == post.id }) {
            self.posts[index].reactions.append(newReaction)
        }
    }
    
}
