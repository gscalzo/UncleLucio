// main.swift
import Foundation
import Vapor
import HTTP

let PAGE_ACCESS_TOKEN = "EAAEmgE6xk5MBAK1yLwpfj1Eq5WqW69lPoyrhGokJ5DS4N9msvVBZBZBt14WPyETwgNW8mqRUSL1ULw3XNYdzOvCm0PkOg4ahJLDDEKtWf67GKQBtHmfqUdhF9unptz22ZBtWhk3eu78cpYRszC5Rdo6JZC0MXevgDBmqDXuJoAZDZD"
let fbURL = "https://graph.facebook.com/v2.6/me/messages?access_token=" + PAGE_ACCESS_TOKEN

let uncleLucio = UncleLucio(jokesDB: JokesDB())

let drop = Droplet(config: Config(Node("port", "8081")))

drop.get("fbwebhook") { request in
    print("get webhook")
    guard let token = request.data["hub.verify_token"]?.string,
        let response = request.data["hub.challenge"]?.string else {
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

    let replyMessage = uncleLucio.message(after: chatMessage)
    return try drop.client.post(fbURL,
                         headers: ["Content-Type": "application/json; charset=utf-8"],
                         body: replyMessage.toJSON())
}

drop.run([
    "default": (host: "unclelucio.com", port: 8081, securityLayer: .none)
])
