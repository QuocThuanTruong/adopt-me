//
//  ChatViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 12/8/20.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var chatTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func deleteAct(_ sender: Any) {
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatTableViewCell
        
        cell.nameLabel.text = "Quoc Thuan Truong"
        cell.messageLabel.text = "abcdef"
        cell.timeLabel.text = "16:57"
        
        cell.avatarImage.layer.cornerRadius = cell.avatarImage.frame.width / 2
        cell.avatarImage.clipsToBounds = true
        cell.avatarImage.image = UIImage(named: "test_avt")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
