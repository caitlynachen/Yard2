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
import MapKit

struct ItemObject {
    
    let key: String
    
    let title: String
    let imageUrl: String
    let caption: String
    let price: Double
    let condition: String
    let createdAt: String
    let addressStr: String
    let latCoor: Double
    let longCoor: Double
    let addedByUser: String
    
    let ref: FIRDatabaseReference?
    
//    var distance: CLLocationDistance?


    init (title: String, price: Double, condition: String, caption: String, key: String = "", imageUrl: String, createdAt: String, addressStr: String, latCoor: Double, longCoor: Double, addedByUser: String){
        
        self.key = key
        self.title = title
        self.caption = caption
        self.price = price
        self.condition = condition
        self.createdAt = createdAt
        self.ref = nil
        self.imageUrl = imageUrl
        self.addressStr = addressStr
        self.latCoor = latCoor
        self.longCoor = longCoor
        self.addedByUser = addedByUser
        
        
    }
    

    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        caption = snapshotValue["caption"] as! String
        price = snapshotValue["price"] as! Double
        condition = snapshotValue["condition"] as! String
        imageUrl = snapshotValue["imageUrl"] as! String
        createdAt = snapshotValue["createdAt"] as! String
        addressStr = snapshotValue["addressStr"] as! String
        latCoor = snapshotValue["latCoor"] as! Double
        longCoor = snapshotValue["longCoor"] as! Double
        addedByUser = snapshotValue["addedByUser"] as! String

        
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "title": title,
            "caption": caption,
            "price": price,
            "condition": condition,
            "imageUrl": imageUrl,
            "createdAt": createdAt,
            "addressStr": addressStr,
            "latCoor": latCoor,
            "longCoor": longCoor,
            "addedByUser" : addedByUser
        ]
    }
    
    func calculateDistance(fromLocation: CLLocation?) -> CLLocationDistance{
        let location = CLLocation(latitude: self.latCoor, longitude: self.longCoor)
        let distance = location.distance(from: fromLocation!)
        return distance
    }


}
