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
    
    init(_ pages: [Page]) {
        self.Pages_ = pages
        print("init", type(of: self))
    }
    
    var body: some View {
        Pages_[CurrentPage_]
            .onTapGesture {
                if CurrentPage_ + 1 == Pages_.count {
#if DEBUG
                    print("end of page \(#function)", type(of: self))
                    CurrentPage_ = 0
#endif
                } else {
                    CurrentPage_ += 1
                }
            }
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
