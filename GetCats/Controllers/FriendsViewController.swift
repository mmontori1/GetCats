//
//  FriendsViewController.swift
//  GetCats
//
//  Created by Mariano Montori on 7/21/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {

    @IBOutlet weak var namesLabel: UILabel!
    var peerService : PeerToPeerHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peerService = PeerToPeerHelper()
        peerService?.delegate = self
//        UserService.show(forUID: User.current.uid) { (user) in
//            guard let user = user else {
//                return
//            }
//            User.setCurrent(user)
//            self.peerService.delegate = self
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension FriendsViewController : PeerToPeerHelperDelegate {
    func connectedDevicesChanged(manager: PeerToPeerHelper, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            if !connectedDevices.isEmpty{
                self.namesLabel.text = connectedDevices[0]
            }
//            print(connectedDevices)
        }
    }
}
