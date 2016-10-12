//
//  Created by Giordano Scalzo on 12/10/2016.
//
//

import Foundation

struct Joke {
    let subject: String
    let punchline: String
}

protocol State {
    func nextState(when message: String) -> (String, State)
}

struct StartState: State {
    let joke: Joke
    func nextState(when message: String) -> (String, State) {
        if message.lowercased().contains("joke") {
            return ("Knock Knock", WaitingForReplyState(joke: joke))
        }
        return ("pota", self)
    }
}

struct WaitingForReplyState: State {
    let joke: Joke
    func nextState(when message: String) -> (String, State) {
        let text = message.lowercased()
        if text.contains("who's there") ||
            text.contains("who is there") {
            return ("\(joke.subject)!", WaitingForSubjectReplyState(joke: joke))
        }
        return ("pota", StartState(joke: joke))
    }
}

struct WaitingForSubjectReplyState: State {
    let joke: Joke
    func nextState(when message: String) -> (String, State) {
        let text = message.lowercased()
        if text.contains("\(joke.subject.lowercased()) who") {
            return ("\(joke.punchline)!\nahahah", Done())
        }
        return ("pota", StartState(joke: joke))
    }
}

struct Done: State {
    func nextState(when message: String) -> (String, State) {
        return ("pota", Done())
    }
}
