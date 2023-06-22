//
//  Instruction.swift
//  SpeechToText
//
//  Created by Jason Rich Darmawan Onggo Putra on 22/06/23.
//

import Foundation

struct Instruction {
    var Ingredients_: [String]
    var Utensils_: [String]
    var TimerTimeInterval_: Double?
}

#if DEBUG
extension Instruction {
    static var SAMPLE_DATA = [
        Instruction(Ingredients_: ["1 1 I", "1 2 I", "1 3 I"], Utensils_: ["1 1 U", "1 2 U", "1 3 U"], TimerTimeInterval_: 5.0),
        Instruction(Ingredients_: ["2 1 I", "2 2 I", "2 3 I"], Utensils_: ["2 1 U", "2 2 U", "2 3 U"]),
        Instruction(Ingredients_: ["3 1 I", "3 2 I", "3 3 I"], Utensils_: ["3 I U", "3 2 U", "3 3 U"], TimerTimeInterval_: 10.0)
    ]
}
#endif
