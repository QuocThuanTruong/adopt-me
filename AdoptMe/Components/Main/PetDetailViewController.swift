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
    }
    
    func configImageSlideShow() {
        //test data
        let afNetworkingSource = [AlamofireSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!, AlamofireSource(urlString: "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080")!, AlamofireSource(urlString: "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080")!]
        
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
