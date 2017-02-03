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

struct UserObject {
    
    let key: String
    
    let email: String
   
    
    
    
    let ref: FIRDatabaseReference?
    
    
    init (email: String, key: String = ""){
        
        self.key = key
        self.email = email
        self.ref = nil
        
        
        
    }
    
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        email = snapshotValue["email"] as! String
        
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "email": email,
                   ]
    }
    
    
}
