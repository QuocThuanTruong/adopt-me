//
//  SettingViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 1/20/21.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var lauchIntroductionSwitch: UISwitch!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
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
        var manual = true;
        
        db.collection("users").document(Core.shared.getCurrentUserID()).getDocument {(document, error) in
            if let document = document, document.exists {
                let data = document.data()
                
                let username = data?["username"] as! String
                
                if (username == "") {
                    manual = false;
                }
                
            }
        }
        
        if manual {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
            
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        } else {
            //Alert vi ban dang dang nhap ben thu 3 hahaha
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
