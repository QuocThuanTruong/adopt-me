//
//  UpdateMyProfileViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 1/20/21.
//

import UIKit
import MaterialComponents
import BottomPopUpView
import Firebase
import FirebaseStorage
import BCrypt
import Photos
import ALCameraViewController
import Nuke

protocol UpdateInfoDelegate: class {
    func updateChangeInfo()
}

class UpdateMyProfileViewController: UIViewController {

    @IBOutlet weak var avtPickerButton: UIButton!
    @IBOutlet weak var userfullNameTextField: MDCOutlinedTextField!
    @IBOutlet weak var emailTextField: MDCOutlinedTextField!
    @IBOutlet weak var dobTextField: MDCOutlinedTextField!
    @IBOutlet weak var genderTextField: MDCOutlinedTextField!
    @IBOutlet weak var addressTextField: MDCOutlinedTextField!
    @IBOutlet weak var finishButton: MDCButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    let dateFormatter = DateFormatter()
    let genders: [String] = ["Male", "Female"]
    
    var bottomPopUpView: BottomPopUpView!
    var datePicker: UIDatePicker!
    var genderPickerView: UIPickerView!
    var delegate: UpdateInfoDelegate?
    
    var username = ""
    var userFullName = ""
    var userEmail = ""
    var password = ""
    var phone = ""
    var profileImageURL = ""
    var UID = ""
    
    var context: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        genderPickerView = UIPickerView()
        genderPickerView.dataSource = self
        genderPickerView.delegate = self
        
        initView()
        
    }
    

    func initView() {
        Nuke.DataLoader.sharedUrlCache.removeAllCachedResponses()
        
        let textFields: [MDCOutlinedTextField] = [userfullNameTextField, emailTextField, dobTextField, genderTextField, addressTextField]
        let leadingIconNames: [String] = ["ic-blue-username", "ic-blue-email", "ic-blue-dob", "ic-blue-gender", "ic-blue-address"]
        let labelForTFs: [String] = ["Your full name", "Email", "Date of birth", "Gender", "Address"]
        
        finishButton.layer.cornerRadius = 5.0
        avtPickerButton.layer.cornerRadius = 68.0
        
        cancelButton.layer.cornerRadius = 5.0
        cancelButton.layer.borderWidth = 1.0
        cancelButton.layer.borderColor = UIColor(named: "AppRedColor")!.cgColor
        
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
        
        db.collection("users").document(Core.shared.getCurrentUserID()).getDocument { [self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                
                let urlStr = URL(string: (data?["avatar"] as! String))
                let urlReq = URLRequest(url: urlStr!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
                let image = UIImageView()
                
                Nuke.loadImage(with: urlReq, into: image)
                avtPickerButton.setImage(image.image, for: .normal)
                avtPickerButton.imageView?.layer.cornerRadius = avtPickerButton.frame.width / 2
                
                print("load avatar ne")
                userfullNameTextField.text = data?["fullname"] as? String
                emailTextField.text = data?["email"] as? String
                dobTextField.text = data?["dateOfBirth"] as? String
                genderTextField.text = data?["gender"] as? String
                addressTextField.text = data?["address"] as? String
                

                } else {
                    print("Document does not exist")
                }
        }
        
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
                    self!.avtPickerButton.imageView?.layer.cornerRadius = 68.0
                    self!.avtPickerButton.tag = 1;
                    
                      imagePickerViewController.dismiss(animated: false, completion: nil)
                      
                  }
              }
          }

          self?.present(imagePickerViewController, animated: true, completion: nil)

        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(actionSheet, animated: true)
    }
    
    @IBAction func finishUpdateInfo(_ sender: Any) {
        let userCollection = db.collection("users")
        
        var user = MyUser()
        
        user.UID = Core.shared.getCurrentUserID()
        user.address = addressTextField.text ?? ""
        user.dateOfBirth = dobTextField.text ?? ""
        user.email = emailTextField.text ?? ""
        user.fullname = userfullNameTextField.text ?? ""
        user.gender = genderTextField.text ?? ""
        user.avatar = ""

        
        if (avtPickerButton.tag == 1) {
            let image = avtPickerButton.image(for: .normal)
    
            DispatchQueue.global().async {
                StorageManager.shared.uploadImage(with: image!.pngData()!, fileName: UUID().uuidString + ".png", folder: "User", subFolder: user.UID, completion: { result in

                    switch result {
                    case .success(let urlString):
                        // Ready to send message
                        print("Uploaded Message Photo: \(urlString)")
                        user.avatar = urlString
                        
                    case .failure(let error):
                        print("message photo upload error: \(error)")
                    }
                    
                    userCollection.document(user.UID).updateData([
                        "address": user.address,
                        "avatar": user.avatar,
                        "dateOfBirth" : user.dateOfBirth,
                        "email" : user.email,
                        "fullname" : user.fullname,
                        "gender" : user.gender,
                    ])
                    
                    let urlStr = URL(string: user.avatar)
                    let urlReq = URLRequest(url: urlStr!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
                    let image = UIImageView()
                    
                    Nuke.loadImage(with: urlReq, into: image)
                    self.avtPickerButton.setImage(image.image, for: .normal)
                    
                    
                    Core.shared.setIsUserLogin(true)
                    let email = user.email
                    let fullName = user.fullname
                    Core.shared.setCurrentUserEmail(email)
                    Core.shared.setCurrentUserFullName(fullName)
                    
                    ChatDatabaseManager.shared.updateUserName(with: ChatAppUser(fullName: fullName, emailAddress: email), completion: {
                    success in
                        if (success){
                            print("done insert realtime")
                        } else {
                            print("fail insert realtime")
                        }
                    })
                
                    DispatchQueue.main.async {
                        self.delegate?.updateChangeInfo()
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
            
        } else {
            DispatchQueue.global().async {
                userCollection.document(user.UID).updateData([
                        "address": user.address,
                        "dateOfBirth" : user.dateOfBirth,
                        "email" : user.email,
                        "fullname" : user.fullname,
                        "gender" : user.gender,
                    ])
                
                Core.shared.setIsUserLogin(true)
                let email = user.email
                let fullName = user.fullname
                Core.shared.setCurrentUserEmail(email)
                Core.shared.setCurrentUserFullName(fullName)
                
                ChatDatabaseManager.shared.updateUserName(with: ChatAppUser(fullName: fullName, emailAddress: email), completion: {
                success in
                    if (success){
                        print("done insert realtime")
                    } else {
                        print("fail insert realtime")
                    }
                })
                
                DispatchQueue.main.async {
                    self.delegate?.updateChangeInfo()
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        }
        
    }
    
    @IBAction func cancelAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
}

extension UpdateMyProfileViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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

extension UpdateMyProfileViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            
            avtPickerButton.setBackgroundImage(image, for: .normal)
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


