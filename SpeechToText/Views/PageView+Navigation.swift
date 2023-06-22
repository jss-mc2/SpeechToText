//
//  PageView+Actions.swift
//  SpeechToText
//
//  Created by Jason Rich Darmawan Onggo Putra on 22/06/23.
//

import Foundation

extension PageView {
    func NextPage() {
        if CurrentPage_ + 1 == Pages_.count {
#if DEBUG
            print("\(#function) end of page", type(of: self))
#endif
        } else {
            CurrentPage_ += 1
        }
    }
    
    func BackPage() {
        if CurrentPage_ == 0 {
#if DEBUG
            print("\(#function) beginning of page", type(of: self))
#endif
        } else {
            CurrentPage_ -= 1
        }
    }
    
    internal func toggleTranscribing() {
        if !SpeechRecognizer_.IsTranscribing_ {
            SpeechRecognizer_.Init()
            SpeechRecognizer_.Transcribe = transcribeNavigation
            SpeechRecognizer_.StartTranscribing()
        } else {
            stopTranscribing()
        }
    }
    
    internal func stopTranscribing() {
        SpeechRecognizer_.StopTranscribing()
    }
    
    internal func transcribeNavigation(_ message: String) {
        #if DEBUG
        print("\(#function) \(message)")
        #endif

        let words = message.lowercased().components(separatedBy: " ")
        let lastTwoWords = words.suffix(2)
        #if DEBUG
        print("\(#function) last two words: \(lastTwoWords.description)")
        #endif
        
        let actions = ["next":NextPage, "back":BackPage, "set timer": PresentTimerView]

        // reverse guard clause.
        if let last = lastTwoWords.last,
           let action = actions[last] ??
            actions[lastTwoWords.joined(separator: " ")]
        {
            #if DEBUG
            print("\(#function) action")
            #endif
            action()
        }
        // continue if Transcript words > 2
        else if (words.count > 2) {}
        // transcribe message: start
        // transcribe message: start timer
        else
        {
            SpeechRecognizer_.Transcript_ = message
            return
        }

        SpeechRecognizer_.RestartTranscribing()
    }
}
