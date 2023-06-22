//
//  Animation+RepeatForever.swift
//  SpeechToText
//
//  Created by Jason Rich Darmawan Onggo Putra on 22/06/23.
//

import SwiftUI

extension Animation {
    func repeatForever(while expression: Bool, autoreverses: Bool = true) -> Animation {
        if expression {
            return self.repeatForever(autoreverses: autoreverses)
        } else {
            return self
        }
    }
}
