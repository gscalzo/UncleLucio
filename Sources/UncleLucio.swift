//
//  Created by Giordano Scalzo on 11/10/2016.
//
//

import Foundation
import HTTP
import Vapor

#if os(Linux)
    import SwiftGlibc
    
    public func arc4random_uniform(_ max: UInt32) -> Int32 {
        return (SwiftGlibc.rand() % Int32(max-1))
    }
#endif

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

extension Array {
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}


class JokesDB {
    private let jokes: [Joke] = [
        ("Harry", "Harry up and let me in!"),
        ("Wanda", "Wanda hang out with me right now?"),
        ("Olive", "Olive you and I don’t care who knows it!"),
        ("Ho-ho", "You know, your Santa impression could use a little work."),
        ("Hanna", "...Hanna partridge in a pear tree!"),
        ("Mary and Abbey", "Mary Christmas and Abbey New Year!"),
        ("Irish", "Irish you a Merry Christmas!"),
        ("Yule log", "Yule log the door after you let me in, won’t you?"),
        ("Ya", "I’m excited to see you too!"),
        ("Sherlock", "Sherlock your door shut tight!"),
        ("Scold", "Scold outside—let me in!"),
        ("Robin", "Robin you! Hand over your cash!"),
        ("Needle", "Needle little help gettin’ in the door."),
        ("Nana", "Nana your business who’s there."),
        ("Luke", "Luke through the keyhole to see!"),
        ("Isabelle", "Isabelle working, or should I keep knocking?"),
        ].map {
            Joke(subject: $0.0,
                     punchline: $0.1)
        }
    
    
    func randomJoke() -> Joke {
        return jokes.randomItem()
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

