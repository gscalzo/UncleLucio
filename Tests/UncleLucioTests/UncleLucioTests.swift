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
    
    func testInStart_ReceivingGarbage_SaysSlogan_GoesStart() {
        let state = StartState(joke: joke())
        
        let (text, nextState) = state.nextState(when: "foobar")
        XCTAssertEqual(text, "pota")
        
        XCTAssertTrue(nextState is StartState)
    }

    func testInStart_AskedJoke_SaysKnockKnock_GoesWaitForReply() {
        let state = StartState(joke: joke())
        
        let (text, nextState) = state.nextState(when: "tell me a joke")
        XCTAssertEqual(text, "Knock Knock")
        
        XCTAssertTrue(nextState is WaitingForReplyState)
    }
    
    func testWaitingForReply_ReceivingGarbage_SaysSlogan_GoesStart() {
        let state = WaitingForReplyState(joke: joke())
        
        let (text, nextState) = state.nextState(when: "Foobar")
        XCTAssertEqual(text, "pota")
        XCTAssertTrue(nextState is StartState)
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



}
