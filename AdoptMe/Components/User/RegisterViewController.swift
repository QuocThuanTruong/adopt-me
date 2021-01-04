//
//  RegisterViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 12/5/20.
//

import UIKit
import MaterialComponents

class RegisterViewController: UIViewController {

    @IBOutlet weak var phoneTextField: MDCOutlinedTextField!
    @IBOutlet weak var usernameTextField: MDCOutlinedTextField!
    @IBOutlet weak var passwordTextField: MDCOutlinedTextField!
    @IBOutlet weak var retypePasswordTextField: MDCOutlinedTextField!
    @IBOutlet weak var registerButton: MDCButton!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    func initView() {
        let textFields: [MDCOutlinedTextField] = [phoneTextField, usernameTextField, passwordTextField, retypePasswordTextField]
        let leadingIconNames: [String] = ["ic-blue-phone", "ic-blue-username", "ic-blue-password", "ic-blue-password"]
        let labelForTFs: [String] = ["Phone", "Username", "Password", "Retype password"]
        
        registerButton.layer.cornerRadius = 5.0
        
        for i in 0..<textFields.count {
            textFields[i].setOutlineColor(UIColor(named: "AccentColor")!, for: .editing)
            textFields[i].setOutlineColor(UIColor(named: "AppSecondaryColor")!, for: .normal)
            textFields[i].leadingView = UIImageView(image: UIImage(named: leadingIconNames[i]))
            textFields[i].leadingViewMode = .always
            textFields[i].label.text = labelForTFs[i]
            textFields[i].setNormalLabelColor(UIColor(named: "AppGrayColor")!, for: .normal)
            textFields[i].setFloatingLabelColor(UIColor(named: "AccentColor")!, for: .editing)
        }

    }
    
    @IBAction func registerAct(_ sender: Any) {
        // Do some thing before go to others screen
        if (isCorrectForm()) {
            let phone = phoneTextField.text!
            let username = usernameTextField.text!
            let password = passwordTextField.text!
            
            let registerVC = self.presentingViewController
            
            self.dismiss(animated: true, completion: {
                let dest = self.storyboard?.instantiateViewController(withIdentifier: "FillInfoViewController") as! FillInfoViewController
                
                dest.modalPresentationStyle = .fullScreen
                
                dest.username = username
                dest.password = password
                dest.phone = phone
                
                registerVC?.present(dest, animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func loginAct(_ sender: Any) {
        let registerVC = self.presentingViewController
        
        self.dismiss(animated: true, completion: {
            let dest = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            
            dest.modalPresentationStyle = .fullScreen
            registerVC?.present(dest, animated: true, completion: nil)
        })
       
    }
    
    func isSame(_ password: String, _ retype: String) -> Bool {
        return password == retype
    }
    
    func isCorrectForm() -> Bool {
        var result = true
        var alertMessage = ""
        
        if (phoneTextField.text! == "" && result == true) {
            alertMessage = "Phone must be filled"
            
            result = false
        }
        
        if (usernameTextField.text! == "" && result == true) {
            alertMessage = "Username must be filled"
            
            result = false
        }
        
        if (passwordTextField.text! == "" && result == true) {
            alertMessage = "Password must be filled"
            
            result = false
        }
        
        if (retypePasswordTextField.text! == "" && result == true) {
            alertMessage = "Retype password must be filled"
            
            result = false
        }
        
        if (result == true && !isSame(passwordTextField.text!, retypePasswordTextField.text!)) {
            alertMessage = "password and retype must be same"
            
            result = false
        }
        
        if (result == false) {
            let alert = UIAlertController(title: "Register failed", message: alertMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        return result
    }
}
