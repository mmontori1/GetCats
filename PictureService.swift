//
//  PictureService.swift
//  GetCats
//
//  Created by Mariano Montori on 7/19/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage

struct PictureService {
    static func create(for image: UIImage) {
        let imageRef = StorageReference.newPostImageReference()
        uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }
            
            let urlString = downloadURL.absoluteString
            let aspectHeight = image.aspectHeight
            create(forURLString: urlString, aspectHeight: aspectHeight)
        }
    }
    
    private static func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void) {
        guard let imageData = UIImageJPEGRepresentation(image, 0.1) else {
            return completion(nil)
        }
        
        reference.putData(imageData, metadata: nil, completion: { (metadata, error) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            completion(metadata?.downloadURL())
        })
    }
    
    private static func create(forURLString urlString: String, aspectHeight: CGFloat) {
        let currentUser = User.current
        let post = Picture(imageURL: urlString, imageHeight: aspectHeight)
//        User.current.pictures.
        let rootRef =  Database.database().reference()
        let newPostRef = rootRef.child(currentUser.uid).child("pictures").childByAutoId()
        let newPostKey = newPostRef.key
        
    }
}
