//
//  SortPickerViewDelegate.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 1/2/21.
//

import Foundation
import UIKit

class SortPickerViewDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    let sorts: [String] = ["Newest", "Oldest", "Name A-Z", "Name Z-A"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sorts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sorts[row]
    }
    
}
