//
//  SpeechRecognizer.swift
//  SpeechToText
//
//  Created by Jason Rich Darmawan Onggo Putra on 22/06/23.
//

import Speech
import Dispatch

// A helper for transcribing speech to text using SFSpeechRecognizer and AVAudioEngine.
class SpeechRecognizer: ObservableObject {
    private var audioEngine_: AVAudioEngine?
    private var request_: SFSpeechAudioBufferRecognitionRequest?
    private var task_: SFSpeechRecognitionTask? {
        didSet {
            // task can be nil, is not cancelled, cancelled
            if let task_, !task_.isCancelled {
                IsTranscribing_ = true
                return
            }
            
            IsTranscribing_ = false
        }
    }
    private var recognizer_: SFSpeechRecognizer?
    
    // SFSpeechRecognizer call recognitionHandler multiple times to get best transcription.
    private var debouncer_: DispatchWorkItem?
    
    @Published var IsTranscribing_: Bool = false
    @Published var Transcript_ = ""
    
    /**
     Initializes a new speech recognizer. If this is the first time you've used the class, it
     requests access to the speech recognizer and the microphone.
     */
    func Init() {
        recognizer_ = SFSpeechRecognizer()
        guard recognizer_ != nil else {
            HandleError(RecognizerError.NIL_RECOGNIZER)
            return
        }
        
        Task {
            do {
                guard await SFSpeechRecognizer.HasAuthorizationToRecognize() else {
                    throw RecognizerError.NOT_AUTHORIZED_TO_RECOGNIZE
                }
                guard await AVAudioSession.sharedInstance().HasPermissionToRecord() else {
                    throw RecognizerError.NOT_PERMITTED_TO_RECORD
                }
            } catch {
                HandleError(error)
            }
        }
    }
    
    func StartTranscribing() {
        startTranscribing()
    }
    
    func StopTranscribing() {
        reset()
    }
    
    func RestartTranscribing() {
        reset()
        startTranscribing()
    }
    
    /**
     Begin transcribing audio.
     
     Creates a `SFSpeechRecognitionTask` that transcribes speech to text until you call `stopTranscribing()`.
     */
    private func startTranscribing() {
        print("\(#function)")
        
        guard let recognizer_, recognizer_.isAvailable else {
            self.HandleError(RecognizerError.RECOGNIZER_IS_UNAVAILABLE)
            return
        }
        
        do {
            let (audioEngine, request) = try Self.prepareEngine()
            self.audioEngine_ = audioEngine
            self.request_ = request
            self.task_ = recognizer_.recognitionTask(with: request, resultHandler: { [weak self] result, error in
                self?.recognitionHandler(audioEngine: audioEngine, result: result, error: error)
            })
        } catch {
            self.reset()
            self.HandleError(error)
        }
    }

    /// Reset the speech recognizer.
    private func reset() {
        task_?.cancel()
        audioEngine_?.stop()
        audioEngine_ = nil
        request_ = nil
        task_ = nil
        Transcript_ = ""
    }
    
    private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
        let audioEngine = AVAudioEngine()
        
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            request.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
        
        return (audioEngine, request)
    }

    private func recognitionHandler(
        audioEngine: AVAudioEngine, result: SFSpeechRecognitionResult?, error: Error?
    ) {
        print("\(#function)")
        
        // code 216 if user stopTranscribing()
        if let speechError = error as NSError?, speechError.code == 216 {
            return
        }
        
        let receivedFinalResult = result?.isFinal ?? false
        let receivedError = error != nil
        
        // receivedFinalResult if no incoming audio after some time.
        // receivedError if no incoming audio from the beginning.
        if receivedFinalResult || receivedError {
            if receivedFinalResult {
                print("\(#function) final")
            }
            else if receivedError {
                print("\(#function) error: " + (error?.localizedDescription ?? ""))
            }
            RestartTranscribing()
            return
        }
        
        if let result {
            // cancel any previously scheduled debouncer
            debouncer_?.cancel()
            
            let debounceTime = 0.5 // 0.5s
            
            let debouncer = DispatchWorkItem {
                print("\(#function) debouncing")
                if let Transcribe = self.Transcribe {
                    Transcribe(result.bestTranscription.formattedString)
                }
            }
            
            debouncer_ = debouncer
            
            DispatchQueue.main.asyncAfter(deadline: .now() + debounceTime, execute: debouncer)
        }
    }
    
    var Transcribe: ((_ message: String) -> Void)?
    
    // TODO: SOLID principle.
    // comment: do override func
//    func Transcribe(_ message: String) {
//        print("\(#function) \(message)")
//
//        let words = message.lowercased().components(separatedBy: " ")
//        let lastTwoWords = words.suffix(2)
//        print("\(#function) last two words: \(lastTwoWords.description)")
//
//        // reverse guard clause.
//        if let last = lastTwoWords.last, let action = Actions_[last] ?? Actions_[lastTwoWords.joined(separator: " ")]
//        {
//            print("\(#function) action")
//            action()
//        }
//        // continue if Transcript words > 2
//        else if (words.count > 2) {}
//        // transcribe message: start
//        // transcribe message: start timer
//        else
//        {
//            Transcript_ = message
//            return
//        }
//
//        RestartTranscribing()
//    }
    
    // TODO: handle error
    func HandleError(_ error: Error) {
        var errorMessage = ""
        if let error = error as? RecognizerError {
            errorMessage += error.message
        } else {
            errorMessage += error.localizedDescription
        }
        print("\(#function) \(errorMessage) ")
    }
}
