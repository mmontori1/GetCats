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
    static func create(for image: UIImage, uid : String, success: @escaping (Bool) -> Void) {
        let imageRef = StorageReference.newPostImageReference(redditUID: uid)
        uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return success(false)
            }
            
            let urlString = downloadURL.absoluteString
            let aspectHeight = image.aspectHeight
            create(forURLString: urlString, aspectHeight: aspectHeight, redditUID: uid, completion: { (completion) in
                success(completion)
            })
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
    
    private static func create(forURLString urlString: String, aspectHeight: CGFloat, redditUID: String, completion: @escaping (Bool) -> Void) {
        let currentUser = User.current
        let rootRef =  Database.database().reference()
        let pictureRef = rootRef.child("users").child(currentUser.uid).child("pictures").child(redditUID)
        let todayRef = rootRef.child("users").child(currentUser.uid).child("todayPic")
        let picture = Picture(imageURL: urlString, imageHeight: aspectHeight)
        pictureRef.updateChildValues(picture.dictValue)
        todayRef.setValue(nil)
        todayRef.child(redditUID).setValue(picture.dictValue)
        completion(true)
    }
    
    static func showTodayPic(uid : String, completion: @escaping (Picture?) -> Void){
        let ref = Database.database().reference().child("users").child(User.current.uid).child("todayPic")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let todayPic = snapshot.children.allObjects.first as? DataSnapshot else{
                return completion(nil)
            }
            print(snapshot.children.allObjects.first ?? "error!!!")
            guard let picture = Picture(snapshot: todayPic) else {
                return completion(nil)
            }
            completion(picture)
        })
    }
}
