//
//  User.swift
//  GetCats
//
//  Created by Mariano Montori on 7/18/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase.FIRDataSnapshot

class User : NSObject {
    let uid: String
    let username: String
    
    
    init(uid: String, username: String) {
        self.uid = uid
        self.username = username
        super.init()
        
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
        let username = dict["username"] as? String
            else { return nil }
        
        self.uid = snapshot.key
        self.username = username
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: "uid") as? String,
            let username = aDecoder.decodeObject(forKey: "username") as? String
            else { return nil }
        
        self.uid = uid
        self.username = username
        
        super.init()
    }
    
    private static var _current: User?
    
    static var current: User {
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        return currentUser
    }
    
    class func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        if writeToUserDefaults {
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            
            UserDefaults.standard.set(data, forKey: "currentUser")
        }
        
        _current = user
    }
}

extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(username, forKey: "username")
    }
}
