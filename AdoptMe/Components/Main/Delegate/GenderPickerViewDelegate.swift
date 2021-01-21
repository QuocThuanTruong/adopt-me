//
//  GenderPickerViewDelegate.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 1/2/21.
//

import Foundation
import UIKit

class GenderPickerViewDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    let genders: [String] = ["All", "Male", "Female"]
    
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
