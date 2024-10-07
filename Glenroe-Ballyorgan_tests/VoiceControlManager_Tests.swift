//
//  File.swift
//  Glenroe-Ballyorgan_tests
//
//  Created by Liya Wang on 2024/10/2.
//

import XCTest
@testable import Glenroe_Ballyorgan
import Speech

class VoiceControlManager_Tests: XCTestCase {

    var voiceControlManager: VoiceControlManager!
    
    

    override func setUp() {
        super.setUp()
        voiceControlManager = VoiceControlManager()
    }

    override func tearDown() {
        voiceControlManager = nil
        super.tearDown()
    }

    func testHandleRecognizedText_ValidInput() {
        // Given
        let recognizedText = "Hi"
        
        // When
        let result = voiceControlManager.handleRecognizedText(recognizedText)
        
        // Then
        XCTAssertEqual(result, "Hello, nice to meet you!")
    }
    
    func testHandleRecognizedText_UnknownInput() {
        // Given
        let recognizedText = "tell me something about it"
        
        // When
        let result = voiceControlManager.handleRecognizedText(recognizedText)
        
        // Then
        XCTAssertEqual(result, "You are on a fantastic Keale River walk!")
    }
    
    func testHandleRecognizedText_EmptyInput() {
        // Given
        let recognizedText = "  " // Input with only whitespace
        
        // When
        let result = voiceControlManager.handleRecognizedText(recognizedText)
        
        // Then
        XCTAssertEqual(result, "No text recognized.")
    }
    func testResetSilenceTimer() {
        // Given
        let expectation = self.expectation(description: "Timer is expected to trigger after 2 seconds")
        voiceControlManager.resetSilenceTimer()

        // When
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            XCTAssertNil(self.voiceControlManager.silenceTimer, "Silence timer should be invalidated after firing.")
            expectation.fulfill()
        }

//        // Then
        waitForExpectations(timeout: 5.0, handler: nil)
    }


    
    func testStopListening() {
        // Start listening first
        voiceControlManager.startListening()
        
        // Call stopListening
        voiceControlManager.stopListening()

        // Assert that the audio engine has stopped
        XCTAssertFalse(voiceControlManager.isAudioEngineRunning(), "Audio engine should be stopped.")
        
        // Assert that the silence timer has been invalidated
        XCTAssertNil(voiceControlManager.silenceTimer, "Silence timer should be nil after stopListening.")
    }
    func testHandleRecognizedText_SimilarMatch() {
        let recognizedText = "what's special about this place"
        let result = voiceControlManager.handleRecognizedText(recognizedText)
        
        // The closest match should be "what is so special about this place?"
        XCTAssertEqual(result, "The ‘Keale river’ wood and the nearby Ballinacourty wood are the only documented ‘possible ancient woodland’ sites in the whole of South East Limerick. ")
    }
    
    func testLevenshteinDistance() {
        let input = "what is special about this place"
        let options = ["what is this place", "tell me more about this place", "what is so special about this place?"]
        let closestMatch = voiceControlManager.findClosestMatch(for: input, from: options)
        
        // The closest match should be the third option
        XCTAssertEqual(closestMatch, "what is so special about this place?")
    }
    func testRequestSpeechAuthorization() {
        // Mock the system response for speech authorization
        SFSpeechRecognizer.requestAuthorization { status in
            switch status {
            case .authorized:
                XCTAssertTrue(true, "Speech recognition authorized.")
            case .denied, .restricted, .notDetermined:
                XCTAssertFalse(true, "Speech recognition authorization failed.")
            @unknown default:
                break
            }
        }
    }







}

