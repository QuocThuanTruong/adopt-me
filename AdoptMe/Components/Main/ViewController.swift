//
//  ViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 12/5/20.
//

import UIKit
import SOTabBar
import Firebase

class ViewController : SOTabBarController {
    // MARK: Outlets
    var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initView()
        
    }
    
    func initView() {
        Core.shared.setKeyName("")
        
        let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let favVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let addVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddPetViewController") as! AddPetViewController
        let chatVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        let userVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserViewController") as! UserViewController

        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "ic-blue-home"), selectedImage: UIImage(named: "ic-white-home"))
        favVC.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(named: "ic-md-blue-fav"), selectedImage: UIImage(named: "ic-md-white-fav"))
        addVC.tabBarItem = UITabBarItem(title: "Add pet", image: UIImage(named: "ic-blue-add"), selectedImage: UIImage(named: "ic-white-add"))
        chatVC.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(named: "ic-blue-chat"), selectedImage: UIImage(named: "ic-white-chat"))
        userVC.tabBarItem = UITabBarItem(title: "User", image: UIImage(named: "ic-blue-user"), selectedImage: UIImage(named: "ic-white-user"))

        homeVC.isFav = false;
        favVC.isFav = true;
        
        self.viewControllers = [homeVC, favVC, addVC, chatVC, userVC]
    }
    
    override func loadView() {
        super.loadView()
        SOTabBarSetting.tabBarTintColor = UIColor(named: "AccentColor")!
        SOTabBarSetting.tabBarHeight = CGFloat(52)
        SOTabBarSetting.tabBarSizeImage = 20
        SOTabBarSetting.tabBarSizeSelectedImage = 22
        SOTabBarSetting.tabBarCircleSize = CGSize(width: 58, height: 58)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}


