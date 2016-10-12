//
//  Created by Giordano Scalzo on 11/10/2016.
//
//

import Foundation
import HTTP
import Vapor

extension Request {
    func log() {
        /*
         switch body {
         case .data(let bytes):
         print(String(data: Data(bytes: bytes), encoding: .utf8) ?? "")
         case .chunked:
         print("-")
         }
         */
        
        guard case .data(let bytes) = body else {
            return
        }
        print(String(data: Data(bytes: bytes), encoding: .utf8) ?? "")
    }
}

class JokesDB {
    func randomJoke() -> Joke {
        return Joke(subject: "Harry",
                    punchline: "Harry up and let me in!")
    }
}


class UncleLucio {
    private let jokesDB: JokesDB
    
    init(jokesDB: JokesDB) {
        self.jokesDB = jokesDB
    }
    
    func message(after chatMessage: ChatMessage) -> ChatMessage {
        let replyMessage = ChatMessage(sender: chatMessage.recipient,
                                       recipient: chatMessage.sender,
                                       text: chatMessage.text ?? "pota")
        return replyMessage

    }
    
}

