//
//  StorageReference+Picture.swift
//  GetCats
//
//  Created by Mariano Montori on 7/19/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import Foundation
import FirebaseStorage

extension StorageReference {
//    static let dateFormatter = ISO8601DateFormatter()
    
    static func newPostImageReference(redditUID: String) -> StorageReference {
        let uid = User.current.uid
//        let timestamp = dateFormatter.string(from: Date())
        
        return Storage.storage().reference().child("images/\(uid)/\(redditUID).jpg")
    }
}
