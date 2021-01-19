//
//  ChatViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 12/8/20.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var chatTableView: UITableView!
    
    @IBOutlet weak var chatEmptyLabel: UILabel!
    private var conversations = [Conversation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
	
        startListeningForCOnversations()
        
    }
    

    @IBAction func deleteAct(_ sender: Any) {
       //for test
        createNewConversation()
    }
    
    
    
    private func startListeningForCOnversations() {
        let email = Core.shared.getCurrentUserEmail()


            print("starting conversation fetch... \(email)")

            let safeEmail = ChatDatabaseManager.safeEmail(emailAddress: email)

        ChatDatabaseManager.shared.getAllConversations(for: safeEmail, completion: { [weak self] result in
                switch result {
                case .success(let conversations):
                    print("successfully got conversation models")
                    guard !conversations.isEmpty else {
                        self?.chatTableView.isHidden = true
                        self?.chatEmptyLabel.isHidden = false
                        return
                    }
                    self?.chatEmptyLabel.isHidden = true
                    self?.chatTableView.isHidden = false
                    self?.conversations = conversations

                    DispatchQueue.main.async {
                        self?.chatTableView.reloadData()
                    }
                    
                case .failure(let error):
                    self?.chatTableView.isHidden = true
                    self?.chatEmptyLabel.isHidden = false
                    print("failed to get convos: \(error)")
                    
                }
            })
        }
    
    private func createNewConversation() {
            let name = "QTT"
            let email = ChatDatabaseManager.safeEmail(emailAddress: "quocthuantruong1707@gmail.com")

            // check in datbase if conversation with these two users exists
            // if it does, reuse conversation id
            // otherwise use existing code

        ChatDatabaseManager.shared.conversationExists(iwth: email, completion: { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case .success(let conversationId):
                    print("success to load exists")

                    let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ChatDetailViewController") as! ChatDetailViewController
                    vc.isNewConversation = false
                    vc.otherUserEmail = email
                    vc.conversationId = conversationId
                    vc.titleChat = name
                    
                    vc.modalPresentationStyle = .fullScreen
                    
                    strongSelf.present(vc, animated: true, completion: nil)
                case .failure(_):
                    print("failed to create new")

                    let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ChatDetailViewController") as! ChatDetailViewController
                    vc.isNewConversation = true
                    vc.otherUserEmail = email
                    vc.conversationId = nil
                    vc.titleChat = name
                    
                    vc.modalPresentationStyle = .fullScreen
                    
                    strongSelf.present(vc, animated: true, completion: nil)
                   
                    
                }
            })
        }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = conversations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatTableViewCell
        
        //binding data here
        cell.nameLabel.text = model.name
        cell.messageLabel.text = model.latestMessage.text
        cell.timeLabel.text =  getTimeFromDate(model.latestMessage.date)
        
        
        cell.avatarImage.layer.cornerRadius = cell.avatarImage.frame.width / 2
        cell.avatarImage.clipsToBounds = true
        cell.avatarImage.image = UIImage(named: "test_avt")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
                let model = conversations[indexPath.row]
                openConversation(model)
    }
    
    func openConversation(_ model: Conversation) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailViewController") as! ChatDetailViewController
        
        vc.titleChat = model.name
        vc.isNewConversation = false
        vc.otherUserEmail = model.otherUserEmail
        vc.conversationId = model.id
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func getTimeFromDate(_ date: String) -> String {
        
        let dateFormatter: DateFormatter = {
            let formattre = DateFormatter()
            formattre.dateStyle = .medium
            formattre.timeStyle = .long
            formattre.locale = .current
            return formattre
        }()
        
        let yourDate = dateFormatter.date(from: date)
        print(yourDate!)
        
        dateFormatter.dateFormat = "HH:mm"
        let result = dateFormatter.string(from: yourDate!)
        
        print(result)
        return result
    }
    
}




