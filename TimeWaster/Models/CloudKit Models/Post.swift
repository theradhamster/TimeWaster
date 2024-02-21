//
//  Post.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/10/23.
//

import CloudKit
import SwiftUI

struct Post: Identifiable {
    static let recordType = "Post"
    
    var id: String
    
    var username: String
    var text: String
    var creationDate: Date
    var media: UIImage?
    var reactions: [Reaction] = []
    var comments: [Comment] = []
    
    var record: CKRecord {
        let recordID = CKRecord.ID(recordName: id)
        let record = CKRecord(recordType: Self.recordType, recordID: recordID)
        record.setValue(username, forKey: "username")
        record.setValue(text, forKey: "text")
        return record
    }
    
    init(id: String = UUID().uuidString, username: String, text: String, creationDate: Date = Date(), media: UIImage? = nil) {
        self.id = id
        self.username = username
        self.text = text
        self.creationDate = creationDate
        self.media = media
    }
    
    init?(from record: CKRecord) {
        guard let username = record.value(forKey: "username") as? String,
              let text = record.value(forKey: "text") as? String
        else {
            return nil
        }
        
        self = Post(id: record.recordID.recordName, username: username, text: text, creationDate: record.creationDate ?? Date())
        if let asset = record.value(forKey: "media") as? CKAsset {
            let assetURL = asset.fileURL?.path ?? ""
            self.media = UIImage(contentsOfFile: assetURL)
        }
    }
}
