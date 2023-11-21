//
//  Reaction.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/17/23.
//

import Foundation
import CloudKit

struct Reaction {
    static let recordType = "Reaction"
    
    var id: String

    var content: Content
    var creationDate: Date
    
    enum Content: String, CaseIterable, Identifiable {
        var id: String {
            self.rawValue
        }
        case me, phrog, froggy, eggme, slayme, picklechin
    }
    
    var record: CKRecord {
        let recordID = CKRecord.ID(recordName: id)
        let record = CKRecord(recordType: Self.recordType, recordID: recordID)
        record.setValue(content.rawValue, forKey: "content")
        return record
    }
    
    init(id: String = UUID().uuidString, content: Content, creationDate: Date = Date()) {
        self.id = id
        self.content = content
        self.creationDate = creationDate
    }
    
    init?(from record: CKRecord) {
        guard let content = Content(rawValue: record.value(forKey: "content") as? String ?? "") else {
            return nil
        }
        
        self = Reaction(id: record.recordID.recordName, content: content, creationDate: record.creationDate ?? Date())
    }
}
