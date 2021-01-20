//
//  ChangePasswordViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 1/21/21.
//

import UIKit
import MaterialComponents

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var oldPasswordTextField: MDCOutlinedTextField!
    @IBOutlet weak var newPasswordTextField: MDCOutlinedTextField!
    @IBOutlet weak var retypeNewPasswordTextField: MDCOutlinedTextField!
    @IBOutlet weak var changeButton: MDCButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    func initView() {
        let textFields: [MDCOutlinedTextField] = [oldPasswordTextField, newPasswordTextField, retypeNewPasswordTextField]
        let leadingIconNames: [String] = ["ic-blue-lock", "ic-blue-lock", "ic-blue-lock"]
        let labelForTFs: [String] = ["Your old password", "Your new password", "Retype new password"]
        
        
        changeButton.layer.cornerRadius = 5.0
        cancelButton.layer.cornerRadius = 5.0
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor(named: "AppRedColor")!.cgColor
        
        for i in 0..<textFields.count {
            textFields[i].setOutlineColor(UIColor(named: "AccentColor")!, for: .editing)
            textFields[i].setOutlineColor(UIColor(named: "AppSecondaryColor")!, for: .normal)
            textFields[i].leadingView = UIImageView(image: UIImage(named: leadingIconNames[i]))
            textFields[i].leadingViewMode = .always
            textFields[i].label.text = labelForTFs[i]
            textFields[i].setNormalLabelColor(UIColor(named: "AppGrayColor")!, for: .normal)
            textFields[i].setFloatingLabelColor(UIColor(named: "AccentColor")!, for: .editing)
            textFields[i].setFloatingLabelColor(UIColor(named: "AppSecondaryColor")!, for: .normal)
        }
    }
    

    @IBAction func changeAct(_ sender: Any) {
    }
    
    @IBAction func cancelAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
