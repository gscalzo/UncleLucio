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
    private var sessions = [String: State]()
    
    init(jokesDB: JokesDB) {
        self.jokesDB = jokesDB
    }
    
    func message(after chatMessage: ChatMessage) -> ChatMessage {
        let state = sessions[chatMessage.sender] ?? StartState(joke: jokesDB.randomJoke())

        let (text, newState) = state.nextState(when: chatMessage.text ?? "pota")
        
        if newState is Done {
            sessions.removeValue(forKey: chatMessage.sender)
        } else {
            sessions[chatMessage.sender] = newState
        }
        let replyMessage = ChatMessage(sender: chatMessage.recipient,
                                       recipient: chatMessage.sender,
                                       text: text)
        return replyMessage

    }
}

