//
//  AddPostViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 12/8/20.
//

import UIKit
import MaterialComponents
import UIFloatLabelTextView
import BottomPopUpView
import Photos
import ALCameraViewController
import FirebaseStorage
import SCLAlertView
import ProgressHUD

class AddPetViewController: UIViewController {

    @IBOutlet weak var petNameTextField: MDCOutlinedTextField!
    @IBOutlet weak var petAgeTextField: MDCOutlinedTextField!
    @IBOutlet weak var petGenderTextField: MDCOutlinedTextField!
    @IBOutlet weak var petAddressTextField: MDCOutlinedTextField!
    @IBOutlet weak var petDescriptionBorder: UIButton!
    @IBOutlet weak var petDescriptionLabelBg: UIButton!
    @IBOutlet weak var petDescriptionDummy: MDCOutlinedTextField!
    @IBOutlet weak var petDescriptionTextView: UITextView!
    @IBOutlet weak var petTypeTextField: MDCOutlinedTextField!
    
    
    @IBOutlet weak var avatarPickerButton: UIButton!
    @IBOutlet weak var petImage1Button: UIButton!
    @IBOutlet weak var petImage2Button: UIButton!
    @IBOutlet weak var petImage3Button: UIButton!
    @IBOutlet weak var addPetButton: MDCButton!
    
    
    
    var genderPickerView: UIPickerView!
    var typePickerView: UIPickerView!
    var bottomPopUpView: BottomPopUpView!
    
    let genderPickerViewDelegate = GenderPickerViewDelegate()
    let typePickerViewDelegate = PetTypePickerViewDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        initView()
    }
    
    func initView() {
        
        genderPickerViewDelegate.genders = ["Male", "Female"]
        
        let textFields: [MDCOutlinedTextField] = [petNameTextField, petAgeTextField, petGenderTextField, petAddressTextField, petTypeTextField]
        let leadingIconNames: [String] = ["ic-blue-petname", "ic-blue-age", "ic-blue-gender", "ic-blue-address", "ic-blue-petname"]
        let labelForTFs: [String] = ["Your pet name", "Age", "Gender", "Address", "Type"]
        let buttons: [UIButton] = [petImage1Button, petImage2Button, petImage3Button]
        
        addPetButton.layer.cornerRadius = 5.0
        avatarPickerButton.layer.cornerRadius = 59.0
        
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
        
        petAgeTextField.clearButtonMode = .never
        
        petDescriptionDummy.setOutlineColor(UIColor.white.withAlphaComponent(0.0), for: .editing)
        petDescriptionDummy.setOutlineColor(UIColor.white.withAlphaComponent(0.0), for: .normal)
        petDescriptionDummy.label.text = "Description"
        petDescriptionDummy.setNormalLabelColor(UIColor(named: "AppGrayColor")!, for: .normal)
        petDescriptionDummy.setFloatingLabelColor(UIColor(named: "AccentColor")!, for: .editing)
        petDescriptionDummy.setFloatingLabelColor(UIColor(named: "AppSecondaryColor")!, for: .normal)
        
        petDescriptionBorder.layer.cornerRadius = 5.0
        petDescriptionBorder.layer.borderWidth = 1.0
        petDescriptionBorder.layer.borderColor = UIColor(named: "AppSecondaryColor")?.cgColor
        
        petDescriptionLabelBg.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        
        petDescriptionTextView.delegate = self
       
        for i in 0..<buttons.count {
            buttons[i].layer.cornerRadius = 13.0
            buttons[i].layer.borderWidth = 1.0
            buttons[i].layer.borderColor = UIColor(named: "AccentColor")?.cgColor
        }
        
        genderPickerView = UIPickerView()
        genderPickerView.delegate = genderPickerViewDelegate
        genderPickerView.dataSource = genderPickerViewDelegate
        
        typePickerView = UIPickerView()
        typePickerView.delegate = typePickerViewDelegate
        typePickerView.dataSource = typePickerViewDelegate
        
    }
    
    @IBAction func act_pickPetAvatar(_ sender: Any) {
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
                   
                    self!.avatarPickerButton.setImage(image, for: .normal)
                    self!.avatarPickerButton.tag = 1
                    self!.avatarPickerButton.imageView?.layer.cornerRadius = 59.0
                    
                      imagePickerViewController.dismiss(animated: false, completion: nil)
                      
                  }
              }
          }

          self?.present(imagePickerViewController, animated: true, completion: nil)

        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(actionSheet, animated: true)
    }
    
    @IBAction func act_pickImage1(_ sender: Any) {
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
                     
                    self!.petImage1Button.setImage(image, for: .normal)
                    self!.petImage1Button.tag = 1
                    self!.petImage1Button.imageView?.layer.cornerRadius = 13.0
                      
                      imagePickerViewController.dismiss(animated: false, completion: nil)
                      
                  }
              }
          }

          self?.present(imagePickerViewController, animated: true, completion: nil)

        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(actionSheet, animated: true)
    }
    
    
    @IBAction func act_pickImage2(_ sender: Any) {
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
                     
                    self!.petImage2Button.setImage(image, for: .normal)
                    self!.petImage2Button.tag = 1
                    self!.petImage2Button.imageView?.layer.cornerRadius = 13.0
                      
                      imagePickerViewController.dismiss(animated: false, completion: nil)
                      
                  }
              }
          }

          self?.present(imagePickerViewController, animated: true, completion: nil)

        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(actionSheet, animated: true)
    }
    
    
    @IBAction func act_pickImage3(_ sender: Any) {
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
                     
                    self!.petImage3Button.setImage(image, for: .normal)
                    self!.petImage3Button.tag = 1
                    self!.petImage3Button.imageView?.layer.cornerRadius = 13.0
                      
                      imagePickerViewController.dismiss(animated: false, completion: nil)
                      
                  }
              }
          }

          self?.present(imagePickerViewController, animated: true, completion: nil)

        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(actionSheet, animated: true)
    }
    
    @IBAction func act_AddPet(_ sender: Any) {
        var newPet = Pet()
        
        newPet.name = petNameTextField.text ?? ""
        if (newPet.name == "") {
            let appearance = SCLAlertView.SCLAppearance(
                kButtonFont: UIFont(name: "HelveticaNeue", size: 17)!,
                showCloseButton: false, showCircularIcon: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton("CANCEL", backgroundColor: UIColor(named: "AppRedColor"), textColor: .white, showTimeout: .none, action: {
                alertView.dismiss(animated: true, completion: nil)
            })
            
            alertView.showWarning("Warning", subTitle: "your pet's name must be filled")
            print("1")
            return
        }

        newPet.age = Int(petAgeTextField.text ?? "0") ?? 0
        if (newPet.age == 0) {
            let appearance = SCLAlertView.SCLAppearance(
                kButtonFont: UIFont(name: "HelveticaNeue", size: 17)!,
                showCloseButton: false, showCircularIcon: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton("CANCEL", backgroundColor: UIColor(named: "AppRedColor"), textColor: .white, showTimeout: .none, action: {
                alertView.dismiss(animated: true, completion: nil)
            })
            
            alertView.showWarning("Warning", subTitle: "your pet's age must be filled")
            print("2")
            return
        }

        newPet.address = petAddressTextField.text ?? ""
        if (newPet.address == "") {
            let appearance = SCLAlertView.SCLAppearance(
                kButtonFont: UIFont(name: "HelveticaNeue", size: 17)!,
                showCloseButton: false, showCircularIcon: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton("CANCEL", backgroundColor: UIColor(named: "AppRedColor"), textColor: .white, showTimeout: .none, action: {
                alertView.dismiss(animated: true, completion: nil)
            })
            
            alertView.showWarning("Warning", subTitle: "your pet's address must be filled")
            print("3")
            return
        }

        newPet.description = petDescriptionTextView.text ?? ""
        if (newPet.description == "") {
            let appearance = SCLAlertView.SCLAppearance(
                kButtonFont: UIFont(name: "HelveticaNeue", size: 17)!,
                showCloseButton: false, showCircularIcon: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton("CANCEL", backgroundColor: UIColor(named: "AppRedColor"), textColor: .white, showTimeout: .none, action: {
                alertView.dismiss(animated: true, completion: nil)
            })
            
            alertView.showWarning("Warning", subTitle: "your pet's description must be filled")
            print("4")
            return
        }
        
        let genderText = petGenderTextField.text ?? ""
        if (genderText == "") {
            let appearance = SCLAlertView.SCLAppearance(
                kButtonFont: UIFont(name: "HelveticaNeue", size: 17)!,
                showCloseButton: false, showCircularIcon: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton("CANCEL", backgroundColor: UIColor(named: "AppRedColor"), textColor: .white, showTimeout: .none, action: {
                alertView.dismiss(animated: true, completion: nil)
            })
            
            alertView.showWarning("Warning", subTitle: "your pet's gender must be selected")
            print("5")
            return
        }
        newPet.gender = genderText == "Male"
        
        let typeText = petTypeTextField.text ?? "" //Bien text cua gender
        if (typeText == "") {
            let appearance = SCLAlertView.SCLAppearance(
                kButtonFont: UIFont(name: "HelveticaNeue", size: 17)!,
                showCloseButton: false, showCircularIcon: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton("CANCEL", backgroundColor: UIColor(named: "AppRedColor"), textColor: .white, showTimeout: .none, action: {
                alertView.dismiss(animated: true, completion: nil)
            })
            
            alertView.showWarning("Warning", subTitle: "Is he/she a dog, a cat or other?")
            print("10")
            return
        }
        
        newPet.type = typeText == "Dog" ? 1 : (typeText == "Cat" ? 2 : 3)
        
        let avatarImage = avatarPickerButton.image(for: .normal)
        if (avatarPickerButton.tag == 0) {
            let appearance = SCLAlertView.SCLAppearance(
                kButtonFont: UIFont(name: "HelveticaNeue", size: 17)!,
                showCloseButton: false, showCircularIcon: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton("CANCEL", backgroundColor: UIColor(named: "AppRedColor"), textColor: .white, showTimeout: .none, action: {
                alertView.dismiss(animated: true, completion: nil)
            })
            
            alertView.showWarning("Warning", subTitle: "pick an avatar picture for your pet")
            print("6")
            return
        }
        
        let image1 = petImage1Button.image(for: .normal)
        if (petImage1Button.tag == 0) {
            let appearance = SCLAlertView.SCLAppearance(
                kButtonFont: UIFont(name: "HelveticaNeue", size: 17)!,
                showCloseButton: false, showCircularIcon: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton("CANCEL", backgroundColor: UIColor(named: "AppRedColor"), textColor: .white, showTimeout: .none, action: {
                alertView.dismiss(animated: true, completion: nil)
            })
            
            alertView.showWarning("Warning", subTitle: "pick 3 picture for your pet")
            print("7")
            return
        }
        
        let image2 = petImage2Button.image(for: .normal)
        if (petImage2Button.tag == 0) {
            let appearance = SCLAlertView.SCLAppearance(
                kButtonFont: UIFont(name: "HelveticaNeue", size: 17)!,
                showCloseButton: false, showCircularIcon: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton("CANCEL", backgroundColor: UIColor(named: "AppRedColor"), textColor: .white, showTimeout: .none, action: {
                alertView.dismiss(animated: true, completion: nil)
            })
            
            alertView.showWarning("Warning", subTitle: "he/she needs 2 more pictures")
            print("8")
            return
        }
        
        let image3 = petImage3Button.image(for: .normal)
        if (petImage2Button.tag == 0) {
            let appearance = SCLAlertView.SCLAppearance(
                kButtonFont: UIFont(name: "HelveticaNeue", size: 17)!,
                showCloseButton: false, showCircularIcon: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton("CANCEL", backgroundColor: UIColor(named: "AppRedColor"), textColor: .white, showTimeout: .none, action: {
                alertView.dismiss(animated: true, completion: nil)
            })
            
            alertView.showWarning("Warning", subTitle: "he/she needs 1 more picture")
            print("9")
            return
        }
        
        newPet.user_id = Core.shared.getCurrentUserID()
        newPet.pet_id = UUID().uuidString
        
        ProgressHUD.show()
        //upload Avatar
        StorageManager.shared.uploadImage(with: avatarImage!.pngData()!, fileName: "avatar.png", folder: "Pet", subFolder: newPet.pet_id, completion: {  result in
                switch result {
                case .success(let urlString):
                    // Ready to send message
                    print("Uploaded avatar Photo: \(urlString)")
                    newPet.avatar = urlString
                case .failure(let error):
                    print("message photo upload error: \(error)")
                    
                    return
                }
            //Image1
            StorageManager.shared.uploadImage(with: image1!.pngData()!, fileName: "1.png", folder: "Pet", subFolder: newPet.pet_id, completion: { result in
                    switch result {
                    case .success(let urlString):
                        // Ready to send message
                        print("Uploaded image 1 Photo: \(urlString)")
                        newPet.images.append(urlString)
                    case .failure(let error):
                        print("message photo upload error: \(error)")
                        
                        return
                    }
                //Image2
                StorageManager.shared.uploadImage(with: image2!.pngData()!, fileName: "2.png", folder: "Pet", subFolder: newPet.pet_id, completion: { result in
                    
                        switch result {
                        case .success(let urlString):
                            // Ready to send message
                            print("Uploaded image 2 Photo: \(urlString)")
                            newPet.images.append(urlString)
                        case .failure(let error):
                            print("message photo upload error: \(error)")
                            
                            return
                        }
                    //Image3
                    StorageManager.shared.uploadImage(with: image3!.pngData()!, fileName: "3.png", folder: "Pet", subFolder: newPet.pet_id, completion: { result in
                            switch result {
                            case .success(let urlString):
                                // Ready to send message
                                print("Uploaded image 3 Photo: \(urlString)")
                                newPet.images.append(urlString)
                            case .failure(let error):
                                print("message photo upload error: \(error)")
                                
                                return
                            }
                        print(newPet)
                        
                        db.collection("pets").document(newPet.pet_id).setData([
                            "address": newPet.address,
                            "age": newPet.age,
                            "avatar" : newPet.avatar,
                            "description" : newPet.description,
                            "images" : newPet.images,
                            "gender" : newPet.gender,
                            "is_active" : 1,
                            "name": newPet.name,
                            "pet_id" : newPet.pet_id,
                            "posted_date" : Date(),
                            "type" : newPet.type,
                            "user_id" : newPet.user_id
                        ], merge: true)
                        
                        //Alert thanh cong
                        ProgressHUD.dismiss()
                        let appearance = SCLAlertView.SCLAppearance(
                            kButtonFont: UIFont(name: "HelveticaNeue", size: 17)!,
                            showCloseButton: false, showCircularIcon: false
                        )
                        
                        let alertView = SCLAlertView(appearance: appearance)
                        alertView.addButton("OK", action: {
                            alertView.dismiss(animated: true, completion: nil)
                        })
                        alertView.showSuccess("Congratulation", subTitle: "Your pet has been added successfully")
                        
                        self.resetAct((Any).self)
                        }
                    )
                    }
                )
                }
            )
            }
        )
        
       
    }
    
    @IBAction func pickTypeAct(_ sender: Any) {
        bottomPopUpView = BottomPopUpView(wrapperContentHeight: 308)
        let title = UILabel()
        let doneButton = MDCButton()
        let cancelButton = UIButton()
        
        title.text = "Pet type"
        title.font = UIFont(name: "Helvetica Neue Medium", size: 20.0)
        title.textColor = UIColor(named: "AppTextColor")
        
        doneButton.setTitle("DONE", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.setTitleFont(UIFont(name: "Helvetica Neue", size: 17.0), for: .normal)
        doneButton.layer.cornerRadius = 5.0
        doneButton.backgroundColor = UIColor(named: "AppRedColor")
        doneButton.addTarget(self, action: #selector(pickTypeDoneAct(_:)), for: .touchUpInside)
        
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.setTitleColor(UIColor(named: "AppRedColor"), for: .normal)
        cancelButton.backgroundColor = .white
        cancelButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 17.0)
        cancelButton.layer.cornerRadius = 5.0
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor(named: "AppRedColor")?.cgColor
        cancelButton.addTarget(self, action: #selector(dismissTypePicker(_:)), for: .touchUpInside)
        
        typePickerView.backgroundColor = .white
        
        typePickerView.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints  = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        bottomPopUpView.shouldDismissOnDrag = true
        bottomPopUpView.view.addSubview(typePickerView)
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
        
        
        let datePickerWC = NSLayoutConstraint(item: typePickerView!, attribute: .width, relatedBy: .equal,
                                                 toItem: bottomPopUpView.view, attribute: .width, multiplier: 1.0, constant: 0)

        let datePickerHC = NSLayoutConstraint(item: typePickerView!, attribute: .height, relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)

        let datePickerY = NSLayoutConstraint(item: typePickerView!, attribute: .bottom, relatedBy: .equal, toItem: cancelButton, attribute: .top, multiplier: 1, constant: -14)
        
        
        let titleX = NSLayoutConstraint(item: title, attribute: .centerX, relatedBy: .equal, toItem: bottomPopUpView.view, attribute: .centerX, multiplier: 1, constant: 0)
        let titleY = NSLayoutConstraint(item: title, attribute: .bottom, relatedBy: .equal, toItem: typePickerView!, attribute: .top, multiplier: 1, constant: -8)

        NSLayoutConstraint.activate([cancelBtnWC, cancelBtnHC, cancelBtnX, cancelBtnY, doneBtnWC, doneBtnHC, doneBtnX, doneBtnY, titleX, titleY, datePickerWC, datePickerHC, datePickerY])
        
        self.present(bottomPopUpView, animated: true, completion: nil)
    }
    
    @objc func pickTypeDoneAct(_ sender: Any) {
        petTypeTextField.text = typePickerViewDelegate.types[typePickerView.selectedRow(inComponent: 0)]
        bottomPopUpView.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissTypePicker(_ sender: Any) {
        bottomPopUpView.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickGenderAct(_ sender: Any) {
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
    
    @objc func pickGenderDoneAct(_ sender: Any) {
        petGenderTextField.text = genderPickerViewDelegate.genders[genderPickerView.selectedRow(inComponent: 0)]
        bottomPopUpView.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissGenderPicker(_ sender: Any) {
        bottomPopUpView.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetAct(_ sender: Any) {
        petNameTextField.text = ""
        petAgeTextField.text = ""
        petGenderTextField.text = ""
        petAddressTextField.text = ""
        petDescriptionTextView.text = ""
        petTypeTextField.text = ""
        
        avatarPickerButton.setImage(UIImage(named: "ic-md-blue-imgpicker"), for: .normal)
        petImage1Button.setImage(UIImage(named: "ic-md-blue-imgpicker"), for: .normal)
        petImage2Button.setImage(UIImage(named: "ic-md-blue-imgpicker"), for: .normal)
        petImage3Button.setImage(UIImage(named: "ic-md-blue-imgpicker"), for: .normal)
        
        avatarPickerButton.imageView?.layer.cornerRadius = 0
        petImage1Button.imageView?.layer.cornerRadius = 0
        petImage2Button.imageView?.layer.cornerRadius = 0
        petImage3Button.imageView?.layer.cornerRadius = 0
        
        avatarPickerButton.tag = 0;
        petImage1Button.tag = 0;
        petImage2Button.tag = 0;
        petImage3Button.tag = 0;
    }
    
}

extension AddPetViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        petDescriptionDummy.text = " "
        petDescriptionDummy.setFloatingLabelColor(UIColor(named: "AccentColor")!, for: .normal)
        petDescriptionBorder.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
        petDescriptionLabelBg.backgroundColor = .white
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if petDescriptionTextView.text == "" {
            petDescriptionDummy.text = ""
            petDescriptionLabelBg.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        } else {
            petDescriptionDummy.setFloatingLabelColor(UIColor(named: "AppSecondaryColor")!, for: .normal)
            petDescriptionBorder.layer.borderColor = UIColor(named: "AppSecondaryColor")?.cgColor
        }
    }
}

extension UIImageView {
    func makeRounded() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
