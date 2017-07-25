//
//  ProfileViewController.swift
//  GetCats
//
//  Created by Mariano Montori on 7/17/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    var pictures = [Picture](){
        didSet{
            collectionView.reloadData()
        }
    }
    var todayPic : Picture?
    
    var authHandle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var catGoldCountLabel: UILabel!
    @IBOutlet weak var catOfDayButton: UIButton!
    @IBOutlet weak var loadingImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = User.current.username
        catOfDayButton.layer.cornerRadius = 10
        
        UserService.show(forUID: User.current.uid) { (user) in
            defer {
                self.pictures = User.current.pictures
                self.catGoldCountLabel.text = String(self.pictures.count * 10)
//                self.todayPic = User.current.todayPic
            }
            guard let user = user else {
                return
            }
            User.setCurrent(user)
        }
        
        authHandle = Auth.auth().addStateDidChangeListener() { [unowned self] (auth, user) in
            guard user == nil else { return }
            
            let loginViewController = UIStoryboard.initialViewController(for: .login)
            self.view.window?.rootViewController = loginViewController
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    deinit {
        if let authHandle = authHandle {
            Auth.auth().removeStateDidChangeListener(authHandle)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func catOfDayClicked(_ sender: UIButton) {
        sender.isEnabled = false
        sender.setTitle("loading...", for: UIControlState.normal)
        sender.backgroundColor = UIColor.gray
        let emptyPic = Picture(imageURL: "LOADER", imageHeight: 0.0)
        self.pictures.append(emptyPic)
        RedditService.retreiveCatImage(completion: { (urlString, redditUID) in
            if let urlString = urlString,
               let redditUID = redditUID {
                do {
                    let url = URL(string: urlString)
                    let  data = try Data(contentsOf: url!)
                    if let image = UIImage(data: data){
                        PictureService.create(for: image, uid: redditUID, success: { (success) in
                            PictureService.showTodayPic(uid: User.current.uid, completion: { (newPic) in
                                guard let pic = newPic else {
                                    return
                                }
                                self.pictures[self.pictures.count - 1] = pic
                                self.catGoldCountLabel.text = String(self.pictures.count * 10)
                                self.collectionView.reloadData()
                                sender.isEnabled = true
                                sender.setTitle("Cat Pic of the Day!", for: UIControlState.normal)
                                sender.backgroundColor = UIColor.blue
                            })
                        })
                    }
                }
                catch let error as NSError{
                    print(error.localizedDescription)
                }
            }
        })
    }
    @IBAction func logOutClicked(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let signOutAction = UIAlertAction(title: "Are you sure you want to log out?", style: .destructive) { _ in
            do {
                try Auth.auth().signOut()
            } catch let error as NSError {
                assertionFailure("Error signing out: \(error.localizedDescription)")
            }
        }
        
        alertController.addAction(signOutAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatImageCell", for: indexPath) as! CatImageCell
        let image = pictures[indexPath.row]
        if image.imageURL != "LOADER"{
            let imageURL = URL(string: image.imageURL)
            cell.thumbImageView.kf.setImage(with: imageURL)
        }
        else{
            cell.thumbImageView.image = UIImage.gif(name: "catLoading")
        }

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
}
