//
//  TextToSpeech.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 7/17/22.
//

import SwiftUI
import JumpLinguaHelpers
import AVFoundation

func textToSpeech(text: String, language: LanguageType ){
    let utterance = AVSpeechUtterance(string: text)
    switch language {
    case .Spanish:
        utterance.voice = AVSpeechSynthesisVoice(language: "es-US")
    case .French:
        utterance.voice = AVSpeechSynthesisVoice(language:  "fr-FR")
    case .English:
        utterance.voice = AVSpeechSynthesisVoice(language:  "en-NZ")
    default:
        utterance.voice = AVSpeechSynthesisVoice(language:  "es-US")
    }
    utterance.rate = 0.5
    let synthesizer = AVSpeechSynthesizer()
    synthesizer.speak(utterance)
}
