//
//  FriendsViewController.swift
//  GetCats
//
//  Created by Mariano Montori on 7/21/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var peerService : PeerToPeerHelper?
    var nearbyUsers = [String](){
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peerService = PeerToPeerHelper()
        peerService?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toSendPic" {
//                let indexPath = tableView.indexPathForSelectedRow!
//                let picture = notes[indexPath.row]
//                let displayNoteViewController = segue.destination as! SendPictureViewController
//                displayNoteViewController.note = note
                print("Table view cell tapped")
            }
        }
    }
    
    @IBAction func unwindToListNotesViewController(_ segue: UIStoryboardSegue) {
    }
}

extension FriendsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyUsers.count
//        return nearbyUsers.count != 0 ? nearbyUsers.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) as! FriendsTableViewCell
        cell.friendUsernameLabel.text = nearbyUsers[indexPath.row]
        return cell
    }
}

extension FriendsViewController : PeerToPeerHelperDelegate {
    func connectedDevicesChanged(manager: PeerToPeerHelper, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            self.nearbyUsers = connectedDevices
        }
    }
}
