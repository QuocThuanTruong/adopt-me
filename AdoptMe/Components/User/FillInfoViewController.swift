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

class FillInfoViewController: UIViewController {

    @IBOutlet weak var avtPickerButton: UIButton!
    @IBOutlet weak var userfullNameTextField: MDCOutlinedTextField!
    @IBOutlet weak var emailTextField: MDCOutlinedTextField!
    @IBOutlet weak var dobTextField: MDCOutlinedTextField!
    @IBOutlet weak var genderTextField: MDCOutlinedTextField!
    @IBOutlet weak var addressTextField: MDCOutlinedTextField!
    @IBOutlet weak var finishButton: MDCButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        genderPickerView = UIPickerView()
        genderPickerView.dataSource = self
        genderPickerView.delegate = self
        
        initView()
    }
    
    func initView() {
        
        let textFields: [MDCOutlinedTextField] = [userfullNameTextField, emailTextField, dobTextField, genderTextField, addressTextField]
        let leadingIconNames: [String] = ["ic-blue-username", "ic-blue-email", "ic-blue-dob", "ic-blue-gender", "ic-blue-address"]
        let labelForTFs: [String] = ["Your full name", "Email", "Date of birth", "Gender", "Address"]
        
        finishButton.layer.cornerRadius = 5.0
        avtPickerButton.layer.cornerRadius = 68.0
        
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
        /*let imagePicker = UIImagePickerController()

        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true

        self.present(imagePicker, animated: true, completion: nil)*/
        
        avtPickerButton.setImage(UIImage(named: "avatar.jpg"), for: .normal)
    }
    
    @IBAction func finishFillInfo(_ sender: Any) {
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
        let storage = Storage.storage().reference()
        
        let image = UIImage(named: "avatar.jpg")
        
        guard let imageData = image?.jpegData(compressionQuality: 1) else {
            return
        }

        if (UID == "") {
            UID = UUID().uuidString
        }
        
        storage.child("\(UID)/avatar.jpg").putData(imageData)
        
        userCollection.document(UID).setData([
            "UID": UID,
            "address": addressTextField.text ?? "",
            "dateOfBirth" : dobTextField.text ?? "",
            "email" : emailTextField.text ?? "",
            "fullname" : userfullNameTextField.text ?? "",
            "gender" : genderTextField.text ?? "",
            "password" : password,
            "phone": phone,
            "username" : username,
            "token" : token
        ], merge: true)
        
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