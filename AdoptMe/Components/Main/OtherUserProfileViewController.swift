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
    
    var user_id = ""
    var pets = [Pet]()
    
    lazy var cellSizes: [CGSize] = {
        var cellSizes = [CGSize]()
           
        for _ in 0...(pets.count + 100) {
            let random = Int(arc4random_uniform((UInt32(100))))
               
            cellSizes.append(CGSize(width: 157, height: 157 + random))
        }
           
           return cellSizes
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        fetchData()
    }
    
    func fetchData() {
        db.collection("pets").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.pets = documents.compactMap { (QueryDocumentSnapshot) -> Pet? in
              return try? QueryDocumentSnapshot.data(as: Pet.self)
            }
            
            self.pets = self.pets.filter { pet in
                return pet.is_active == 1
            }
            
            self.pets = self.pets.filter { pet in
                return pet.user_id == self.user_id
            }
        
            self.listPetCollectionView.reloadData()
        }
        
    }
    
    func initView() {
        userAvatarImageView.layer.borderWidth = 0
        userAvatarImageView.layer.masksToBounds = false
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.height/2
        userAvatarImageView.clipsToBounds = true
        
        db.collection("users").document(user_id).getDocument { [self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                
                let urlStr = URL(string: (data?["avatar"] as! String))
                let urlReq = URLRequest(url: urlStr!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
                
                let options = ImageLoadingOptions(
                  placeholder: UIImage(named: "user_avatar"),
                  transition: .fadeIn(duration: 0.5)
                )


                Nuke.loadImage(with: urlReq, options: options, into: userAvatarImageView)

                userFullName.text = data?["fullname"] as? String
                emailLabel.text = data?["email"] as? String
                dobLabel.text = data?["dateOfBirth"] as? String
                genderLabel.text = data?["gender"] as? String
                addressLabel.text = data?["address"] as? String
                phoneLabel.text = data?["phone"] as? String
                
                if (user_id == Core.shared.getCurrentUserID()) {
                    followButton.isHidden = true;
                }
                
                let following = data?["following"] as! [String]
                followingLabel.text = "\(following.count) following"
                
                let followers = data?["followers"] as! [String]
                followersLabel.text = "\(followers.count) followers"
                
                } else {
                    print("Document does not exist")
                }
        }
        
        db.collection("users").document(Core.shared.getCurrentUserID()).getDocument { [self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let following = data?["following"] as! [String]
                
                let index = following.firstIndex(of: user_id)
                
                if index != nil {
                    followButton.setTitle("UNFOLLOW", for: .normal)
                } else {
                    followButton.setTitle("FOLLOWING", for: .normal)
                }
                
            }
        }
        
        
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
        db.collection("users").document(Core.shared.getCurrentUserID()).getDocument { [self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                var following = data?["following"] as! [String]
                
                let index = following.firstIndex(of: user_id)
                
                if index != nil {
                    following.remove(at: index!)
                    
                    followButton.setTitle("FOLLOWING", for: .normal)
                    
                    db.collection("users").document(user_id).getDocument { [self] (document, error) in
                        if let document = document, document.exists {
                            let data = document.data()
                            var followers = data?["followers"] as! [String]
                            
                            let index = followers.firstIndex(of: Core.shared.getCurrentUserID())
                            
                            if index != nil {
                                followers.remove(at: index!)
                            }
                            
                            followersLabel.text = "\(followers.count) followers"
                            db.collection("users").document(user_id).updateData(["followers" : followers])

                        } else {
                            print("Document does not exist")
                        }
                    }
                } else {
                    following.append(user_id)
                    
                    followButton.setTitle("UNFOLLOW", for: .normal)
                    
                    db.collection("users").document(user_id).getDocument { [self] (document, error) in
                        if let document = document, document.exists {
                            let data = document.data()
                            var followers = data?["followers"] as! [String]
                            
                            followers.append(Core.shared.getCurrentUserID())
   
                            followersLabel.text = "\(followers.count) followers"
                            db.collection("users").document(user_id).updateData(["followers" : followers])

                        } else {
                            print("Document does not exist")
                        }
                    }
                }
                
                db.collection("users").document(Core.shared.getCurrentUserID()).updateData(["following" : following])

                } else {
                    print("Document does not exist")
                }
        }
    }
    
    @objc func addToFavorite(_ sender: Any) {
        let favButton = sender as? UIButton
        
        let pet = pets[favButton!.tag]
        
        db.collection("users").document(Core.shared.getCurrentUserID()).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                var favorites = data?["favorites"] as! [String]
                
                let index = favorites.firstIndex(of: pet.pet_id)
                
                if index != nil {
                    favButton?.setImage(UIImage(named: "ic-sm-white-fav"), for: .normal)
                    
                    favorites.remove(at: index!)

                } else {
                    favButton?.setImage(UIImage(named: "ic-sm-red-fav"), for: .normal)
                    
                    favorites.append(pet.pet_id)
                }
                
                db.collection("users").document(Core.shared.getCurrentUserID()).updateData(["favorites" : favorites])

                } else {
                    print("Document does not exist")
                }
        }
    }
    
}

extension OtherUserProfileViewController: UICollectionViewDataSource, CollectionViewWaterfallLayoutDelegate  {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetCollectionViewCell", for: indexPath) as! PetCollectionViewCell
            
        let index = indexPath.row
        let pet = pets[index]
        
        cell.addFavButton.layer.cornerRadius = cell.addFavButton.frame.height / 2
        cell.addFavButton.tag = indexPath.row
        
        db.collection("users").document(Core.shared.getCurrentUserID()).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let favorites = data?["favorites"] as! [String]
                
                let index = favorites.firstIndex(of: pet.pet_id)
                
                if index != nil {
                    cell.addFavButton.setImage(UIImage(named: "ic-sm-red-fav"), for: .normal)

                } else {
                    cell.addFavButton.setImage(UIImage(named: "ic-sm-white-fav"), for: .normal)
    
                }

                } else {
                    print("Document does not exist")
                }
        }
        
        cell.petNameLabel.text = pet.name
        
        let today = Date()
        
        let diffComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: pet.posted_date, to: today)
        let year = diffComponents.year ?? 0
        let month = diffComponents.month ?? 0
        let day = diffComponents.day ?? 0
        let hours = diffComponents.hour ?? 0
        let minutes = diffComponents.minute ?? 0
        
        if (year > 0 || month > 0) {
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "yyyy-MM-dd"
            
            cell.postedDateLabel.text = "Posted: \(dateFormatterPrint.string(from: pet.posted_date))"
        } else if (day > 0) {
            if (day == 1) {
                cell.postedDateLabel.text = "Posted: 1 day ago"
            } else {
                cell.postedDateLabel.text = "Posted: \(day) days ago"
            }
            
        } else if (hours > 0) {
            if (hours == 1) {
                cell.postedDateLabel.text = "Posted: 1 hour ago"
            } else {
                cell.postedDateLabel.text = "Posted: \(hours) hours ago"
            }
        } else {
            if (minutes == 0) {
                cell.postedDateLabel.text = "now"
            }
            else if (minutes == 1) {
                cell.postedDateLabel.text = "Posted: 1 minute ago"
            } else {
                cell.postedDateLabel.text = "Posted: \(minutes) minutes ago"
            }
        }
    
        
        
        cell.petAvatarImage.layer.cornerRadius = 16
        cell.petAvatarImage.clipsToBounds = true
        
        cell.addFavButton.addTarget(self, action: #selector(addToFavorite(_:)), for: .touchUpInside)
        
        guard let urlStr = URL(string: pet.avatar) else {
            return cell
        }
        
        let urlReq = URLRequest(url: urlStr)
        Nuke.loadImage(with: urlReq, into: cell.petAvatarImage)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return cellSizes[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dest = self.storyboard?.instantiateViewController(withIdentifier: "PetDetailViewController") as! PetDetailViewController

        let index = indexPath.row
        let pet = pets[index]

        dest.modalPresentationStyle = .fullScreen
        dest.pet = pet

        self.present(dest, animated: true, completion: nil)
    }
}


