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
//    static func fetch() async throws -> [Post] {
//        
//    }
}
