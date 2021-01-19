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
            
            /*result.UID = data?["UID"] as! String
            result.address = data?["address"] as! String
            result.dateOfBirth = data?["dateOfBirth"] as! String
            result.email = data?["email"] as! String
            result.fullname = data?["fullname"] as! String
            result.gender = data?["gender"] as! Bool
            result.password = data?["password"] as! String
            result.phone = data?["phone"] as! String
            result.token = data?["token"] as! String
            result.username = data?["username"] as! String
            result.avatar = data?["avatar"] as! String*/
            
            self.userNameLabel.text = (data?["fullname"] as! String)
            self.userEmailLabel.text = (data?["email"] as! String)
            
            let urlStr = URL(string: (data?["avatar"] as! String))
            let urlReq = URLRequest(url: urlStr!)
            Nuke.loadImage(with: urlReq, into: self.testUserAvatar)
        }
    }
    
    func configImageSlideShow() {
        //test data
        let afNetworkingSource = [AlamofireSource(urlString: pet.images[0])!, AlamofireSource(urlString: pet.images[1])!, AlamofireSource(urlString: pet.images[2])!]
        
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
        
    }
    
    @IBAction func adoptMeAct(_ sender: Any) {
    }
    
    @IBAction func phoneAct(_ sender: Any) {
    }
    
    @IBAction func addFavAct(_ sender: Any) {
        
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
