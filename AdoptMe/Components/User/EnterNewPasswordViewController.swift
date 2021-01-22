//
//  EnterNewPasswordViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 1/1/21.
//

import UIKit
import MaterialComponents
import Firebase
import BCrypt
import SCLAlertView

class EnterNewPasswordViewController: UIViewController {

    @IBOutlet weak var passwordTextField: MDCOutlinedTextField!
    @IBOutlet weak var retypePasswordTextField: MDCOutlinedTextField!
    
    @IBOutlet weak var doneButton: MDCButton!
    @IBOutlet weak var backButton: UIButton!
    
    var fullPhoneNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    func initView() {
        doneButton.layer.cornerRadius  = 5.0
        
        backButton.layer.borderWidth = 1
        backButton.layer.cornerRadius = 5.0
        backButton.layer.borderColor = UIColor(named: "AppRedColor")?.cgColor
        
        passwordTextField.setOutlineColor(UIColor(named: "AccentColor")!, for: .editing)
        passwordTextField.setOutlineColor(UIColor(named: "AppSecondaryColor")!, for: .normal)
        passwordTextField.leadingView = UIImageView(image: UIImage(named: "ic-blue-password"))
        passwordTextField.leadingViewMode = .always
        passwordTextField.label.text = "New password"
        passwordTextField.setNormalLabelColor(UIColor(named: "AppGrayColor")!, for: .normal)
        passwordTextField.setFloatingLabelColor(UIColor(named: "AccentColor")!, for: .editing)
        passwordTextField.setFloatingLabelColor(UIColor(named: "AppSecondaryColor")!, for: .normal)
        
        retypePasswordTextField.setOutlineColor(UIColor(named: "AccentColor")!, for: .editing)
        retypePasswordTextField.setOutlineColor(UIColor(named: "AppSecondaryColor")!, for: .normal)
        retypePasswordTextField.leadingView = UIImageView(image: UIImage(named: "ic-blue-password"))
        retypePasswordTextField.leadingViewMode = .always
        retypePasswordTextField.label.text = "Retype new password"
        retypePasswordTextField.setNormalLabelColor(UIColor(named: "AppGrayColor")!, for: .normal)
        retypePasswordTextField.setFloatingLabelColor(UIColor(named: "AccentColor")!, for: .editing)
        retypePasswordTextField.setFloatingLabelColor(UIColor(named: "AppSecondaryColor")!, for: .normal)
        
    }
    

    
    @IBAction func doneAct(_ sender: Any) {
        
        if isCorrectForm() {
            var password = passwordTextField.text!
            
            do {
                let salt = try BCrypt.Salt()
                let hashed = try BCrypt.Hash(password, salt: salt)
                password = hashed
                print("Hashed result is: \(hashed)")
            }
            catch {
                print("An error occured: \(error)")
            }
            
            let userCollection = Firestore.firestore().collection("users")
                        
            userCollection.whereField("phone", isEqualTo: fullPhoneNumber).limit(to: 1)
                .getDocuments{ [self](querySnapshot, error) in
                if let error = error {
                    print(error)
                } else {
                    if querySnapshot!.documents.count == 1 {
                        let data = querySnapshot?.documents[0].data()
                        print("full phone \(self.fullPhoneNumber)")
                        userCollection.document(data?["UID"] as! String).updateData(["password": password])
                        
                        let appearance = SCLAlertView.SCLAppearance(
                            kButtonFont: UIFont(name: "HelveticaNeue", size: 17)!,
                            showCloseButton: false, showCircularIcon: false
                        )
                        
                        let alertView = SCLAlertView(appearance: appearance)
                       
                        alertView.addButton("Back to Login") {
                            let vc = self.presentingViewController
                            
                            self.dismiss(animated: false, completion: {
                                let dest = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                
                                dest.modalPresentationStyle = .fullScreen
                                vc?.present(dest, animated: false, completion: nil)
                            })
                        }
                            
                        alertView.showSuccess("Successful", subTitle: "Change password successfully")
                    }
                }
            }

    }
        
        
}
    
    func isSame(_ password: String, _ retype: String) -> Bool {
        return password == retype
    }
    
    func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else { return false }
     
        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: testStr)
    }
    
    func isCorrectForm() -> Bool {
        var result = true
        var alertMessage = ""
        
        
        if (passwordTextField.text! == "" && result == true) {
            alertMessage = "Password must be filled"
            
            result = false
        }
        
        if (retypePasswordTextField.text! == "" && result == true) {
            alertMessage = "Retype password must be filled"
            
            result = false
        }
        
        if (result == true && !isValidPassword(testStr: passwordTextField.text!)) {
            alertMessage = "Weak password. Password must include at least one uppercase, one lowercase, one digit and 8 characters total "
            
            result = false
        }
        
        if (result == true && !isSame(passwordTextField.text!, retypePasswordTextField.text!)) {
            alertMessage = "password and retype must be same"
            
            result = false
        }
        
        
        if (result == false) {
            let appearance = SCLAlertView.SCLAppearance(
                kButtonFont: UIFont(name: "HelveticaNeue", size: 17)!,
                showCloseButton: false, showCircularIcon: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton("CANCEL", backgroundColor: UIColor(named: "AppRedColor"), textColor: .white, showTimeout: .none, action: {
                alertView.dismiss(animated: true, completion: nil)
            })
            
            alertView.showWarning("Warning", subTitle: alertMessage)
        }
        
        return result
    }
    
    @IBAction func backAct(_ sender: Any) {
        let vc = self.presentingViewController
        
        self.dismiss(animated: false, completion: {
            let dest = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            
            dest.modalPresentationStyle = .fullScreen
            vc?.present(dest, animated: false, completion: nil)
        })
    }
}
