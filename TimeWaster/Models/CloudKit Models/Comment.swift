//
//  Comment.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/16/23.
//

import Foundation
import CloudKit

struct Comment: Identifiable {
    static let recordType = "Comment"
    
    var id: String
    
    var username: String
    var text: String
    var creationDate: Date
    
    var record: CKRecord {
        let recordID = CKRecord.ID(recordName: id)
        let record = CKRecord(recordType: Self.recordType, recordID: recordID)
        record.setValue(username, forKey: "username")
        record.setValue(text, forKey: "text")
        return record
    }
    
    init(id: String = UUID().uuidString, username: String, text: String, creationDate: Date = Date()) {
        self.id = id
        self.username = username
        self.text = text
        self.creationDate = creationDate
    }
    
    init?(from record: CKRecord) {
        guard let username = record.value(forKey: "username") as? String,
              let text = record.value(forKey: "text") as? String else {
            return nil
        }
        
        self = Comment(id: record.recordID.recordName, username: username, text: text, creationDate: record.creationDate ?? Date())
    }
}
