//
//  ChangePasswordViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 1/21/21.
//

import UIKit
import MaterialComponents
import BCrypt

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
        let password = oldPasswordTextField.text ?? ""
        var newPassword = newPasswordTextField.text ?? ""
        let retypeNew = retypeNewPasswordTextField.text ?? ""
        
        if (password == "") {
            //alert khong dc de trong
            print("1")
            return
        }
        
        if (newPassword == "") {
            //alert khong dc bo trong
            print("1")
            return
        }
        
        if (retypeNew == "") {
            //alert khong dc bo trong
            print("1")
            return
        }
        
        db.collection("users").document(Core.shared.getCurrentUserID()).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                
                let correctPassword = data?["password"] as! String
                
                if (BCrypt.Check(password, hashed: correctPassword)) {
                    if (!self.isValidPassword(testStr: newPassword)) {
                        //alert mat khau yeu
                        print("yeu")
                        return
                    } else {
                        if (newPassword != retypeNew) {
                            //alert nhap lai mat khau khong chinh xac
                            return
                        } else {
                            do {
                                let salt = try BCrypt.Salt()
                                let hashed = try BCrypt.Hash(newPassword, salt: salt)
                                newPassword = hashed
                                print("Hashed result is: \(hashed)")
                                
                                db.collection("users").document(Core.shared.getCurrentUserID()).updateData(["password" : newPassword])
                                //alert thay doi thanh cong
                                print("ok")
                                //mini reset
                                self.oldPasswordTextField.text = ""
                                self.newPasswordTextField.text = ""
                                self.retypeNewPasswordTextField.text = ""
                                
                                self.dismiss(animated: true, completion: nil)
                            }
                            catch {
                                print("An error occured: \(error)")
                            }
                        }
                    }

                } else {
                    //alert sai mat khau
                    return
                }
                
            } else {
                print("Document does not exist")
            }
        }
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
    
    @IBAction func cancelAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
