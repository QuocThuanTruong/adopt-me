//
//  ConversationsModel.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 1/19/21.
//

import Foundation

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}
