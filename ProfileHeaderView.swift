//
//  ProfileHeaderView.swift
//  GetCats
//
//  Created by Mariano Montori on 7/17/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit

class ProfileHeaderView: UICollectionReusableView {
        
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var catGoldCountLabel: UILabel!
    @IBOutlet weak var catOfDayButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        catOfDayButton.layer.cornerRadius = 10
    }
}
