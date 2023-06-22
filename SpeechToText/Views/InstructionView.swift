//
//  InstructionView.swift
//  SpeechToText
//
//  Created by Jason Rich Darmawan Onggo Putra on 22/06/23.
//

import SwiftUI
import Combine

struct InstructionView: View {
    var Instruction_: Instruction
    
    // TODO: refactor
    @State private var startTime_ = Date()
    @State var ElapsedTime_: Double?
    @State var Timer_: Timer?
    
    init(_ instruction: Instruction) {
        self.Instruction_ = instruction
#if DEBUG
        print("\(type(of: self)) init")
#endif
    }
    
    var body: some View {
        VStack {
            Text("Ingredients")
            ForEach(Instruction_.Ingredients_, id: \.self) { ingredient in
                Text(ingredient)
            }
            Text("Utensils")
            ForEach(Instruction_.Utensils_, id: \.self) { utensil in
                Text(utensil)
            }
            if let timeInterval = Instruction_.TimerTimeInterval_ {
                Text("Timer \(timeInterval, specifier: "%.fs")")
                    .onTapGesture {
                        // Timer_ can be nil, valid, or invalid
                        if let Timer_, Timer_.isValid {
                            StopTimer()
                        } else {
                            StartTimer(timeInterval: timeInterval)
                        }
                    }
            }
            if let ElapsedTime_ {
                Text("Elapsed Time \(ElapsedTime_, specifier: "%.fs")")
            }
        }
    }
    
    func StartTimer(timeInterval: Double) {
        print("\(#function)")
        startTime_ = Date()
        ElapsedTime_ = 0
        Timer_ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            updateElapsedTime(timeInterval: timeInterval)
        }
    }
    
    func StopTimer() {
        print("\(#function)")
        Timer_?.invalidate()
    }
    
    private func updateElapsedTime(timeInterval: Double) {
        print("\(#function)")
        if let ElapsedTime_, let timeInterval = Instruction_.TimerTimeInterval_, ElapsedTime_ >= timeInterval {
            print("\(#function) ElapsedTime >= timeInterval")
            StopTimer()
            return
        }
        ElapsedTime_ = Date().timeIntervalSince(startTime_)
    }
}

#if DEBUG
struct InstructionView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionView(Instruction.SAMPLE_DATA[0])
    }
}
#endif
