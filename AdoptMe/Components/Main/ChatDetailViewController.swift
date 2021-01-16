//
//  ChatDetailViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 1/16/21.
//

import UIKit
import MessageKit

class ChatDetailViewController: UIViewController {

    @IBOutlet weak var messagesCollectionView: MessagesCollectionView!
    
    let sender = Sender(senderId: "any_unique_id", displayName: "Steven")
    let messages: [MessageType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messagesCollectionView.messagesDataSource = self
                messagesCollectionView.messagesLayoutDelegate = self
                messagesCollectionView.messagesDisplayDelegate = self
    }
    

}

public struct Sender: SenderType {
    public let senderId: String

    public let displayName: String
}


extension ChatDetailViewController: MessagesDataSource, MessagesDisplayDelegate, MessagesLayoutDelegate {

    func currentSender() -> SenderType {
        return Sender(senderId: "any_unique_id", displayName: "Steven")
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
}
