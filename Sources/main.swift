import Foundation
import Vapor
import HTTP

let PAGE_ACCESS_TOKEN = "EAAEmgE6xk5MBAK1yLwpfj1Eq5WqW69lPoyrhGokJ5DS4N9msvVBZBZBt14WPyETwgNW8mqRUSL1ULw3XNYdzOvCm0PkOg4ahJLDDEKtWf67GKQBtHmfqUdhF9unptz22ZBtWhk3eu78cpYRszC5Rdo6JZC0MXevgDBmqDXuJoAZDZD"
let fbURL = "https://graph.facebook.com/v2.6/me/messages?access_token=" + PAGE_ACCESS_TOKEN


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
/*
 {
 "object": "page",
 "entry": [
 {
 "id": "1677732245875632",
 "time": 1476209402183,
 "messaging": [
 {
 "sender": {
 "id": "1243544059050238"
 },
 "recipient": {
 "id": "1677732245875632"
 },
 "timestamp": 1476209402090,
 "message": {
 "mid": "mid.1476209402075:82aff934133d72d746",
 "seq": 17,
 "text": "Knock knock"
 }
 }
 ]
 }
 ]
 }
 */
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

let drop = Droplet()

drop.get("fbwebhook") { request in
    print("get webhook")
    guard let token = request.data["hub.verify_token"]?.string else {
        throw Abort.badRequest
    }
    guard let response = request.data["hub.challenge"]?.string else {
        throw Abort.badRequest
    }
    
    if token == "2318934571" {
        print("send response")
        return response // Response(status: .ok, text: "response")
    } else {
        return "Error, invalid token"//Response(status: .ok, text: "Error, invalid token")
    }
}

drop.post("fbwebhook") { request in

    request.log()
    
    guard let jsonBody = request.json,
    let chatMessage = ChatMessage(message: jsonBody)
        else {
        throw Abort.badRequest
    }

    let replyMessage = ChatMessage(sender: chatMessage.recipient,
                                   recipient: chatMessage.sender,
                                   text: chatMessage.text ?? "pota")
    return try drop.client.post(fbURL,
                         headers: ["Content-Type": "application/json; charset=utf-8"],
                         body: replyMessage.toJSON())
}

drop.run()
