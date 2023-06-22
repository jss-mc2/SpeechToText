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
    
    @ObservedObject var SpeechRecognizer_ = SpeechRecognizer()
    
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
                    BackPage()
                }
            }
        VStack {
            Pages_[CurrentPage_]
                .onTapGesture {
                    NextPage()
                }
                .gesture(swipeGesture)
            AudioVisualizer($SpeechRecognizer_.IsTranscribing_)
            Text("\(SpeechRecognizer_.Transcript_)")
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
