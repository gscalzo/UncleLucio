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

extension State {
    func helpState(when message: String) -> (String, State)? {
        guard message.lowercased().contains("help") else {
            return nil
        }
        let helpText = "Ask me for a joke, and I'll tell you a knock-knock joke\n" +
            "The knock-knock joke is a type of joke, in the format of \"call and response\"," +
            " where the response contains a pun.\n" +
            "The standard format has five lines:\n" +
            "1 -The punster: Knock, knock!\n" +
            "2 -The recipient: Who's there?\n" +
            "3 -The punster: a variable response, sometimes involving a name.\n" +
            "4 -The recipient: a repetition of the response followed by who?\n" +
            "5 -The punster: the punch line, which typically involves a pun-based misusage of the word set up during the response.\n" +
            "For example:\n" +
            "1 - The punster: Knock, knock!\n" +
            "2 - The recipient: Who's there?\n" +
            "3 - The punster: Woo.\n" +
            "4 - The recipient: Woo who?\n" +
            "5 - The punster: Don't get excited. It's just a joke.\n\n" +
        "Ask me for a joke..."
        
        return (helpText, self)

    }
}

struct StartState: State {
    let joke: Joke
    func nextState(when message: String) -> (String, State) {
        if message.lowercased().contains("joke") {
            return ("Knock Knock", WaitingForReplyState(joke: joke))
        }
        return helpState(when: message) ?? ("I know a lot of funny jokes. Ask me for a joke!", self)
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
        return helpState(when: message) ?? ("Wrong: you should say \"Who's there?\"", self)
    }
}

struct WaitingForSubjectReplyState: State {
    let joke: Joke
    func nextState(when message: String) -> (String, State) {
        let text = message.lowercased()
        if text.contains("\(joke.subject.lowercased()) who") {
            return ("\(joke.punchline)\nahahah", Done())
        }
        return helpState(when: message) ?? ("Wrong! You should say \"\(joke.subject) who?\"", self)
    }
}

struct Done: State {
    func nextState(when message: String) -> (String, State) {
        return ("pota", Done())
    }
}
