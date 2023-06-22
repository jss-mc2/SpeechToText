//
//  PageView+Timer.swift
//  SpeechToText
//
//  Created by Jason Rich Darmawan Onggo Putra on 22/06/23.
//

import Foundation

extension PageView {
    internal func transcribeTime(_ message: String) {
#if DEBUG
        print("\(#function) words \(message)")
#endif
        let maxLength = 6
        
        let words = message.lowercased().components(separatedBy: " ")
        let maximumWords = words.suffix(maxLength)
#if DEBUG
        print("\(#function) maximum words: \(maximumWords.description)")
#endif
        
        // convert "one hour 25 minutes 20 seconds"
        // to "1 hour 25 minute 20 second"
        let convertedWords = words.map { word -> String in
            return SpeechRecognizer.MAPPING[word] ?? word
        }
#if DEBUG
        print("\(#function) converted words \(convertedWords)")
#endif
        
        var hours: TimeInterval = 0
        var minutes: TimeInterval = 0
        var seconds: TimeInterval = 0
        
        for i in stride(from: 0, to: convertedWords.count - 1, by: 2) {
            let value = convertedWords[i]
            let unit = convertedWords[i+1]
            
            if let intValue = Double(value) {
                switch unit {
                case "hour", "hours":
                    hours += intValue * 3600
                case "minute", "minutes":
                    minutes += intValue * 60
                case "second", "seconds":
                    seconds += intValue
                default:
#if DEBUG
                    print("\(#function) break")
#endif
                    break
                }
            }
        }
        
        let totalTimeInterval = hours + minutes + seconds
        print("\(#function) totalTimeInterval \(totalTimeInterval)")
        
        SetTimer(totalTimeInterval)
        
        // reverse guard clause.
        if let last = maximumWords.last {
            if last == "start" {
                StartTimer()
            } else if last == "cancel" {
                DismissTimerView()
            }
        }
        // message: one hour
        // message: one hour 25 minutes
        // message: one hour 25 minutes one second
        else if (words.count > maxLength) {}
        else
        {
            SpeechRecognizer_.Transcript_ = message
            return
        }
        
        SpeechRecognizer_.RestartTranscribing()
    }
    
    func PresentTimerView() {
#if DEBUG
        print("\(#function)")
#endif
        SpeechRecognizer_.Transcribe = transcribeTime
    }
    
    func SetTimer(_ countDownDuration: TimeInterval) {
#if DEBUG
        print("\(#function) time interval \(countDownDuration)")
#endif
    }
    
    func StartTimer() {
#if DEBUG
        print("\(#function)")
#endif
    }
    
    func DismissTimerView() {
#if DEBUG
        print("\(#function)")
#endif
        SpeechRecognizer_.Transcribe = transcribeNavigation
    }
}
