//
//  ProfileViewController.swift
//  GetCats
//
//  Created by Mariano Montori on 7/17/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var pictures : [Picture] = []
    var todayPic : Picture?

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatImageCell", for: indexPath) as! CatImageCell
        cell.thumbImageView.backgroundColor = .red
        
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
        headerView.catGoldCountLabel.text = "30"
        return headerView
    }
}
