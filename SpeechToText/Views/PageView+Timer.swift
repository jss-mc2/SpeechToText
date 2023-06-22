//
//  PageView+Timer.swift
//  SpeechToText
//
//  Created by Jason Rich Darmawan Onggo Putra on 22/06/23.
//

import Foundation

extension PageView {
    func SetTimer(_ countDownDuration: TimeInterval) {
#if DEBUG
        print("\(#function) time interval \(countDownDuration)")
#endif
        if countDownDuration > 0 {
            CurrentCountDownDuration_ = countDownDuration
        }
    }
    
    func ToggleTimer() {
        // Timer_ can be nil, valid, or invalid
        if let Timer_, Timer_.isValid {
            StopTimer()
        } else {
            StartTimer()
        }
    }
    
    func StartTimer() {
        print("\(#function)")
        if let countDownDuration = CurrentCountDownDuration_ ?? DefaultCountDownDuration_ {
            startTime_ = Date()
            ElapsedTime_ = 0
            Timer_ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                updateElapsedTime(countDownDuration)
            }
        }
    }
    
    func StopTimer() {
        print("\(#function)")
        Timer_?.invalidate()
        Timer_ = nil
        ElapsedTime_ = nil
        startTime_ = nil
        CurrentCountDownDuration_ = nil
        DefaultCountDownDuration_ = nil
    }
    
    func ResetTimer() {
#if DEBUG
        print("\(#function)")
#endif
        DefaultCountDownDuration_ = CurrentCountDownDuration_
    }
    
    func StartAlarm() {
#if DEBUG
        print("\(#function)")
#endif
    }
    
    func StopAlarm() {
#if DEBUG
        print("\(#function)")
#endif
    }
    
    private func updateElapsedTime(_ countDownDuration: TimeInterval) {
        print("\(#function)")
        if let ElapsedTime_, ElapsedTime_ >= countDownDuration {
            print("\(#function) ElapsedTime >= timeInterval")
            StartAlarm()
            return
        }
        if let startTime_ {
            ElapsedTime_ = Date().timeIntervalSince(startTime_)
        }
    }
}
