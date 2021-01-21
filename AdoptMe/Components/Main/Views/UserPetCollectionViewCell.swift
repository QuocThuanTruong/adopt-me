//
//  UserPetCollectionViewCell.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 1/22/21.
//

import UIKit

class UserPetCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var petAvatarImage: UIImageView!
    @IBOutlet weak var addFavButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var postedDateLabel: UILabel!
    @IBOutlet weak var cellCardView: CardView!
}
