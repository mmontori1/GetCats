//
//  Picture.swift
//  GetCats
//
//  Created by Mariano Montori on 7/19/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit
import FirebaseDatabase.FIRDataSnapshot

struct Picture {
    var key: String?
    let imageURL: String
    let imageHeight: CGFloat
    let creationDate: Date
    
    init(imageURL: String, imageHeight: CGFloat){
        self.imageURL = imageURL
        self.imageHeight = imageHeight
        self.creationDate = Date()
//        DateFormatter.localizedString(from: Date(), dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium)
    }
    
    init?(snapshot: DataSnapshot){
        guard let dict = snapshot.value as? [String : Any],
            let imageURL = dict["imageURL"] as? String,
            let imageHeight = dict["imageHeight"] as? CGFloat,
            let createdAgo = dict["image"] as? TimeInterval
            else { return nil }
        
        self.key = snapshot.key
        self.imageURL = imageURL
        self.imageHeight = imageHeight
        self.creationDate = Date(timeIntervalSince1970: createdAgo)
    }
}
