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
        }
    }
}

#if DEBUG
struct InstructionView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionView(Instruction.SAMPLE_DATA[0])
    }
}
#endif
