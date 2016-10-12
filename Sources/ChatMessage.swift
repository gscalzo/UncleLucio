//
//  ChatMessage.swift
//  UncleLucio
//
//  Created by Giordano Scalzo on 12/10/2016.
//
//

import Foundation
import Vapor
import HTTP

struct ChatMessage {
    let sender: String
    let recipient: String
    let text: String?
}

extension ChatMessage {
    func toJSON() throws -> JSON {
        return try JSON(node: [
            "sender": try JSON(node: [
                "id": sender
                ]),
            "recipient": try JSON(node: [
                "id": recipient
                ]),
            "message": try JSON(node: [
                "text": text
                ]),
            ])
    }
}

extension ChatMessage {
    init?(message: JSON) {
        guard let entry = message["entry"]?.array?.first as? JSON
            else {
                return nil
        }
        
        guard let messaging = entry["messaging"]?.array?.first as? JSON
            else {
                return nil
        }
        
        guard let senderWrapper = messaging["sender"]?.object,
            let sender = senderWrapper["id"]?.string
            else {
                return nil
        }
        self.sender = sender
        guard let recipientWrapper = messaging["recipient"]?.object,
            let recipient = recipientWrapper["id"]?.string
            else {
                return nil
        }
        self.recipient = recipient
        guard let message = messaging["message"]?.object
            else {
                return nil
        }
        self.text = message["text"]?.string
    }
}
