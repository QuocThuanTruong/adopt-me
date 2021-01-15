//
//  LoginViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 12/5/20.
//

import UIKit
import MaterialComponents
import M13Checkbox
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import Firebase
import BCrypt

class LoginViewController: UIViewController {
    @IBOutlet weak var ggLoginButton: GIDSignInButton!
    @IBOutlet weak var LoginStatusLabel: UILabel!
    @IBOutlet weak var usernameTextField: MDCOutlinedTextField!
    @IBOutlet weak var passwordTextField: MDCOutlinedTextField!
    @IBOutlet weak var loginManuallyButton: MDCButton!
    @IBOutlet weak var rememberMeCheckbox: M13Checkbox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let token = Core.shared.getToken()
        
        if token != "" {
            let userCollection = Firestore.firestore().collection("users")
            
            userCollection.whereField("token", isEqualTo: token).limit(to: 1)
                .getDocuments{ [self] (querySnapshot, error) in
                    if let error = error {
                        print(error)
                    } else {
                        if querySnapshot!.documents.count == 1 {
                           loginManual()
                        }
                    }
                }
        }
        
        initView()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self

    }
    
    func initView() {
        loginManuallyButton.layer.cornerRadius = 5.0
        
        usernameTextField.setOutlineColor(UIColor(named: "AccentColor")!, for: .editing)
        usernameTextField.setOutlineColor(UIColor(named: "AppSecondaryColor")!, for: .normal)
        usernameTextField.leadingView = UIImageView(image: UIImage(named: "ic-blue-username"))
        usernameTextField.leadingViewMode = .always
        usernameTextField.label.text = "Username"
        usernameTextField.setNormalLabelColor(UIColor(named: "AppGrayColor")!, for: .normal)
        usernameTextField.setFloatingLabelColor(UIColor(named: "AccentColor")!, for: .editing)
        
        passwordTextField.setOutlineColor(UIColor(named: "AccentColor")!, for: .editing)
        passwordTextField.setOutlineColor(UIColor(named: "AppSecondaryColor")!, for: .normal)
        passwordTextField.leadingView = UIImageView(image: UIImage(named: "ic-blue-password"))
        passwordTextField.leadingViewMode = .always
        passwordTextField.label.text = "Password"
        passwordTextField.setNormalLabelColor(UIColor(named: "AppGrayColor")!, for: .normal)
        passwordTextField.setFloatingLabelColor(UIColor(named: "AccentColor")!, for: .editing)
    }
    
    func loginManual() {
        Core.shared.setIsUserLogin(true)
        
        let fillInfoVC = self.presentingViewController
        
        self.dismiss(animated: true, completion: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let dest = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            
            dest.modalPresentationStyle  = .fullScreen
            
            
            Core.shared.setIsNotFirstLauchApp()
            
            fillInfoVC?.present(dest, animated: true, completion: nil)
        })
    }
    
    func loginFirebase()  {
        let currentUser = Auth.auth().currentUser
        
        let userCollection = Firestore.firestore().collection("users")
        
        userCollection.whereField("UID", isEqualTo: currentUser!.uid).limit(to: 1)
            .getDocuments{ (querySnapshot, error) in
                if let error = error {
                    print(error)
                } else {
                    if querySnapshot!.documents.count == 1 {
                        let data = querySnapshot?.documents[0].data()
                        
                        let token = UUID().uuidString
                        
                        Core.shared.setToken(token)
                        userCollection.document(data?["UID"] as! String).updateData(["token": token])

                        self.loginManual()
                    } else {
                        let registerVC = self.presentingViewController
                        
                        self.dismiss(animated: true, completion: {
                            let dest = self.storyboard?.instantiateViewController(withIdentifier: "FillInfoViewController") as! FillInfoViewController
                            
                            dest.modalPresentationStyle = .fullScreen
                            
                            dest.userFullName = currentUser?.displayName ?? ""
                            dest.phone = currentUser?.phoneNumber ?? ""
                            dest.userEmail = currentUser?.email ?? ""
                            dest.UID = currentUser!.uid
                            dest.token = UUID().uuidString
                            
                            Core.shared.setToken(dest.token)
                            
                            registerVC?.present(dest, animated: true, completion: nil)
                        })
                    }
                }
            }
    }
    
    @IBAction func loginWithFBAct(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }

            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                } else {
                    self.loginFirebase()
                }
            })
        }
    }
    
    @IBAction func loginWithGGAct(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func loginManuallyAct(_ sender: Any) {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        let userCollection = Firestore.firestore().collection("users")

        userCollection.whereField("username", isEqualTo: username).limit(to: 1)
            .getDocuments{ [self](querySnapshot, error) in
                if let error = error {
                    print(error)
                } else {
                    if querySnapshot!.documents.count == 1 {
                        let data = querySnapshot?.documents[0].data()
                        
                        if (BCrypt.Check(password, hashed: data?["password"] as! String)) {
                            
                            if (rememberMeCheckbox.checkState == M13Checkbox.CheckState.checked) {
                                let token = UUID().uuidString
                                Core.shared.setToken(token)
                                
                                userCollection.document(data?["UID"] as! String).updateData(["token": token])
                            }
                            
                            self.loginManual()
                        }
                    }
                }
        }
    }
    
    @IBAction func forgotPasswordAct(_ sender: Any) {
        
    }
    
    @IBAction func registerAct(_ sender: Any) {
        let loginVC = self.presentingViewController
        
        self.dismiss(animated: true, completion: {
            let dest = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
            
            dest.modalPresentationStyle = .fullScreen
            loginVC?.present(dest, animated: true, completion: nil)
        })
       
        
    }
}

extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (user != nil) {
            print("User email: \(user.profile.email ?? "No email")")
            print(user.profile.name ?? "no name")
            
            //Firebase sign in
            guard let authentication = user.authentication else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print("Firebase sign in error")
                    print(error)
                    
                    return
                }
                
                self.loginFirebase()
            }
        }
    }
}