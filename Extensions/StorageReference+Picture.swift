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
    static func newPostImageReference(redditUID: String) -> StorageReference {
        let uid = User.current.uid
        
        return Storage.storage().reference().child("images/\(uid)/\(redditUID).jpg")
    }
}
