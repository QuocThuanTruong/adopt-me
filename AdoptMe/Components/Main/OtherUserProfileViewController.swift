//
//  OtherUserProfileViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 1/20/21.
//

import UIKit
import CollectionViewWaterfallLayout
import MaterialComponents
import Nuke

class OtherUserProfileViewController: UIViewController {

    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var listPetCollectionView: UICollectionView!
    @IBOutlet weak var followButton: MDCButton!
    
    var cellSizes: [CGSize] = {
        var cellSizes = [CGSize]()
           
        for _ in 0...10 {
            let random = Int(arc4random_uniform((UInt32(100))))
               
            cellSizes.append(CGSize(width: 157, height: 157 + random))
        }
           
           return cellSizes
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    func initView() {
        userAvatarImageView.layer.borderWidth = 0
        userAvatarImageView.layer.masksToBounds = false
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.height/2
        userAvatarImageView.clipsToBounds = true
        
        userAvatarImageView.image = UIImage(named: "test_avt")
        
        
        //init collection view
        let layout = CollectionViewWaterfallLayout()
        
        layout.columnCount = 2
        layout.sectionInset = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        layout.minimumColumnSpacing = 18
        layout.minimumInteritemSpacing = 18
        
        listPetCollectionView.collectionViewLayout = layout
        listPetCollectionView.tag = 0
        
    }
    
    @IBAction func backAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func followAct(_ sender: Any) {
        followButton.setTitle("UNFOLLOW", for: .normal)
    }
    
}

extension OtherUserProfileViewController: UICollectionViewDataSource, CollectionViewWaterfallLayoutDelegate  {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetCollectionViewCell", for: indexPath) as! PetCollectionViewCell
            
        
        let index = indexPath.row
        
        
        cell.addFavButton.layer.cornerRadius = cell.addFavButton.frame.height / 2
        cell.addFavButton.tag = indexPath.row
        cell.petNameLabel.text = "Candy"
        
        
            
        
        cell.postedDateLabel.text = "Posted: 3 minutes ago"
         
    
        
        
        
        cell.petAvatarImage.image = UIImage(named: "test_avt")
        
        cell.petAvatarImage.layer.cornerRadius = 16
        cell.petAvatarImage.clipsToBounds = true
        
               
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return cellSizes[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let dest = self.storyboard?.instantiateViewController(withIdentifier: "PetDetailViewController") as! PetDetailViewController
//
//        let index = indexPath.row
//        let pet = sourcePets[index]
//
//        dest.modalPresentationStyle = .fullScreen
//        dest.pet = pet
//
//        self.present(dest, animated: true, completion: nil)
    }
}


