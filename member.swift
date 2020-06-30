//
//  member.swift
//  
//
//  Created by Thanakorn Kaewsawang on 10/5/2562 BE.
//

import Foundation
import Firebase
class member {
    let key: String
    var name : String!
    var email : String!
    var completed: Bool!
    let ref:DatabaseReference!
    init(name: String,email:String,key:String="") {
        self.key = key
        self.name = name
        self.email = email
        self.ref = nil
    }
    init(snapshot: DataSnapshot){
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = (snapshotValue["name"] as! String)
        email = (snapshotValue["email"] as! String)
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return[
            "name":name,
            "email":email
        ]
    }
    
}
