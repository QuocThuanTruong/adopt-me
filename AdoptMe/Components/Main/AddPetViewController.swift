//
//  AddPostViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 12/8/20.
//

import UIKit
import MaterialComponents
import UIFloatLabelTextView

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
