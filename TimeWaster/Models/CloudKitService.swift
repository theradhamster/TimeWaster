//
//  CloudKitService.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/10/23.
//

import Foundation
import CloudKit

class CloudKitService {
    static let container = CKContainer.init(identifier: "iCloud.com.stvrshaped.BrainRotter")
    static let publicDatabase = container.publicCloudDatabase
    
    static func save(_ post: Post) async throws {
        try await publicDatabase.save(post.record)
    }
    static func fetch() async throws -> [Post] {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Post", predicate: predicate)
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
}
