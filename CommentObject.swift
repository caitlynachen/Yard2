//
//  ItemObject.swift
//  YardSale
//
//  Created by Caitlyn Chen on 12/21/16.
//  Copyright © 2016 Caitlyn Chen. All rights reserved.
//

import UIKit
import Firebase
import Foundation

struct CommentObject {
    
    let key: String
    
    let title: String
    let createdAt: String
    let createdBy: String
    
    
    
    let ref: FIRDatabaseReference?
    
    
    init (title: String, key: String = "",  createdAt: String, createdBy: String){
        
        self.key = key
        self.title = title
        self.createdAt = createdAt
        self.createdBy = createdBy
        self.ref = nil

        
        
    }
    
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        createdAt = snapshotValue["createdAt"] as! String
        createdBy = snapshotValue["createdBy"] as! String
        
        
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "title": title,
            "createdAt": createdAt,
            "createdBy": createdBy
        ]
    }
    
    
}
