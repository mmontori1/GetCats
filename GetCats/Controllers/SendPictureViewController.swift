//
//  SendPictureViewController.swift
//  GetCats
//
//  Created by Mariano Montori on 7/22/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit

class SendPictureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "cancel" {
                print("Cancel button tapped")
            }
        }
    }

}
