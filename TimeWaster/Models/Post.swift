//
//  Post.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/10/23.
//

import Foundation
import CloudKit

struct Post {
    static let recordType = "Post"
    
    var id: String
    
    var username: String
    var text: String
    
    var record: CKRecord {
        let recordID = CKRecord.ID(recordName: id)
        let record = CKRecord(recordType: Self.recordType, recordID: recordID)
        record.setValue(username, forKey: "username")
        record.setValue(text, forKey: "text")
        return record
    }
    
    init(id: String = UUID().uuidString, username: String, text: String) {
        self.id = id
        self.username = username
        self.text = text
    }
    
    init?(from record: CKRecord) {
        guard let username = record.value(forKey: "username") as? String,
              let text = record.value(forKey: "text") as? String else {
            return nil
        }
        
        self = Post(id: record.recordID.recordName, username: username, text: text)
    }
}
