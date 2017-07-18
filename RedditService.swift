//
//  RedditService.swift
//  GetCats
//
//  Created by Mariano Montori on 7/18/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

struct RedditService {
    static func retreiveCatImage(entryContact : String = "https://www.reddit.com/r/cats.json?sort=top&limit=100", completion: @escaping (String?) -> Void){
        Alamofire.request(entryContact).validate().responseJSON() { response in
            switch response.result {
            case .success:
                print("in success")
                if let value = response.result.value {
                    var randomNum : Int
                    var postType : String?
                    var post : JSON
                    let json = JSON(value)
                    let posts = json["data"]["children"]
                    repeat {
                        randomNum = Int(arc4random_uniform(100))
                        post = posts[randomNum]["data"]
                        postType = post["link_flair_text"].stringValue
                        print(randomNum)
                    } while postType != "Cat Picture"
                    let location = post["url"]
                    print(location.stringValue)
                    completion(location.stringValue)
                }
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
}
