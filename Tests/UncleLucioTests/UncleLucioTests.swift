import XCTest
@testable import UncleLucio

class UncleLucioTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    func joke() -> Joke {
        return Joke(subject: "Harry",
                        punchline: "Harry up and let me in!")
    }

    func testInStart_ReceivingHelp_Sayshelo_StaysSameState() {
        let state = StartState(joke: joke())
        
        let (text, nextState) = state.nextState(when: "help")
        XCTAssertEqual(text, "Ask me for a joke, and I'll tell you a knock-knock joke\n" +
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
        )
        
        XCTAssertTrue(nextState is StartState)
    }

    func testInStart_ReceivingGarbage_SaysSlogan_GoesStart() {
        let state = StartState(joke: joke())
        
        let (text, nextState) = state.nextState(when: "foobar")
        XCTAssertEqual(text, "I know a lot of funny jokes. Ask me for a joke!")
        
        XCTAssertTrue(nextState is StartState)
    }

    func testInStart_AskedJoke_SaysKnockKnock_GoesWaitForReply() {
        let state = StartState(joke: joke())
        
        let (text, nextState) = state.nextState(when: "tell me a joke")
        XCTAssertEqual(text, "Knock Knock")
        
        XCTAssertTrue(nextState is WaitingForReplyState)
    }
    
    func testWaitingForReply_ReceivingGarbage_SaysSlogan_StaysSameState() {
        let state = WaitingForReplyState(joke: joke())
        
        let (text, nextState) = state.nextState(when: "Foobar")
        XCTAssertEqual(text, "Wrong: you should say \"Who's there?\"")
        XCTAssertTrue(nextState is WaitingForReplyState)
    }

    func testWaitingForReply_ReceivingReply_SaysSubject_GoesWaitingForReplySubject() {
        let state = WaitingForReplyState(joke: joke())
        
        let (text, nextState) = state.nextState(when: "Who's there?")
        XCTAssertEqual(text, "\(joke().subject)!")
        XCTAssertTrue(nextState is WaitingForSubjectReplyState)
    }
    
    func testWaitingForReply_ReceivingSimilarReply_SaysSubject_GoesWaitingForReplySubject() {
        let state = WaitingForReplyState(joke: joke())
        
        let (text, nextState) = state.nextState(when: "Who is there")
        XCTAssertEqual(text, "\(joke().subject)!")
        XCTAssertTrue(nextState is WaitingForSubjectReplyState)
    }

    func testWaitingForSubjectReply_ReceivingReply_SaysPunchline_GoesDone() {
        let state = WaitingForSubjectReplyState(joke: joke())
        
        let (text, nextState) = state.nextState(when: "\(joke().subject) who")
        XCTAssertEqual(text, "\(joke().punchline)\nahahah")
        XCTAssertTrue(nextState is Done)
    }
    
    func testWaitingForSubjectReply_ReceivingGarbage_Explains_StaysSameState() {
        let state = WaitingForSubjectReplyState(joke: joke())
        
        let (text, nextState) = state.nextState(when: "foobar")
        XCTAssertEqual(text, "Wrong! You should say \"\(joke().subject) who?\"")
        XCTAssertTrue(nextState is WaitingForSubjectReplyState)
    }
    


}
