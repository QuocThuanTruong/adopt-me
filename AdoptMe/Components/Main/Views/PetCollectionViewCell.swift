//
//  PetCollectionViewCell.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 1/2/21.
//

import UIKit
import MaterialComponents

class PetCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var petAvatarImage: UIImageView!
    @IBOutlet weak var addFavButton: UIButton!
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var postedDateLabel: UILabel!
    @IBOutlet weak var cellCardView: CardView!
    
    @IBAction func act_addFavorite(_ sender: Any) {
        
    }
}
