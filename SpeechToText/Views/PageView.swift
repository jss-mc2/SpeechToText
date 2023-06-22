//
//  PageView.swift
//  SpeechToText
//
//  Created by Jason Rich Darmawan Onggo Putra on 22/06/23.
//

import SwiftUI

struct PageView<Page: View>: View {
    var Pages_: [Page]
    @State var CurrentPage_: Int = 0
    
    @State var KeyWords_: [String] = []
    @ObservedObject var SpeechRecognizer_ = SpeechRecognizer()
    
    @State internal var startTime_: Date?
    @State var DefaultCountDownDuration_: TimeInterval?
    @State var CurrentCountDownDuration_: TimeInterval?
    @State var ElapsedTime_: TimeInterval?
    @State var Timer_: Timer?
    
    init(_ pages: [Page]) {
        self.Pages_ = pages
        print("\(type(of: self)) init")
    }
    
    var body: some View {
        let swipeGesture = DragGesture()
            .onEnded { gesture in
                if gesture.translation.width > 0 {
                    NextPage()
                } else if gesture.translation.width < 0 {
                    PreviousPage()
                }
            }
        VStack {
            Pages_[CurrentPage_]
                .onTapGesture {
                    NextPage()
                }
                .gesture(swipeGesture)
            if let CurrentCountDownDuration_ {
                Text("Timer \(CurrentCountDownDuration_, specifier: "%.fs")")
                    .onTapGesture {
                        ToggleTimer()
                    }
            }
            if let ElapsedTime_ {
                Text("Elapsed Time \(ElapsedTime_, specifier: "%.fs")")
            }
            if KeyWords_.count > 0 {
                Text(KeyWords_.description)
            }
            Text("Speech Recognizer \(SpeechRecognizer_.IsTranscribing_ ? "ON" : "OFF")")
                .onTapGesture {
                    toggleTranscribing()
                }
        }.navigationBarBackButtonHidden(true)
    }
}

#if DEBUG
struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView([
            InstructionView(Instruction.SAMPLE_DATA[0]),
            InstructionView(Instruction.SAMPLE_DATA[1]),
            InstructionView(Instruction.SAMPLE_DATA[2])
        ])
    }
}
#endif
