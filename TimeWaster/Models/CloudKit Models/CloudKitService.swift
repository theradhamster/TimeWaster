//
//  CloudKitService.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/10/23.
//

import SDWebImageSwiftUI
import CloudKit
import SwiftUI

class CloudKitService {
    static let container = CKContainer.init(identifier: "iCloud.com.stvrshaped.BrainRotter")
    static let publicDatabase = container.publicCloudDatabase
    
    enum SaveError: Error {
        case couldNotFindImage, couldNotFetchData, couldNotCreateUrlFromAsset
    }
    
    static func save(_ post: Post) async throws {
        let record = post.record
        if let media = post.media {
            let data = media.sd_imageData()
            let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat")
            guard let url = url else {
                print(SaveError.couldNotCreateUrlFromAsset)
                return
            }
            do {
                try data?.write(to: url)
            } catch {
                print(error.localizedDescription)
                return
            }
            record["media"] = CKAsset(fileURL: url)
        }
        try await publicDatabase.save(record)
    }
    
    static func fetch() async throws -> [Post] {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Post", predicate: predicate)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        query.sortDescriptors = [sort]
        let result = try await publicDatabase.records(matching: query)
        let matchResults = result.matchResults
        var records = [CKRecord]()
        for matchResult in matchResults {
            let result = matchResult.1
            if let record = try? result.get() {
                records.append(record)
            }
        }
        var posts = [Post]()
        for record in records {
            if let post = Post(from: record) {
                posts.append(post)
            }
        }
        return posts
    }
    
    static func save(_ comment: Comment, with post: Post) async throws {
        let postReference = CKRecord.Reference(recordID: post.record.recordID, action: .deleteSelf)
        let commentRecord = comment.record
        commentRecord.setValue(postReference, forKey: Post.recordType)
        try await publicDatabase.save(commentRecord)
    }
    
    static func children(of post: Post) async throws -> [Comment] {
        let postReference = CKRecord.Reference(recordID: post.record.recordID, action: .deleteSelf)
        let predicate = NSPredicate(format: "\(Post.recordType) == %@", postReference)
        let query = CKQuery(recordType: "Comment", predicate: predicate)
        let sort = NSSortDescriptor(key: "creationDate", ascending: true)
        query.sortDescriptors = [sort]
        let result = try await publicDatabase.records(matching: query)
        let matchResults = result.matchResults
        var records = [CKRecord]()
        for matchResult in matchResults {
            let result = matchResult.1
            if let record = try? result.get() {
                records.append(record)
            }
        }
        var comments = [Comment]()
        for record in records {
            if let comment = Comment(from: record) {
                comments.append(comment)
            }
        }
        return comments
    }
    
    static func addReaction(_ reaction: Reaction, to post: Post) async throws {
        let postReference = CKRecord.Reference(recordID: post.record.recordID, action: .deleteSelf)
        let reactionRecord = reaction.record
        reactionRecord.setValue(postReference, forKey: Post.recordType)
        try await publicDatabase.save(reactionRecord)
    }
    
    static func children(of post: Post) async throws -> [Reaction] {
        let postReference = CKRecord.Reference(recordID: post.record.recordID, action: .deleteSelf)
        let predicate = NSPredicate(format: "\(Post.recordType) == %@", postReference)
        let query = CKQuery(recordType: "Reaction", predicate: predicate)
        let sort = NSSortDescriptor(key: "creationDate", ascending: true)
        query.sortDescriptors = [sort]
        let result = try await publicDatabase.records(matching: query)
        let matchResults = result.matchResults
        var records = [CKRecord]()
        for matchResult in matchResults {
            let result = matchResult.1
            if let record = try? result.get() {
                records.append(record)
            }
        }
        var reactions = [Reaction]()
        for record in records {
            if let reaction = Reaction(from: record) {
                reactions.append(reaction)
            }
        }
        return reactions
    }
    
}
