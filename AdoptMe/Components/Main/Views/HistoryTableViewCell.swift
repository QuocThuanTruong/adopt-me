//
//  HistoryTableViewCell.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 1/4/21.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var clearKeyButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //clearKeyButton.tag = 0;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func act_clearKey(_ sender: Any) {
        //clearKeyButton.tag = 1;
        
    }
}
