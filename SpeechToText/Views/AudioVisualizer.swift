//
//  AudioVisualizer.swift
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

struct AudioVisualizer: View {
    @Binding var IsVisualizing_: Bool
    
    init(_ isVusalizing: Binding<Bool>) {
        _IsVisualizing_ = isVusalizing
    }
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0 ..< 6) { item in
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 3, height: .random(in: 4...45))
            }
            .animation(.easeInOut(duration: 0.25).repeatForever(while: IsVisualizing_), value: IsVisualizing_)
        }
    }
}

#if DEBUG
struct AudioVisualizer_Previews: PreviewProvider {
    static var previews: some View {
        AudioVisualizer(.constant(false))
    }
}
#endif
