import Foundation
import Speech
import AVFoundation

class VoiceControlManager: NSObject, SFSpeechRecognizerDelegate {
    var speechRecognizer: SFSpeechRecognizer
        private let audioEngine = AVAudioEngine()
        private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
        var silenceTimer: Timer?
        var onRecognizedText: ((String) -> Void)?

        // Custom initializer for injecting speechRecognizer
        init(speechRecognizer: SFSpeechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!) {
            // Initialize speechRecognizer before calling super.init()
            self.speechRecognizer = speechRecognizer
            super.init()
            requestSpeechAuthorization()
        }

        func isAudioEngineRunning() -> Bool {
            return audioEngine.isRunning
        }

        private func requestSpeechAuthorization() {
            SFSpeechRecognizer.requestAuthorization { authStatus in
                OperationQueue.main.addOperation {
                    switch authStatus {
                    case .authorized:
                        print("Speech recognition authorized.")
                    case .denied, .restricted, .notDetermined:
                        print("Speech recognition authorization denied.")
                    @unknown default:
                        break
                    }
                }
            }
        }


    func startListening() {
        guard let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US")), speechRecognizer.isAvailable else {
                   print("Speech recognizer is not available.")
                   return
               }

        // Stop and reset audio engine before starting again to prevent conflicts
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.reset()
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create recognition request.")
        }

        let audioSession = AVAudioSession.sharedInstance()
        do {
            // Set the audio session category and options
            try audioSession.setCategory(.record, mode: .measurement, options: .defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            // Ensure the input node has been configured correctly
            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            
            // Install tap on the input node to get the audio buffer
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                self.recognitionRequest?.append(buffer)
            }

            // Start the audio engine
            audioEngine.prepare()
            try audioEngine.start()

            speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
                if let result = result {
                    let recognizedText = result.bestTranscription.formattedString
                    print("Recognized text: \(recognizedText)")

                    self.resetSilenceTimer()  // Reset the silence timer when new text is recognized

                    if result.isFinal {
                        self.stopListening()
                        self.onRecognizedText?(recognizedText)
                    }
                } else if let error = error {
                    print("Speech recognition error: \(error.localizedDescription)")
                    self.stopListening()
                }
            }

            print("Speech recognition started.")
            
        } catch {
            print("Audio session configuration error: \(error.localizedDescription)")
        }
    }



    func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionRequest = nil

        silenceTimer?.invalidate()  // Stop the timer when listening stops
        silenceTimer = nil
        
        // Deactivate the audio session after stopping the engine
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Error deactivating audio session: \(error.localizedDescription)")
        }
    }


    // Moved silence timer management functions here
    func resetSilenceTimer() {
        silenceTimer?.invalidate()  // Invalidate any existing timer
        
        // Start a new timer that will fire after 2 seconds of silence
        silenceTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(didFinishTalk), userInfo: nil, repeats: false)
    }

    @objc private func didFinishTalk() {
        print("No speech detected for 2 seconds, stopping listening.")
        stopListening()  // Stop listening due to silence
    }

    // Default text handling logic that can be overridden by the view controller
    func handleRecognizedText(_ text: String) -> String {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmedText.isEmpty else {
            print("No recognized text to process.")
            return "No text recognized."
        }
        
        // List of possible responses
        let responses: [String: String] = [
            "hi": "Hello, nice to meet you!",
            "what is this place": "This is River Keale.",
            "tell me more about this place": "You are on a fantastic Keale River walk!",
            "what is so special about this place? ": "The ‘Keale river’ wood and the nearby Ballinacourty wood are the only documented ‘possible ancient woodland’ sites in the whole of South East Limerick. ",
            "How long is the length of the walk": "about 7km",
            "Bye": "Bye! Have a nice day!"
        ]
        
        // Find the closest match using Levenshtein Distance
        let closestMatch = findClosestMatch(for: trimmedText, from: Array(responses.keys))
        
        return responses[closestMatch] ?? "Sorry, I didn't understand the question."
    }
    func findClosestMatch(for input: String, from options: [String]) -> String {
            var closestMatch = options.first ?? ""
            var smallestDistance = Int.max
            
            for option in options {
                let distance = levenshteinDistance(input, option)
                if distance < smallestDistance {
                    smallestDistance = distance
                    closestMatch = option
                }
            }
            return closestMatch
        }

        // Levenshtein Distance Algorithm
    //
        func levenshteinDistance(_ string1: String, _ string2: String) -> Int {
            let (t, s) = (string1, string2) 
            let empty = Array(repeating: 0, count: s.count)
            var last = [Int](0...s.count)

            for (i, tLett) in t.enumerated() {
                var cur = [i + 1] + empty
                for (j, sLett) in s.enumerated() {
                    cur[j + 1] = tLett == sLett ? last[j] : Swift.min(last[j], last[j + 1], cur[j]) + 1
                }
                last = cur
            }
            return last.last!
        }
   
    
}
//
//import Foundation
//import Speech
//import AVFoundation
//
//class VoiceControlManager: NSObject, SFSpeechRecognizerDelegate {
//    
//    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
//    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
//    private let audioEngine = AVAudioEngine()
//    
//    var silenceTimer: Timer?  // Moved here
//    
//    // Callback for custom handling of recognized text
//    var onRecognizedText: ((String) -> Void)?
//
//    override init() {
//        super.init()
//        requestSpeechAuthorization()
//    }
//
//    private func requestSpeechAuthorization() {
//        SFSpeechRecognizer.requestAuthorization { authStatus in
//            OperationQueue.main.addOperation {
//                switch authStatus {
//                case .authorized:
//                    print("Speech recognition authorized.")
//                case .denied, .restricted, .notDetermined:
//                    print("Speech recognition authorization denied.")
//                @unknown default:
//                    break
//                }
//            }
//        }
//    }
//
//    func startListening() {
//        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
//            print("Speech recognizer is not available.")
//            return
//        }
//
//        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
//        guard let recognitionRequest = recognitionRequest else {
//            fatalError("Unable to create recognition request.")
//        }
//
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(.record, mode: .measurement, options: .defaultToSpeaker)
//            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
//        } catch {
//            print("Audio session configuration error: \(error.localizedDescription)")
//        }
//
//        let inputNode = audioEngine.inputNode
//        recognitionRequest.shouldReportPartialResults = true
//
//        inputNode.installTap(onBus: 0, bufferSize: 1024, format: inputNode.outputFormat(forBus: 0)) { (buffer, _) in
//            self.recognitionRequest?.append(buffer)
//        }
//
//        audioEngine.prepare()
//        try? audioEngine.start()
//
//        speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
//            if let result = result {
//                let recognizedText = result.bestTranscription.formattedString
//                print("Recognized text: \(recognizedText)")
//                
//                self.resetSilenceTimer()  // Reset the silence timer when new text is recognized
//                
//                if result.isFinal {
//                    self.stopListening()
//                    self.onRecognizedText?(recognizedText)  // Call the custom handling closure
//                }
//            } else if let error = error {
//                print("Speech recognition error: \(error.localizedDescription)")
//                self.stopListening()
//            }
//        }
//        print("Speech recognition started.")
//    }
//
//    func stopListening() {
//        audioEngine.stop()
//        audioEngine.inputNode.removeTap(onBus: 0)
//        recognitionRequest?.endAudio()
//        recognitionRequest = nil
//
//        silenceTimer?.invalidate()  // Stop the timer when listening stops
//        silenceTimer = nil
//    }
//
//    // Moved silence timer management functions here
//    func resetSilenceTimer() {
//        silenceTimer?.invalidate()  // Invalidate any existing timer
//        
//        // Start a new timer that will fire after 2 seconds of silence
//        silenceTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(didFinishTalk), userInfo: nil, repeats: false)
//    }
//
//    @objc private func didFinishTalk() {
//        print("No speech detected for 2 seconds, stopping listening.")
//        stopListening()  // Stop listening due to silence
//    }
//
//    // Default text handling logic that can be overridden by the view controller
//    func handleRecognizedText(_ text: String) -> String {
//        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
//        guard !trimmedText.isEmpty else {
//            print("No recognized text to process.")
//            return "No text recognized."
//        }
//        
//        // List of possible responses
//        let responses: [String: String] = [
//            "hi": "Hello, nice to meet you!",
//            "what is this place": "This is River Keale.",
//            "tell me more about this place": "You are on a fantastic Keale River walk!",
//            "what is so special about this place? ": "The ‘Keale river’ wood and the nearby Ballinacourty wood are the only documented ‘possible ancient woodland’ sites in the whole of South East Limerick. ",
//            "How long is the length of the walk": "about 7km",
//            "Bye": "Bye! Have a nice day!"
//        ]
//        
//        // Find the closest match using Levenshtein Distance
//        let closestMatch = findClosestMatch(for: trimmedText, from: Array(responses.keys))
//        
//        return responses[closestMatch] ?? "Sorry, I didn't understand the question."
//    }
//    func findClosestMatch(for input: String, from options: [String]) -> String {
//            var closestMatch = options.first ?? ""
//            var smallestDistance = Int.max
//            
//            for option in options {
//                let distance = levenshteinDistance(input, option)
//                if distance < smallestDistance {
//                    smallestDistance = distance
//                    closestMatch = option
//                }
//            }
//            return closestMatch
//        }
//
//        // Levenshtein Distance Algorithm
//    //
//        func levenshteinDistance(_ string1: String, _ string2: String) -> Int {
//            let (t, s) = (string1, string2)
//            let empty = Array(repeating: 0, count: s.count)
//            var last = [Int](0...s.count)
//
//            for (i, tLett) in t.enumerated() {
//                var cur = [i + 1] + empty
//                for (j, sLett) in s.enumerated() {
//                    cur[j + 1] = tLett == sLett ? last[j] : Swift.min(last[j], last[j + 1], cur[j]) + 1
//                }
//                last = cur
//            }
//            return last .last!
//        }
//    
//    
//}
//
