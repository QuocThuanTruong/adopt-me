//
//  PetDetailViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 1/5/21.
//

import UIKit
import MaterialComponents
import ImageSlideshow
import AlamofireImage
import Alamofire
import Nuke
import SCLAlertView

class PetDetailViewController: UIViewController {

    @IBOutlet weak var favButton: MDCButton!
    @IBOutlet weak var petImageSlideShow: ImageSlideshow!
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var petAgeLabel: UILabel!
    @IBOutlet weak var petGenderLabel: UILabel!
    @IBOutlet weak var petAddressLabel: UILabel!
    @IBOutlet weak var petDescriptionLabel: UILabel!
    @IBOutlet weak var userAvatar: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var adoptMeButton: MDCButton!
    @IBOutlet weak var imageSSIndicator: UIPageControl!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    @IBOutlet weak var testUserAvatar: UIImageView!
    var pet_id : String = ""
    var pet = Pet()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

       initView()
    }
    
    func initView() {
        favButton.layer.cornerRadius = 25.0
        adoptMeButton.layer.cornerRadius = 5.0
        userAvatar.layer.cornerRadius = 30.0
        
        phoneButton.layer.cornerRadius = 5.0
        phoneButton.backgroundColor = .white
        phoneButton.layer.borderWidth = 1.0
        phoneButton.layer.borderColor = UIColor(named: "AppRedColor")?.cgColor
        
        configImageSlideShow()
        
        petNameLabel.text = pet.name
        petAgeLabel.text = "\(pet.age) month"
        petGenderLabel.text = pet.gender ? "Male" : "Female"
        petAddressLabel.text = pet.address
        petDescriptionLabel.text = pet.description
        
        db.collection("users").document(pet.user_id).getDocument { (document, error) in
            let data = document?.data()
            
            self.userNameLabel.text = (data?["fullname"] as! String)
            self.userEmailLabel.text = (data?["email"] as! String)
            
            let urlStr = URL(string: (data?["avatar"] as! String))
            let urlReq = URLRequest(url: urlStr!)
            
            let options = ImageLoadingOptions(
              placeholder: UIImage(named: "user_avatar"),
              transition: .fadeIn(duration: 0.5)
            )
            
            Nuke.loadImage(with: urlReq, options: options, into: self.userAvatarImageView)

            self.userAvatarImageView.layer.cornerRadius = 30.0
        }
        
        db.collection("users").document(Core.shared.getCurrentUserID()).getDocument { (document, error) in
            let data = document?.data()
            
            let favorites = data!["favorites"] as! [String]
            
            let index = favorites.firstIndex(of: self.pet.pet_id)
            
            if index != nil {
                self.favButton.setImage(UIImage(named: "ic-md-red-fav"), for: .normal)
            } else {
                self.favButton.setImage(UIImage(named: "ic-md-white-fav"), for: .normal)
            }

        }
    }
    
    func configImageSlideShow() {
        //test data
        let afNetworkingSource = [AlamofireSource(urlString: pet.avatar)!, AlamofireSource(urlString: pet.images[0])!, AlamofireSource(urlString: pet.images[1])!, AlamofireSource(urlString: pet.images[2])!]
        
        petImageSlideShow.slideshowInterval = 5.0
        petImageSlideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        petImageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFill

        petImageSlideShow.activityIndicator = DefaultActivityIndicator()
        petImageSlideShow.delegate = self

        petImageSlideShow.setImageInputs(afNetworkingSource)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(imageSlideShowTap))
        petImageSlideShow.addGestureRecognizer(recognizer)
    }
    
    @objc func imageSlideShowTap() {
        let fullScreenController = petImageSlideShow.presentFullScreenController(from: self)
            
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .medium, color: nil)
    }
    
    @IBAction func viewProfileAct(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherUserProfileViewController") as! OtherUserProfileViewController
        
        vc.user_id = pet.user_id
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func adoptMeAct(_ sender: Any) {
        db.collection("users").document(pet.user_id).getDocument { (document, error) in
            let data = document?.data()
            
            //Day nha bro
            let name = (data?["fullname"] as! String)
            var email = (data?["email"] as! String)
            
            if email == Core.shared.getCurrentUserEmail() {
                let appearance = SCLAlertView.SCLAppearance(
                    kButtonFont: UIFont(name: "HelveticaNeue", size: 17)!,
                    showCloseButton: false, showCircularIcon: false
                )
                
                let alertView = SCLAlertView(appearance: appearance)
               
                alertView.addButton("OK", backgroundColor: UIColor(named: "AppRedColor"), textColor: .white, showTimeout: .none, action: {
                    alertView.dismiss(animated: true, completion: nil)
                })
                
                    
                alertView.showWarning("Warning", subTitle: "You can not chat with your self")
                
            } else {
            
            email = ChatDatabaseManager.safeEmail(emailAddress: email)
            
            print(name)
            print(email)
            
            ChatDatabaseManager.shared.conversationExists(iwth: email, completion: { [weak self] result in
                    guard let strongSelf = self else {
                        return
                    }
                    switch result {
                    case .success(let conversationId):
                        print("success to load exists")

                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ChatDetailViewController") as! ChatDetailViewController
                        vc.isNewConversation = false
                        vc.otherUserEmail = email
                        vc.conversationId = conversationId
                        vc.titleChat = name
                        
                        vc.modalPresentationStyle = .fullScreen
                        
                        strongSelf.present(vc, animated: true, completion: nil)
                    case .failure(_):
                        print("create new")

                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ChatDetailViewController") as! ChatDetailViewController
                        vc.isNewConversation = true
                        vc.otherUserEmail = email
                        vc.conversationId = nil
                        vc.titleChat = name
                        
                        vc.modalPresentationStyle = .fullScreen
                        
                        strongSelf.present(vc, animated: true, completion: nil)
                       
                        
                    }
                })
            
            }
                 
        }
    }
    
    @IBAction func phoneAct(_ sender: Any) {
        db.collection("users").document(pet.user_id).getDocument { (document, error) in
            let data = document?.data()
            
            let phoneNumber = data?["phone"] as! String
            
            if let url = URL(string: "tel://\(phoneNumber)") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    @IBAction func addFavAct(_ sender: Any) {
        let favButton = sender as? UIButton
        
        db.collection("users").document(Core.shared.getCurrentUserID()).getDocument { [self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                var favorites = data?["favorites"] as! [String]
                
                let index = favorites.firstIndex(of: pet.pet_id)
                
                if index != nil {
                    favButton?.setImage(UIImage(named: "ic-md-white-fav"), for: .normal)
                    
                    favorites.remove(at: index!)

                } else {
                    favButton?.setImage(UIImage(named: "ic-md-red-fav"), for: .normal)
                    
                    favorites.append(pet.pet_id)
                }
                
                db.collection("users").document(Core.shared.getCurrentUserID()).updateData(["favorites" : favorites])

                } else {
                    print("Document does not exist")
                }
        }
    }
    
    @IBAction func backAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension PetDetailViewController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
        imageSSIndicator.currentPage = page
    }
}
