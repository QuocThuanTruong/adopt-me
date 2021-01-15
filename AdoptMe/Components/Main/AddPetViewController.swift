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

class AddPetViewController: UIViewController {

    @IBOutlet weak var petNameTextField: MDCOutlinedTextField!
    @IBOutlet weak var petAgeTextField: MDCOutlinedTextField!
    @IBOutlet weak var petGenderTextField: MDCOutlinedTextField!
    @IBOutlet weak var petAddressTextField: MDCOutlinedTextField!
    @IBOutlet weak var petDescriptionBorder: UIButton!
    @IBOutlet weak var petDescriptionLabelBg: UIButton!
    @IBOutlet weak var petDescriptionDummy: MDCOutlinedTextField!
    @IBOutlet weak var petDescriptionTextView: UITextView!
    
    
    @IBOutlet weak var avatarPickerButton: UIButton!
    @IBOutlet weak var petImage1Button: UIButton!
    @IBOutlet weak var petImage2Button: UIButton!
    @IBOutlet weak var petImage3Button: UIButton!
    @IBOutlet weak var addPetButton: MDCButton!
    
    
    var genderPickerView: UIPickerView!
    var bottomPopUpView: BottomPopUpView!
    
    let genderPickerViewDelegate = GenderPickerViewDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        initView()
    }
    
    func initView() {
        let textFields: [MDCOutlinedTextField] = [petNameTextField, petAgeTextField, petGenderTextField, petAddressTextField]
        let leadingIconNames: [String] = ["ic-blue-petname", "ic-blue-age", "ic-blue-gender", "ic-blue-address", ]
        let labelForTFs: [String] = ["Your pet name", "Age", "Gender", "Address"]
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
