//
//  ChatDetailViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 1/16/21.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatDetailViewController: MessagesViewController {

    
    private var senderPhotoURL: URL?
       private var otherUserPhotoURL: URL?

       public static let dateFormatter: DateFormatter = {
           let formattre = DateFormatter()
           formattre.dateStyle = .medium
           formattre.timeStyle = .long
           formattre.locale = .current
           return formattre
       }()

       public var otherUserEmail: String = ""
       public var conversationId: String?
       public var isNewConversation = false
    public var titleChat : String = ""
    @IBOutlet weak var chatTitle: UILabel!
    
       private var messages = [Message]()

       private var selfSender: Sender? {
            let email = Core.shared.getCurrentUserEmail()

           let safeEmail = ChatDatabaseManager.safeEmail(emailAddress: email)

           return Sender(photoURL: "",
                         senderId: safeEmail,
                         displayName: "Me")
       }

//       init(with email: String, id: String?) {
//           self.conversationId = id
//           self.otherUserEmail = email
//           super.init(nibName: nil, bundle: nil)
//       }
//
//       required init?(coder: NSCoder) {
//           fatalError("init(coder:) has not been implemented")
//       }
       
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        //messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        setupInputButton()
        
        initView()
        
        messagesCollectionView.backgroundColor = .white
        self.view.backgroundColor = UIColor(named: "AppPrimaryColor")
        chatTitle.text = titleChat
    }
    
    @IBAction func backAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func backTap(_sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func initView() {
       
        
        let topC = NSLayoutConstraint(item: messagesCollectionView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 100)
        
        let leftC = NSLayoutConstraint(item: messagesCollectionView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        
        let bottomC = NSLayoutConstraint(item: messagesCollectionView, attribute: .bottom, relatedBy: .equal, toItem: self.view , attribute: .bottom, multiplier: 1, constant: 0)
        
        let rightC = NSLayoutConstraint(item: messagesCollectionView, attribute: .trailing, relatedBy: .equal, toItem: self.view , attribute: .trailing, multiplier: 1, constant: 0)
        
        
        
        
        
        NSLayoutConstraint.activate([topC, leftC, bottomC, rightC])
    }
    
    private func listenForMessages(id: String, shouldScrollToBottom: Bool) {
        ChatDatabaseManager.shared.getAllMessagesForConversation(with: id, completion: { [weak self] result in
               switch result {
               case .success(let messages):
                   print("success in getting messages: \(messages)")
                   guard !messages.isEmpty else {
                       print("messages are empty")
                       return
                   }
                   self?.messages = messages

                   DispatchQueue.main.async {
                       self?.messagesCollectionView.reloadDataAndKeepOffset()

                       if shouldScrollToBottom {
                        self?.messagesCollectionView.scrollToLastItem()
                       }
                   }
               case .failure(let error):
                   print("failed to get messages: \(error)")
               }
           })
       }

    
    override func viewDidAppear(_ animated: Bool) {
        messageInputBar.inputTextView.becomeFirstResponder()
                if let conversationId = conversationId {
                    listenForMessages(id: conversationId, shouldScrollToBottom: true)
                }
    }
    
    
    private func setupInputButton() {
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 35, height: 35), animated: false)
        button.setImage(UIImage(systemName: "paperclip"), for: .normal)
        button.onTouchUpInside { [weak self] _ in
            self?.presentInputActionSheet()
        }
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
    }
    
    private func presentInputActionSheet() {
           let actionSheet = UIAlertController(title: "Attach Media",
                                               message: "What would you like to attach?",
                                               preferredStyle: .actionSheet)
//           actionSheet.addAction(UIAlertAction(title: "Photo", style: .default, handler: { [weak self] _ in
//               self?.presentPhotoInputActionsheet()
//           }))
//           actionSheet.addAction(UIAlertAction(title: "Video", style: .default, handler: { [weak self]  _ in
//               self?.presentVideoInputActionsheet()
//           }))
//           actionSheet.addAction(UIAlertAction(title: "Audio", style: .default, handler: {  _ in
//
//           }))
//           actionSheet.addAction(UIAlertAction(title: "Location", style: .default, handler: { [weak self]  _ in
//               self?.presentLocationPicker()
//           }))
//           actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

           present(actionSheet, animated: true)
       }



}

extension ChatDetailViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }

        fatalError("Self Sender is nil, email should be cached")
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let message = message as? Message else {
            return
        }

        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else {
                return
            }
           // imageView.af_setImage(with: imageUrl, completed: nil)
        default:
            break
        }
    }

    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let sender = message.sender
        if sender.senderId == selfSender?.senderId {
            // our message that we've sent
            return .link
        }

        return .secondarySystemBackground
    }

    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {

        let sender = message.sender

        if sender.senderId == selfSender?.senderId {
            // show our image
            if let currentUserImageURL = self.senderPhotoURL {
                //avatarView.sd_setImage(with: currentUserImageURL, completed: nil)
            }
            else {
                // images/safeemail_profile_picture.png

                let email = Core.shared.getCurrentUserEmail()
                print("ccccc \(email)")
                let UID = getUserByEmail(Email: email)
                
                let safeEmail = ChatDatabaseManager.safeEmail(emailAddress: email)
               // let path = "images/\(safeEmail)_profile_picture.png"
                let path = "\(UID)/avatar.jpg"

                // fetch url
                StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
                    switch result {
                    case .success(let url):
                        self?.senderPhotoURL = url
                        DispatchQueue.main.async {
                            print("url \(url)")
                            //avatarView.sd_setImage(with: url, completed: nil)
                        }
                    case .failure(let error):
                        print("\(error)")
                    }
                })
            }
        }
        else {
            // other user image
//            if let otherUsrePHotoURL = self.otherUserPhotoURL {
//                //avatarView.sd_setImage(with: otherUsrePHotoURL, completed: nil)
//            }
//            else {
                
                // fetch url
//                let email = self.otherUserEmail
//
//                let safeEmail = ChatDatabaseManager.safeEmail(emailAddress: email)
//                let path = "images/\(safeEmail)_profile_picture.png"
//
//
//                // fetch url
//                StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
//                    switch result {
//                    case .success(let url):
//                        self?.otherUserPhotoURL = url
//                        DispatchQueue.main.async {
//                           // avatarView.sd_setImage(with: url, completed: nil)
//                        }
//                    case .failure(let error):
//                        print("\(error)")
//                    }
//                })
 //           }
        }

    }
}


extension ChatDetailViewController: InputBarAccessoryViewDelegate {

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
            let selfSender = self.selfSender,
            let messageId = createMessageId() else {
                return
        }
        

        print("Sending: \(text)")

        let mmessage = Message(sender: selfSender,
                               messageId: messageId,
                               sentDate: Date(),
                               kind: .text(text))

        // Send Message
        if isNewConversation {
            // create convo in database
            ChatDatabaseManager.shared.createNewConversation(with: otherUserEmail, name: self.title ?? "User", firstMessage: mmessage, completion: { [weak self]success in
                if success {
                    print("message sent")
                    self?.isNewConversation = false
                    let newConversationId = "conversation_\(mmessage.messageId)"
                    self?.conversationId = newConversationId
                    self?.listenForMessages(id: newConversationId, shouldScrollToBottom: true)
                    self?.messageInputBar.inputTextView.text = nil
                }
                else {
                    print("failed not send")
                }
            })
        }
        else {
            guard let conversationId = conversationId else {
                return
            }
            let name = titleChat
                        

             //append to existing conversation data
            ChatDatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: otherUserEmail, name: name, newMessage: mmessage, completion: { [weak self] success in
                if success {
                    self?.messageInputBar.inputTextView.text = nil
                    print("message sent")
                }
                else {
                    print("failed to send")
                }
            })
        }
    }

    private func createMessageId() -> String? {
        // date, otherUesrEmail, senderEmail, randomInt
        let currentUserEmail = Core.shared.getCurrentUserEmail()


        let safeCurrentEmail = ChatDatabaseManager.safeEmail(emailAddress: currentUserEmail)

        let dateString = Self.dateFormatter.string(from: Date())
        let newIdentifier = "\(otherUserEmail)_\(safeCurrentEmail)_\(dateString)"

        print("created message id: \(newIdentifier)")

        return newIdentifier
    }

}

extension ChatDetailViewController: MessageCellDelegate {
    func didTapMessage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
            return
        }

        let message = messages[indexPath.section]

        switch message.kind {
//        case .location(let locationData):
//            let coordinates = locationData.location.coordinate
//            let vc = LocationPickerViewController(coordinates: coordinates)
//
//            vc.title = "Location"
//            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }

    func didTapImage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
            return
        }

        let message = messages[indexPath.section]

//        switch message.kind {
//        case .photo(let media):
//            guard let imageUrl = media.url else {
//                return
//            }
//            let vc = PhotoViewerViewController(with: imageUrl)
//            navigationController?.pushViewController(vc, animated: true)
//        case .video(let media):
//            guard let videoUrl = media.url else {
//                return
//            }
//
//            let vc = AVPlayerViewController()
//            vc.player = AVPlayer(url: videoUrl)
//            present(vc, animated: true)
//        default:
//            break
//        }
    }
}
