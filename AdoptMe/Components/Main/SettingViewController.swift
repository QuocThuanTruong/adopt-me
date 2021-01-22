//
//  SettingViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 1/20/21.
//

import UIKit
import SCLAlertView

class SettingViewController: UIViewController {

    @IBOutlet weak var lauchIntroductionSwitch: UISwitch!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var changePasswordCardView: CardView!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }

    func initView() {
        
        if Core.shared.isFirstLauchApp() {
            lauchIntroductionSwitch.setOn(true, animated: false)
        } else {
            lauchIntroductionSwitch.setOn(false, animated: false)
        }
        
    }
    
    @IBAction func changePasswordAct(_ sender: Any) {
        db.collection("users").document(Core.shared.getCurrentUserID()).getDocument {(document, error) in
            if let document = document, document.exists {
                let data = document.data()
                
                let username = data?["username"] as! String
                
                if (username == "") {
                    let appearance = SCLAlertView.SCLAppearance(
                        kButtonFont: UIFont(name: "HelveticaNeue", size: 17)!,
                        showCloseButton: false, showCircularIcon: false
                    )
                    
                    let alertView = SCLAlertView(appearance: appearance)
                    
                    alertView.addButton("OK", backgroundColor: UIColor(named: "AppRedColor"), textColor: .white, showTimeout: .none, action: {
                        alertView.dismiss(animated: true, completion: nil)
                    })
                    
                    alertView.showWarning("Warning", subTitle: "can not change password because you are logging by third-party")
                } else {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
                     
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    @IBAction func changeLauchIntroduction(_ sender: Any) {
        if lauchIntroductionSwitch.isOn {
            Core.shared.setIsFirstLauchApp()
        } else {
            Core.shared.setIsNotFirstLauchApp()
        }
    }
    
    @IBAction func changeNotification(_ sender: Any) {
    }
    
    @IBAction func backAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
