//
//  FillInfoViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 12/5/20.
//

import UIKit
import MaterialComponents
import BottomPopUpView
import Firebase
import FirebaseStorage
import BCrypt
import Photos
import ALCameraViewController
import SCLAlertView
import ProgressHUD

class FillInfoViewController: UIViewController {

    @IBOutlet weak var avtPickerButton: UIButton!
    @IBOutlet weak var userfullNameTextField: MDCOutlinedTextField!
    @IBOutlet weak var emailTextField: MDCOutlinedTextField!
    @IBOutlet weak var dobTextField: MDCOutlinedTextField!
    @IBOutlet weak var genderTextField: MDCOutlinedTextField!
    @IBOutlet weak var addressTextField: MDCOutlinedTextField!
    @IBOutlet weak var finishButton: MDCButton!
    @IBOutlet weak var backButton: UIButton!
    
    let dateFormatter = DateFormatter()
    let genders: [String] = ["Male", "Female"]
    
    var bottomPopUpView: BottomPopUpView!
    var datePicker: UIDatePicker!
    var genderPickerView: UIPickerView!
    
    var username = ""
    var userFullName = ""
    var userEmail = ""
    var password = ""
    var phone = ""
    var profileImageURL = ""
    var UID = ""
    var token = ""
    var isCorrect = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        genderPickerView = UIPickerView()
        genderPickerView.dataSource = self
        genderPickerView.delegate = self
        
        initView()
        
        print(token)
    }
    
    func initView() {
        
        let textFields: [MDCOutlinedTextField] = [userfullNameTextField, emailTextField, dobTextField, genderTextField, addressTextField]
        let leadingIconNames: [String] = ["ic-blue-username", "ic-blue-email", "ic-blue-dob", "ic-blue-gender", "ic-blue-address"]
        let labelForTFs: [String] = ["Your full name", "Email", "Date of birth", "Gender", "Address"]
        
        finishButton.layer.cornerRadius = 5.0
        avtPickerButton.layer.cornerRadius = 68.0
        
        backButton.layer.borderWidth = 1
        backButton.layer.cornerRadius = 5.0
        backButton.layer.borderColor = UIColor(named: "AppRedColor")?.cgColor
        
        for i in 0..<textFields.count {
            textFields[i].setOutlineColor(UIColor(named: "AccentColor")!, for: .editing)
            textFields[i].setOutlineColor(UIColor(named: "AppSecondaryColor")!, for: .normal)
            textFields[i].leadingView = UIImageView(image: UIImage(named: leadingIconNames[i]))
            textFields[i].leadingViewMode = .always
            textFields[i].label.text = labelForTFs[i]
            textFields[i].setNormalLabelColor(UIColor(named: "AppGrayColor")!, for: .normal)
            textFields[i].setFloatingLabelColor(UIColor(named: "AccentColor")!, for: .editing)
        }

        userfullNameTextField.text = userFullName
        emailTextField.text = userEmail
        
    }
    
    @IBAction func datePickerAct(_ sender: Any) {

        bottomPopUpView = BottomPopUpView(wrapperContentHeight: 370)
        let title = UILabel()
        let doneButton = MDCButton()
        let cancelButton = UIButton()
        
        title.text = "Date of birth"
        title.font = UIFont(name: "Helvetica Neue Medium", size: 20.0)
        title.textColor = UIColor(named: "AppTextColor")
        
        doneButton.setTitle("DONE", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.setTitleFont(UIFont(name: "Helvetica Neue", size: 17.0), for: .normal)
        doneButton.layer.cornerRadius = 5.0
        doneButton.backgroundColor = UIColor(named: "AppRedColor")
        doneButton.addTarget(self, action: #selector(pickDateDoneAct(_:)), for: .touchUpInside)
        
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.setTitleColor(UIColor(named: "AppRedColor"), for: .normal)
        cancelButton.backgroundColor = .white
        cancelButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 17.0)
        cancelButton.layer.cornerRadius = 5.0
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor(named: "AppRedColor")?.cgColor
        cancelButton.addTarget(self, action: #selector(dismissDatePicker(_:)), for: .touchUpInside)
        
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.backgroundColor = .white
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints  = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        bottomPopUpView.shouldDismissOnDrag = true
        bottomPopUpView.view.addSubview(datePicker)
        bottomPopUpView.view.addSubview(title)
        bottomPopUpView.view.addSubview(doneButton)
        bottomPopUpView.view.addSubview(cancelButton)
        
        let cancelBtnWC = NSLayoutConstraint(item: cancelButton, attribute: .width, relatedBy: .equal,
                                           toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 160)
        let cancelBtnHC = NSLayoutConstraint(item: cancelButton, attribute: .height, relatedBy: .equal,
                                           toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44)
        let cancelBtnX = NSLayoutConstraint(item: cancelButton, attribute: .trailing, relatedBy: .equal, toItem: bottomPopUpView.view, attribute: .centerX, multiplier: 1, constant: -20)
        let cancelBtnY = NSLayoutConstraint(item: cancelButton, attribute: .bottom, relatedBy: .equal, toItem: bottomPopUpView.view, attribute: .bottom, multiplier: 1, constant: -36)
        
        let doneBtnWC = NSLayoutConstraint(item: doneButton, attribute: .width, relatedBy: .equal,
                                           toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 160)
        let doneBtnHC = NSLayoutConstraint(item: doneButton, attribute: .height, relatedBy: .equal,
                                           toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44)
        let doneBtnX = NSLayoutConstraint(item: doneButton, attribute: .leading, relatedBy: .equal, toItem: bottomPopUpView.view, attribute: .centerX, multiplier: 1, constant: 20)
        let doneBtnY = NSLayoutConstraint(item: doneButton, attribute: .bottom, relatedBy: .equal, toItem: bottomPopUpView.view, attribute: .bottom, multiplier: 1, constant: -36)
        
        
        let datePickerWC = NSLayoutConstraint(item: datePicker!, attribute: .width, relatedBy: .equal,
                                                 toItem: bottomPopUpView.view, attribute: .width, multiplier: 1.0, constant: 0)

        let datePickerHC = NSLayoutConstraint(item: datePicker!, attribute: .height, relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 160)

        let datePickerY = NSLayoutConstraint(item: datePicker!, attribute: .bottom, relatedBy: .equal, toItem: cancelButton, attribute: .top, multiplier: 1, constant: -14)
        
        
        let titleX = NSLayoutConstraint(item: title, attribute: .centerX, relatedBy: .equal, toItem: bottomPopUpView.view, attribute: .centerX, multiplier: 1, constant: 0)
        let titleY = NSLayoutConstraint(item: title, attribute: .bottom, relatedBy: .equal, toItem: datePicker!, attribute: .top, multiplier: 1, constant: -14)

        NSLayoutConstraint.activate([cancelBtnWC, cancelBtnHC, cancelBtnX, cancelBtnY, doneBtnWC, doneBtnHC, doneBtnX, doneBtnY, titleX, titleY, datePickerWC, datePickerHC, datePickerY])
        
        self.present(bottomPopUpView, animated: true, completion: nil)

        
    }
    
    
    @IBAction func genderPickerAct(_ sender: Any) {
        bottomPopUpView = BottomPopUpView(wrapperContentHeight: 308)
        let title = UILabel()
        let doneButton = MDCButton()
        let cancelButton = UIButton()
        
        title.text = "Gender"
        title.font = UIFont(name: "Helvetica Neue Medium", size: 20.0)
        title.textColor = UIColor(named: "AppTextColor")
        
        doneButton.setTitle("DONE", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.setTitleFont(UIFont(name: "Helvetica Neue", size: 17.0), for: .normal)
        doneButton.layer.cornerRadius = 5.0
        doneButton.backgroundColor = UIColor(named: "AppRedColor")
        doneButton.addTarget(self, action: #selector(pickGenderDoneAct(_:)), for: .touchUpInside)
        
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.setTitleColor(UIColor(named: "AppRedColor"), for: .normal)
        cancelButton.backgroundColor = .white
        cancelButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 17.0)
        cancelButton.layer.cornerRadius = 5.0
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor(named: "AppRedColor")?.cgColor
        cancelButton.addTarget(self, action: #selector(dismissGenderPicker(_:)), for: .touchUpInside)
        
        genderPickerView.backgroundColor = .white
        
        genderPickerView.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints  = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        bottomPopUpView.shouldDismissOnDrag = true
        bottomPopUpView.view.addSubview(genderPickerView)
        bottomPopUpView.view.addSubview(title)
        bottomPopUpView.view.addSubview(doneButton)
        bottomPopUpView.view.addSubview(cancelButton)
           
        let cancelBtnWC = NSLayoutConstraint(item: cancelButton, attribute: .width, relatedBy: .equal,
                                           toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 160)
        let cancelBtnHC = NSLayoutConstraint(item: cancelButton, attribute: .height, relatedBy: .equal,
                                           toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44)
        let cancelBtnX = NSLayoutConstraint(item: cancelButton, attribute: .trailing, relatedBy: .equal, toItem: bottomPopUpView.view, attribute: .centerX, multiplier: 1, constant: -20)
        let cancelBtnY = NSLayoutConstraint(item: cancelButton, attribute: .bottom, relatedBy: .equal, toItem: bottomPopUpView.view, attribute: .bottom, multiplier: 1, constant: -36)
        
        let doneBtnWC = NSLayoutConstraint(item: doneButton, attribute: .width, relatedBy: .equal,
                                           toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 160)
        let doneBtnHC = NSLayoutConstraint(item: doneButton, attribute: .height, relatedBy: .equal,
                                           toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44)
        let doneBtnX = NSLayoutConstraint(item: doneButton, attribute: .leading, relatedBy: .equal, toItem: bottomPopUpView.view, attribute: .centerX, multiplier: 1, constant: 20)
        let doneBtnY = NSLayoutConstraint(item: doneButton, attribute: .bottom, relatedBy: .equal, toItem: bottomPopUpView.view, attribute: .bottom, multiplier: 1, constant: -36)
        
        
        let datePickerWC = NSLayoutConstraint(item: genderPickerView!, attribute: .width, relatedBy: .equal,
                                                 toItem: bottomPopUpView.view, attribute: .width, multiplier: 1.0, constant: 0)

        let datePickerHC = NSLayoutConstraint(item: genderPickerView!, attribute: .height, relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)

        let datePickerY = NSLayoutConstraint(item: genderPickerView!, attribute: .bottom, relatedBy: .equal, toItem: cancelButton, attribute: .top, multiplier: 1, constant: -14)
        
        
        let titleX = NSLayoutConstraint(item: title, attribute: .centerX, relatedBy: .equal, toItem: bottomPopUpView.view, attribute: .centerX, multiplier: 1, constant: 0)
        let titleY = NSLayoutConstraint(item: title, attribute: .bottom, relatedBy: .equal, toItem: genderPickerView!, attribute: .top, multiplier: 1, constant: -8)

        NSLayoutConstraint.activate([cancelBtnWC, cancelBtnHC, cancelBtnX, cancelBtnY, doneBtnWC, doneBtnHC, doneBtnX, doneBtnY, titleX, titleY, datePickerWC, datePickerHC, datePickerY])
        
        self.present(bottomPopUpView, animated: true, completion: nil)
    }
    
    @IBAction func avtPickerAct(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Attach Photo",
                                            message: "Where would you like to attach a photo from",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in

          let cameraViewController = CameraViewController { [weak self] image, asset in
              // Do something with your image here.
              self?.dismiss(animated: true, completion: nil)
          }

          self?.present(cameraViewController, animated: true, completion: nil)

        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in

          let imagePickerViewController = PhotoLibraryViewController()
          imagePickerViewController.onSelectionComplete = { asset in

                  // The asset could be nil if the user doesn't select anything
                  guard let asset = asset else {
                      return
                  }

              // Provides a PHAsset object
                  // Retrieve a UIImage from a PHAsset using
                  let options = PHImageRequestOptions()
              options.deliveryMode = .highQualityFormat
              options.isNetworkAccessAllowed = true

                  PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options) { image, _ in
                  if let image = image {
                   
                    self!.avtPickerButton.setImage(image, for: .normal)
                    self!.avtPickerButton.tag = 1;
                    self!.avtPickerButton.imageView?.layer.cornerRadius = self!.avtPickerButton.frame.width / 2
                    
                      imagePickerViewController.dismiss(animated: false, completion: nil)
                      
                  }
              }
          }

          self?.present(imagePickerViewController, animated: true, completion: nil)

        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(actionSheet, animated: true)
    }
    
    func checkForm() {
        var result = false
        var alertMessage = ""
        
        if (userfullNameTextField.text! == "") {
            alertMessage = "full name must be filled"
            
            let appearance = SCLAlertView.SCLAppearance(
                kButtonFont: UIFont(name: "HelveticaNeue", size: 17)!,
                showCloseButton: false, showCircularIcon: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton("CANCEL", backgroundColor: UIColor(named: "AppRedColor"), textColor: .white, showTimeout: .none, action: {
                alertView.dismiss(animated: true, completion: nil)
            })
            
            alertView.showWarning("Warning", subTitle: alertMessage)
            
            return;
        }
        
        if (emailTextField.text! == "") {
            alertMessage = "email must be filled"
            
            let appearance = SCLAlertView.SCLAppearance(
                kButtonFont: UIFont(name: "HelveticaNeue", size: 17)!,
                showCloseButton: false, showCircularIcon: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton("CANCEL", backgroundColor: UIColor(named: "AppRedColor"), textColor: .white, showTimeout: .none, action: {
                alertView.dismiss(animated: true, completion: nil)
            })
            
            alertView.showWarning("Warning", subTitle: alertMessage)
            
            return;
        }
        
        if (!isValidEmail(email: emailTextField.text!)) {
            alertMessage = "email is incorrect"
            
            let appearance = SCLAlertView.SCLAppearance(
                kButtonFont: UIFont(name: "HelveticaNeue", size: 17)!,
                showCloseButton: false, showCircularIcon: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton("CANCEL", backgroundColor: UIColor(named: "AppRedColor"), textColor: .white, showTimeout: .none, action: {
                alertView.dismiss(animated: true, completion: nil)
            })
            
            alertView.showWarning("Warning", subTitle: alertMessage)
            
            return;
        }
        
        db.collection("users").whereField("email", isEqualTo: emailTextField.text!)
            .getDocuments{ (querySnapshot, error) in
                if let error = error {
                    print(error)
                } else {
                    if querySnapshot!.documents.count >= 1 {
                        alertMessage = "email is already exists"
                        
                        let appearance = SCLAlertView.SCLAppearance(
                            kButtonFont: UIFont(name: "HelveticaNeue", size: 17)!,
                            showCloseButton: false, showCircularIcon: false
                        )
                        
                        let alertView = SCLAlertView(appearance: appearance)
                        
                        alertView.addButton("CANCEL", backgroundColor: UIColor(named: "AppRedColor"), textColor: .white, showTimeout: .none, action: {
                            alertView.dismiss(animated: true, completion: nil)
                        })
                        
                        alertView.showWarning("Warning", subTitle: alertMessage)
                        
                        result = false
                    } else {
                        result = true
                    }
                }
            }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute :  {
            self.isCorrect = result;
        })
    }
    
    func isValidEmail(email: String?) -> Bool {
        guard email != nil else { return false }
        
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }
    
    @IBAction func finishFillInfo(_ sender: Any) {
        checkForm()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [self] in
            if (self.isCorrect) {
                ProgressHUD.show()
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
                var newUser = MyUser()
                
                if (UID == "") {
                    UID = UUID().uuidString
                }
                
                newUser.UID = UID
                newUser.address = addressTextField.text ?? ""
                newUser.dateOfBirth = dobTextField.text ?? ""
                newUser.email = emailTextField.text ?? ""
                newUser.fullname = userfullNameTextField.text ?? ""
                newUser.gender = genderTextField.text ?? ""
                newUser.password = password
                newUser.phone = phone
                newUser.username = username
                newUser.token = token
                newUser.avatar = ""
                newUser.favorites = [String]()
                newUser.following = [String]()
                newUser.followers = [String]()
                
                var image = UIImage();
                if (avtPickerButton.tag == 1) {
                    image = avtPickerButton.image(for: .normal)!
                } else {
                    image = UIImage(named: "user_avatar")!
                }
               
        
                StorageManager.shared.uploadImage(with: image.pngData()!, fileName: "avatar.png", folder: "User", subFolder: UID, completion: { [weak self] result in
                    guard let strongSelf = self else {
                        return
                    }

                    switch result {
                    case .success(let urlString):
                        // Ready to send message
                        print("Uploaded Message Photo: \(urlString)")
                        newUser.avatar = urlString
                        
                    case .failure(let error):
                        print("message photo upload error: \(error)")
                    }
                    
                    userCollection.document(newUser.UID).setData([
                            "UID": newUser.UID,
                            "address": newUser.address,
                            "avatar": newUser.avatar,
                            "dateOfBirth" : newUser.dateOfBirth,
                            "email" : newUser.email,
                            "fullname" : newUser.fullname,
                            "gender" : newUser.gender,
                            "password" : newUser.password,
                            "phone": newUser.phone,
                            "username" : newUser.username,
                            "token" : newUser.token,
                            "favorites" : newUser.favorites,
                            "following" : newUser.following,
                            "followers" : newUser.followers,
                            "is_active" : 1
                        ], merge: true)
                        
                        Core.shared.setIsUserLogin(true)
                        Core.shared.setCurrentUserID(newUser.UID)
                    
                        let email = newUser.email
                        let fullName = newUser.fullname
                    
                        Core.shared.setCurrentUserEmail(email)
                        Core.shared.setCurrentUserFullName(fullName)
                        
                        ChatDatabaseManager.shared.insertUser(with: ChatAppUser(fullName: fullName, emailAddress: email), completion: {
                        success in
                            if (success){
                                print("done insert realtime")
                            } else {
                                print("fail insert realtime")
                            }
                        })
                        
                    let fillInfoVC = self?.presentingViewController
                        
                    self!.dismiss(animated: true, completion: {
                        ProgressHUD.dismiss()
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let dest = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                        
                        dest.modalPresentationStyle  = .fullScreen
                        
                        Core.shared.setIsNotFirstLauchApp()
                        
                        fillInfoVC?.present(dest, animated: true, completion: nil)
                    })
                })
            }
        }
    }
    
    @objc func dismissDatePicker(_ sender: Any) {
        bottomPopUpView.dismiss(animated: true, completion: nil)
    }
    
    @objc func pickDateDoneAct(_ sender: Any) {
        dobTextField.text = dateFormatter.string(from: datePicker.date)
        bottomPopUpView.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissGenderPicker(_ sender: Any) {
        bottomPopUpView.dismiss(animated: true, completion: nil)
    }
    
    @objc func pickGenderDoneAct(_ sender: Any) {
        genderTextField.text = genders[genderPickerView.selectedRow(inComponent: 0)]
        bottomPopUpView.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func backAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension FillInfoViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]

    }
}

extension FillInfoViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            
            avtPickerButton.setBackgroundImage(image, for: .normal)
            avtPickerButton.imageView?.layer.cornerRadius = avtPickerButton.frame.width / 2
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
