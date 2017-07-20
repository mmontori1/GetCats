//
//  ProfileViewController.swift
//  GetCats
//
//  Created by Mariano Montori on 7/17/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    var pictures = [Picture](){
        didSet{
            collectionView.reloadData()
        }
    }
    var todayPic : Picture?

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserService.show(forUID: User.current.uid) { (user) in
            defer {
                print(User.current.pictures)
                self.pictures = User.current.pictures
            }
            guard let user = user else {
                return
            }
            User.setCurrent(user)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func catOfDayClicked(_ sender: UIButton) {
        RedditService.retreiveCatImage(completion: { (urlString, redditUID) in
            if let urlString = urlString,
               let redditUID = redditUID {
                do {
                    let url = URL(string: urlString)
                    let  data = try Data(contentsOf: url!)
                    if let image = UIImage(data: data){
                        PictureService.create(for: image, uid: redditUID)
                    }
                    else {
                        print("IMGUR U POOP")
                    }
                }
                catch let error as NSError{
                    print(error.localizedDescription)
                }
            }
        })
//        let ref = Database.database().reference().child("users").child(User.current.uid).child("todayPic")
        
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            defer{
//                self.collectionView.reloadData()
//            }
//            guard let todayPic = snapshot.children.allObjects.first as? DataSnapshot else{
//                return
//            }
//            print(snapshot.children.allObjects.first ?? "error!!!")
//            guard let picture = Picture(snapshot: todayPic) else {
//                return
//            }
//            print(picture)
//            self.todayPic = picture
//            self.pictures.append(picture)
//        })
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatImageCell", for: indexPath) as! CatImageCell
        let image = pictures[indexPath.row]
        print(image.imageURL)
        let imageURL = URL(string: image.imageURL)
        cell.thumbImageView.kf.setImage(with: imageURL)

        return cell
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 3
        let spacing: CGFloat = 1.5
        let totalHorizontalSpacing = (columns - 1) * spacing
        
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionElementKindSectionHeader else {
            fatalError("Unexpected element kind.")
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProfileHeaderView", for: indexPath) as! ProfileHeaderView
        
        headerView.usernameLabel.text = User.current.username
        headerView.catGoldCountLabel.text = String(pictures.count * 10)
        return headerView
    }
}
