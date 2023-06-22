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
    
    func PreviousPage() {
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
            KeyWords_ = ["next", "previous", "read the text"]
            if let Timer_, Timer_.isValid {
                //                KeyWords_ = ["next", "previous", "read the text", "stop timer"]
            }
        } else {
            stopTranscribing()
        }
    }
    
    internal func stopTranscribing() {
        SpeechRecognizer_.StopTranscribing()
        KeyWords_ = []
    }
    
    func Speak(_ message: String) {
#if DEBUG
        print("\(#function) \(message)")
#endif
    }
    
    internal func transcribeTime(_ words: [String]) -> TimeInterval {
        // convert "one hour 25 minutes 20 seconds"
        // to "1 hour 25 minute 20 second"
        let convertedWords = words.map { word -> String in
            return SpeechRecognizer.MAPPING[word] ?? word
        }
        
        var timeInterval: TimeInterval = 0
        
        for i in 0..<convertedWords.count-1 {
            let value = convertedWords[i]
            let unit = convertedWords[i+1]
            
            print(value, unit)
            if let intValue = Double(value) {
                switch unit {
                case "hour":
                    timeInterval += intValue * 3600
                case "minute":
                    timeInterval += intValue * 60
                case "second":
                    timeInterval += intValue
                default:
                    break
                }
            }
        }
        
        return timeInterval
    }
    
    internal func transcribeNavigation(_ message: String) {
#if DEBUG
        print("\(#function) \(message)")
#endif
        
        let words = message.lowercased().components(separatedBy: " ")
        
        if let last = words.last {
            switch last {
            case "next":
                NextPage()
                SpeechRecognizer_.RestartTranscribing()
            case "previous":
                PreviousPage()
                SpeechRecognizer_.RestartTranscribing()
            case "repeat":
                Speak("repeat")
                SpeechRecognizer_.RestartTranscribing()
            case "hour", "hours", "minute", "minutes", "second", "seconds":
                let countDownDuration = transcribeTime(words)
                SetTimer(countDownDuration)
                SpeechRecognizer_.RestartTranscribing()
            default:
                let lastTwoWords = words.suffix(2).joined(separator: " ")
                switch lastTwoWords {
                case "next page", "next step":
                    NextPage()
                    SpeechRecognizer_.RestartTranscribing()
                case "previous page", "previous step":
                    PreviousPage()
                    SpeechRecognizer_.RestartTranscribing()
                case "start timer":
                    StartTimer()
                    SpeechRecognizer_.RestartTranscribing()
                case "stop timer":
                    StopTimer()
                    SpeechRecognizer_.RestartTranscribing()
                case "reset timer":
                    ResetTimer()
                    SpeechRecognizer_.RestartTranscribing()
                    break
                default:
                    let lastThreeWords = words.suffix(3).joined(separator: " ")
                    switch lastThreeWords {
                    case "read the text":
                        Speak("read the text")
                        SpeechRecognizer_.RestartTranscribing()
                    default:
                        break
                    }
                }
            }
        }
        
        let maxLength = 4
        if words.count > maxLength {
            SpeechRecognizer_.RestartTranscribing()
            return
        } else {
            SpeechRecognizer_.Transcript_ = message
        }
    }
}
