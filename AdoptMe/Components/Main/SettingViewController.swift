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
        
    }
    
    @IBAction func changePasswordAct(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func changeLauchIntroduction(_ sender: Any) {
    }
    
    @IBAction func changeNotification(_ sender: Any) {
    }
    
    @IBAction func backAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
