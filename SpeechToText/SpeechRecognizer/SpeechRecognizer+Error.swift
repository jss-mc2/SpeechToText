//
//  SpeechRecognizer+Error.swift
//  SpeechToText
//
//  Created by Jason Rich Darmawan Onggo Putra on 22/06/23.
//

import Foundation

extension SpeechRecognizer {
    enum RecognizerError: Error {
        case NIL_RECOGNIZER
        case NOT_AUTHORIZED_TO_RECOGNIZE
        case NOT_PERMITTED_TO_RECORD
        case RECOGNIZER_IS_UNAVAILABLE
        
        var message: String {
            switch self {
            case .NIL_RECOGNIZER: return "Can't initialize speech recognizer"
            case .NOT_AUTHORIZED_TO_RECOGNIZE: return "Not authorized to recognize speech"
            case .NOT_PERMITTED_TO_RECORD: return "Not permitted to record audio"
            case .RECOGNIZER_IS_UNAVAILABLE: return "Recognizer is unavailable"
            }
        }
    }
}
