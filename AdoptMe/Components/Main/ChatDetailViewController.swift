//
//  ChatDetailViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 1/16/21.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Nuke
import Firebase
import AVFoundation
import AVKit
import CoreLocation
import ALCameraViewController
import Photos

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
        messagesCollectionView.messageCellDelegate = self
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
        let topC = NSLayoutConstraint(item: messagesCollectionView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 150)
        
        let leftC = NSLayoutConstraint(item: messagesCollectionView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        
        let bottomC = NSLayoutConstraint(item: messagesCollectionView, attribute: .bottom, relatedBy: .equal, toItem: self.view , attribute: .bottom, multiplier: 1, constant: 0)
        
        let rightC = NSLayoutConstraint(item: messagesCollectionView, attribute: .trailing, relatedBy: .equal, toItem: self.view , attribute: .trailing, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([topC, leftC, bottomC, rightC])
    }
    
    private func listenForMessages(id: String, shouldScrollToBottom: Bool) {
        ChatDatabaseManager.shared.getAllMessagesForConversation(with: id, completion: { [weak self] result in
               switch result {
               case .success(let messages):
                   print("success in getting messages")
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
           actionSheet.addAction(UIAlertAction(title: "Photo", style: .default, handler: { [weak self] _ in
               self?.presentPhotoInputActionsheet()
           }))
//           actionSheet.addAction(UIAlertAction(title: "Video", style: .default, handler: { [weak self]  _ in
//               self?.presentVideoInputActionsheet()
//           }))

           actionSheet.addAction(UIAlertAction(title: "Location", style: .default, handler: { [weak self]  _ in
               self?.presentLocationPicker()
           }))
           actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

           present(actionSheet, animated: true)
       }

    private func presentLocationPicker() {
          let vc = LocationPickerViewController(coordinates: nil)
        vc.modalPresentationStyle = .fullScreen
        
          vc.completion = { [weak self] selectedCoorindates in

              guard let strongSelf = self else {
                  return
              }

              guard let messageId = strongSelf.createMessageId(),
                  let conversationId = strongSelf.conversationId,
                  let selfSender = strongSelf.selfSender else {
                      return
              }
            
                let name = strongSelf.titleChat

              let longitude: Double = selectedCoorindates.longitude
              let latitude: Double = selectedCoorindates.latitude

              print("long=\(longitude) | lat= \(latitude)")


              let location = Location(location: CLLocation(latitude: latitude, longitude: longitude),
                                   size: .zero)

              let message = Message(sender: selfSender,
                                    messageId: messageId,
                                    sentDate: Date(),
                                    kind: .location(location))

              ChatDatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: strongSelf.otherUserEmail, name: name, newMessage: message, completion: { success in
                  if success {
                      print("sent location message")
                  }
                  else {
                      print("failed to send location message")
                  }
              })
          }
        self.present(vc, animated: true, completion: nil)
      }

    
    private func presentPhotoInputActionsheet() {
          let actionSheet = UIAlertController(title: "Attach Photo",
                                              message: "Where would you like to attach a photo from",
                                              preferredStyle: .actionSheet)
          actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in

            let cameraViewController = CameraViewController { [weak self] image, asset in
                // Do something with your image here.
                self?.dismiss(animated: true, completion: nil)
            }

            self?.present(cameraViewController, animated: true, completion: nil)

          }))
          actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in

            let imagePickerViewController = PhotoLibraryViewController()
            imagePickerViewController.onSelectionComplete = { asset in

                    // The asset could be nil if the user doesn't select anything
                    guard let asset = asset else {
                        return
                    }

                // Provides a PHAsset object
                    // Retrieve a UIImage from a PHAsset using
                    let options = PHImageRequestOptions()
                options.deliveryMode = .highQualityFormat
                options.isNetworkAccessAllowed = true

                    PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options) { image, _ in
                    if let image = image {
                       
                        guard let messageId = self?.createMessageId(),
                              let conversationId = self?.conversationId,
                              let selfSender = self?.selfSender else {
                                return
                        }
                        
                        let name = self?.titleChat

                        let fileName = "photo_message_" + messageId.replacingOccurrences(of: " ", with: "-") + ".png"

                            // Upload image

                        StorageManager.shared.uploadMessagePhoto(with: image.pngData()!, fileName: fileName, completion: { [weak self] result in
                                guard let strongSelf = self else {
                                    return
                                }

                                switch result {
                                case .success(let urlString):
                                    // Ready to send message
                                    print("Uploaded Message Photo: \(urlString)")

                                    guard let url = URL(string: urlString),
                                        let placeholder = UIImage(systemName: "plus") else {
                                            return
                                    }

                                    let media = Media(url: url,
                                                      image: nil,
                                                      placeholderImage: placeholder,
                                                      size: .zero)

                                    let message = Message(sender: selfSender,
                                                          messageId: messageId,
                                                          sentDate: Date(),
                                                          kind: .photo(media))

                                    ChatDatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: strongSelf.otherUserEmail, name: name!, newMessage: message, completion: { success in

                                        if success {
                                            print("sent photo message")
                                        }
                                        else {
                                            print("failed to send photo message")
                                        }

                                    })

                                case .failure(let error):
                                    print("message photo upload error: \(error)")
                                }
                            })
                        
                        imagePickerViewController.dismiss(animated: false, completion: nil)
                        
                    }
                }
            }

            self?.present(imagePickerViewController, animated: true, completion: nil)

          }))
          actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

          present(actionSheet, animated: true)
      }

      private func presentVideoInputActionsheet() {
          let actionSheet = UIAlertController(title: "Attach Video",
                                              message: "Where would you like to attach a video from?",
                                              preferredStyle: .actionSheet)
          actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in

              let picker = UIImagePickerController()
              picker.sourceType = .camera
              picker.delegate = self
              picker.mediaTypes = ["public.movie"]
              picker.videoQuality = .typeMedium
              picker.allowsEditing = true
              self?.present(picker, animated: true)

          }))
          actionSheet.addAction(UIAlertAction(title: "Library", style: .default, handler: { [weak self] _ in

              let picker = UIImagePickerController()
              picker.sourceType = .photoLibrary
              picker.delegate = self
              picker.allowsEditing = true
              picker.mediaTypes = ["public.movie"]
              picker.videoQuality = .typeMedium
              self?.present(picker, animated: true)

          }))
          actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

          present(actionSheet, animated: true)
      }



}

extension ChatDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let messageId = createMessageId(),
            let conversationId = conversationId,
            let name = self.title,
            let selfSender = selfSender else {
                return
        }

        if let image = info[.editedImage] as? UIImage, let imageData =  image.pngData() {
            let fileName = "photo_message_" + messageId.replacingOccurrences(of: " ", with: "-") + ".png"

            // Upload image

            StorageManager.shared.uploadMessagePhoto(with: imageData, fileName: fileName, completion: { [weak self] result in
                guard let strongSelf = self else {
                    return
                }

                switch result {
                case .success(let urlString):
                    // Ready to send message
                    print("Uploaded Message Photo: \(urlString)")

                    guard let url = URL(string: urlString),
                        let placeholder = UIImage(systemName: "plus") else {
                            return
                    }

                    let media = Media(url: url,
                                      image: nil,
                                      placeholderImage: placeholder,
                                      size: .zero)

                    let message = Message(sender: selfSender,
                                          messageId: messageId,
                                          sentDate: Date(),
                                          kind: .photo(media))

                    ChatDatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: strongSelf.otherUserEmail, name: name, newMessage: message, completion: { success in

                        if success {
                            print("sent photo message")
                        }
                        else {
                            print("failed to send photo message")
                        }

                    })

                case .failure(let error):
                    print("message photo upload error: \(error)")
                }
            })
        }
        else if let videoUrl = info[.mediaURL] as? URL {
            let fileName = "photo_message_" + messageId.replacingOccurrences(of: " ", with: "-") + ".mov"

            // Upload Video

            StorageManager.shared.uploadMessageVideo(with: videoUrl, fileName: fileName, completion: { [weak self] result in
                guard let strongSelf = self else {
                    return
                }

                switch result {
                case .success(let urlString):
                    // Ready to send message
                    print("Uploaded Message Video: \(urlString)")

                    guard let url = URL(string: urlString),
                        let placeholder = UIImage(named: "ic-sm-blue-imgpicker") else {
                            return
                    }

                    let media = Media(url: url,
                                      image: nil,
                                      placeholderImage: placeholder,
                                      size: CGSize(width: 30, height: 30))

                    let message = Message(sender: selfSender,
                                          messageId: messageId,
                                          sentDate: Date(),
                                          kind: .video(media))

                    ChatDatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: strongSelf.otherUserEmail, name: name, newMessage: message, completion: { success in

                        if success {
                            print("sent photo message")
                        }
                        else {
                            print("failed to send photo message")
                        }

                    })

                case .failure(let error):
                    print("message photo upload error: \(error)")
                }
            })
        }
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
            Nuke.loadImage(with: imageUrl, into: imageView)
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
        let db = Firestore.firestore()

        if sender.senderId == selfSender?.senderId {
            // show our image
            db.collection("users").whereField("email", isEqualTo: Core.shared.getCurrentUserEmail()).limit(to: 1)
                .getDocuments{ (querySnapshot, error) in
                    if let error = error {
                        print(error)
                    } else {
                        if querySnapshot!.documents.count == 1 {
                            let data = querySnapshot?.documents[0].data()
                            
                            let urlStr = URL(string: (data?["avatar"] as! String))
                            let urlReq = URLRequest(url: urlStr!)
                            Nuke.loadImage(with: urlReq, into: avatarView)
                        }
                    }
                    
                    
                }
        }
        else {
            
            //let tokens = self.otherUserEmail.components(separatedBy: "-")
            //let originEmail = tokens[0] + "@" + tokens[1] + "." + tokens[2]
            let originEmail = ChatDatabaseManager.shared.restoreEmail(safeEmail: self.otherUserEmail)
            
            db.collection("users").whereField("email", isEqualTo: originEmail).limit(to: 1)
                .getDocuments{ (querySnapshot, error) in
                    if let error = error {
                        print(error)
                    } else {
                        if querySnapshot!.documents.count == 1 {
                            let data = querySnapshot?.documents[0].data()
                            
                            let urlStr = URL(string: (data?["avatar"] as! String))
                            let urlReq = URLRequest(url: urlStr!)
                            Nuke.loadImage(with: urlReq, into: avatarView)
                        }
                    }
                    
                    
                }
            
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
            ChatDatabaseManager.shared.createNewConversation(with: otherUserEmail, name: self.titleChat , firstMessage: mmessage, completion: { [weak self]success in
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
        case .location(let locationData):
            let coordinates = locationData.location.coordinate
            let vc = LocationPickerViewController(coordinates: coordinates)
            self.present(vc, animated: true, completion: nil)
        
            
        default:
            break
        }
    }
    

    func didTapImage(in cell: MessageCollectionViewCell) {
       
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
            return
        }

        let message = messages[indexPath.section]

        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else {
                return
            }
            let vc = PhotoViewerViewController(with: imageUrl)
            self.present(vc, animated: true, completion: nil)
        case .video(let media):
            guard let videoUrl = media.url else {
                return
            }

            let vc = AVPlayerViewController()
            vc.player = AVPlayer(url: videoUrl)
            present(vc, animated: true)
        default:
            break
        }
    }
}
