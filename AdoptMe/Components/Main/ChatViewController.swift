//
//  ChatViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 12/8/20.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var chatTableView: UITableView!
    
    private var conversations = [Conversation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
	
        startListeningForCOnversations()
    }
    

    @IBAction func deleteAct(_ sender: Any) {
        createNewConversation()
    }
    
    
    
    private func startListeningForCOnversations() {
    //        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
    //            return
    //        }

            let email = "quothuantruong1707@gmail.com"
    //        if let observer = loginObserver {
    //            NotificationCenter.default.removeObserver(observer)
    //        }

            print("starting conversation fetch...")

            let safeEmail = ChatDatabaseManager.safeEmail(emailAddress: email)

        ChatDatabaseManager.shared.getAllConversations(for: safeEmail, completion: { [weak self] result in
                switch result {
                case .success(let conversations):
                    print("successfully got conversation models")
//                    guard !conversations.isEmpty else {
//                        self?.chatTableView.isHidden = true
//                        self?.noConversationsLabel.isHidden = false
//                        return
//                    }
//                    self?.noConversationsLabel.isHidden = true
//                    self?.chatTableView.isHidden = false
                    self?.conversations = conversations

                    DispatchQueue.main.async {
                        self?.chatTableView.reloadData()
                    }
                case .failure(let error):
                    self?.chatTableView.isHidden = true
                    //self?.noConversationsLabel.isHidden = false
                    print("failed to get convos: \(error)")
                    
                }
            })
        }
    
    private func createNewConversation() {
            let name = "QTT"
            let email = ChatDatabaseManager.safeEmail(emailAddress: "lalalag129@gmail.com")

            // check in datbase if conversation with these two users exists
            // if it does, reuse conversation id
            // otherwise use existing code
        print("clgt")

        ChatDatabaseManager.shared.conversationExists(iwth: email, completion: { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case .success(let conversationId):
                    print("failed to load exists")
                    let vc = ChatFrameViewController(with: email, id: conversationId)
                    vc.isNewConversation = false
                    vc.title = name
                    vc.navigationItem.largeTitleDisplayMode = .never
                    strongSelf.navigationController?.pushViewController(vc, animated: true)
                case .failure(_):
                    print("failed to create new")
//                    let vc = ChatFrameViewController(with: email, id: nil)
//                    vc.isNewConversation = true
//                    vc.title = name
//                    vc.navigationItem.largeTitleDisplayMode = .never
//                    strongSelf.navigationController?.pushViewController(vc, animated: true)
                    let vc = ChatFrameViewController(with: email, id: nil)
                    vc.isNewConversation = true
                    
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
        cell.timeLabel.text = model.latestMessage.date
        
        cell.avatarImage.layer.cornerRadius = cell.avatarImage.frame.width / 2
        cell.avatarImage.clipsToBounds = true
        cell.avatarImage.image = UIImage(named: "test_avt")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "ChatDetailViewController") as! ChatDetailViewController
//
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
                let model = conversations[indexPath.row]
                openConversation(model)
    }
    
    func openConversation(_ model: Conversation) {
            let vc = ChatFrameViewController(with: model.otherUserEmail, id: model.id)
            vc.title = model.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
    
}




