//
//  UserViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 12/8/20.
//

import UIKit
import Firebase
import MaterialComponents
import Nuke
import SCLAlertView

class UserViewController: UIViewController {

    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userAvatarButton: UIButton!
    @IBOutlet weak var logoutButton: MDCButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       initView()
    }
    
    func initView() {
        userAvatarImageView.layer.borderWidth = 0
        userAvatarImageView.layer.masksToBounds = false
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.height/2
        userAvatarImageView.clipsToBounds = true
        
        db.collection("users").document(Core.shared.getCurrentUserID()).getDocument { [self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                
                userFullNameLabel.text = data?["fullname"] as? String
                userEmailLabel.text = data?["email"] as? String
                
                let urlStr = URL(string: (data?["avatar"] as! String))
                let urlReq = URLRequest(url: urlStr!)
                
                let options = ImageLoadingOptions(
                  placeholder: UIImage(named: "user_avatar"),
                  transition: .fadeIn(duration: 0.5)
                )

                
                Nuke.loadImage(with: urlReq, options: options, into: self.userAvatarImageView)
                
                } else {
                    print("Document does not exist")
                }
        }
        
        
        logoutButton.layer.cornerRadius = 5.0
        
    }
    
    @IBAction func viewMyProfileAct(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func appInfoAct(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AppInfoViewController") as! AppInfoViewController
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func ratingAct(_ sender: Any) {
        
    }
    
    @IBAction func settingAct(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func editProfileAct(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateMyProfileViewController") as! UpdateMyProfileViewController
        
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func turnOnFirstLauch(_ sender: Any) {
        Core.shared.setIsFirstLauchApp()
    }
    
    @objc func confirmLogout() {
        let token = Core.shared.getToken()
        Core.shared.setToken("")
        
        let userCollection = Firestore.firestore().collection("users")

        userCollection.whereField("token", isEqualTo: token).limit(to: 1)
            .getDocuments{(querySnapshot, error) in
                if let error = error {
                    print(error)
                } else {
                    if querySnapshot!.documents.count == 1 {
                        let data = querySnapshot?.documents[0].data()
                        
                        userCollection.document(data?["UID"] as! String).updateData(["token": ""])
                        Core.shared.setCurrentUserID("")
                        
                        let vc = self.presentingViewController
                        
                        self.dismiss(animated: false, completion: {
                            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
                            let dest = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            dest.modalPresentationStyle = .fullScreen
                            vc?.present(dest, animated: false, completion: nil)
                        })

                    }
                }
            }
    }
    
    @IBAction func logOutAct(_ sender: Any) {
        let appearance = SCLAlertView.SCLAppearance(
            kButtonFont: UIFont(name: "HelveticaNeue", size: 17)!,
            showCloseButton: false, showCircularIcon: false
        )
        
        let alertView = SCLAlertView(appearance: appearance)
       
        alertView.addButton("CONFIRM", backgroundColor: UIColor(named: "AppRedColor"), textColor: .white, showTimeout: .none, target: self, selector: #selector(confirmLogout))
        
        alertView.addButton("CANCEL", backgroundColor: UIColor(named: "AppRedColor"), textColor: .white, showTimeout: .none, action: {
            alertView.dismiss(animated: true, completion: nil)
        })
        
            
        alertView.showWarning("Warning", subTitle: "Do you really want to logout?")
        
    }
}

extension UserViewController: UpdateInfoDelegate {
    func updateChangeInfo() {
        initView()
    }
    
    
}
