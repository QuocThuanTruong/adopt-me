//
//  RegisterViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 12/5/20.
//

import UIKit
import MaterialComponents
import FlagPhoneNumber

class RegisterViewController: UIViewController {

    @IBOutlet weak var phoneTextField: FPNTextField!
    @IBOutlet weak var usernameTextField: MDCOutlinedTextField!
    @IBOutlet weak var passwordTextField: MDCOutlinedTextField!
    @IBOutlet weak var retypePasswordTextField: MDCOutlinedTextField!
    @IBOutlet weak var registerButton: MDCButton!
    @IBOutlet weak var dummyPhoneTextField: MDCOutlinedTextField!
    
    let listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    func initView() {
        let textFields: [MDCOutlinedTextField] = [usernameTextField, passwordTextField, retypePasswordTextField]
        let leadingIconNames: [String] = [ "ic-blue-username", "ic-blue-password", "ic-blue-password"]
        let labelForTFs: [String] = [ "Username", "Password", "Retype password"]
        
        registerButton.layer.cornerRadius = 5.0
        
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
        
        dummyPhoneTextField.setOutlineColor(UIColor(named: "AccentColor")!, for: .editing)
        dummyPhoneTextField.setOutlineColor(UIColor(named: "AppSecondaryColor")!, for: .normal)
        dummyPhoneTextField.label.text = "Phone"
        dummyPhoneTextField.setNormalLabelColor(UIColor(named: "AppGrayColor")!, for: .normal)
        dummyPhoneTextField.setFloatingLabelColor(UIColor(named: "AccentColor")!, for: .editing)
        dummyPhoneTextField.setFloatingLabelColor(UIColor(named: "AppSecondaryColor")!, for: .normal)

        phoneTextField.delegate = self
        
        phoneTextField.layer.borderWidth = 0
        phoneTextField.layer.borderColor = UIColor(named: "AccentColor")?.withAlphaComponent(0.0).cgColor
        phoneTextField.layer.cornerRadius = 5.0
        
        phoneTextField.setFlag(key: .VN)
        phoneTextField.delegate = self
        
        phoneTextField.displayMode = .list // .picker by default

        listController.setup(repository: phoneTextField.countryRepository)
        listController.didSelect = { [weak self] country  in
            self?.phoneTextField.setFlag(countryCode: country.code)
        }
    }
    @IBAction func dummyPhoneBeginEdit(_ sender: Any) {
        dummyPhoneTextField.text = " "
        dummyPhoneTextField.setOutlineColor(UIColor(named: "AccentColor")!, for: .normal)
        dummyPhoneTextField.setFloatingLabelColor(UIColor(named: "AccentColor")!, for: .normal)
    }
    
    @IBAction func dummyPhoneEditEnd(_ sender: Any) {
        if phoneTextField.text! == "" {
            dummyPhoneTextField.text = ""
            dummyPhoneTextField.setOutlineColor(UIColor(named: "AppSecondaryColor")!, for: .normal)

            dummyPhoneTextField.setNormalLabelColor(UIColor(named: "AppGrayColor")!, for: .normal)
            dummyPhoneTextField.setFloatingLabelColor(UIColor(named: "AppSecondaryColor")!, for: .normal)
        }
    }
    
    @IBAction func registerAct(_ sender: Any) {
        // Do some thing before go to others screen
        if (isCorrectForm()) {
            let phone = phoneTextField.getFormattedPhoneNumber(format: .E164)!
            let username = usernameTextField.text!
            let password = passwordTextField.text!
            
            
            
            
                let dest = self.storyboard?.instantiateViewController(withIdentifier: "FillInfoViewController") as! FillInfoViewController
                
                dest.modalPresentationStyle = .fullScreen
                
                dest.username = username
                dest.password = password
                dest.phone = phone
                
                self.present(dest, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func loginAct(_ sender: Any) {
//        let registerVC = self.presentingViewController
//
//        self.dismiss(animated: true, completion: {
//            let dest = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//
//            dest.modalPresentationStyle = .fullScreen
//            registerVC?.present(dest, animated: true, completion: nil)
//        })
       
        self.dismiss(animated: true, completion: nil)
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

extension RegisterViewController: FPNTextFieldDelegate {

   
   func fpnDisplayCountryList() {
    let navigationViewController = UINavigationController(rootViewController: listController)

      listController.title = "Countries"

      self.present(navigationViewController, animated: true, completion: nil)
   }

  
   func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
    print(name, dialCode, code) // Output "France", "+33", "FR"
    
}

  
   func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        
      if isValid {
        let phoneNumber = textField.getFormattedPhoneNumber(format: .E164)!       // Output "600000001"
        print(phoneNumber)
        
    
      } else {
           
      }
   }
}
