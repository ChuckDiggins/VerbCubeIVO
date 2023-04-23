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
    var utterance = AVSpeechUtterance(string: "")
    AVSpeechSynthesisVoice.speechVoices() // <--  fetch voice dependencies
    utterance = AVSpeechUtterance(string: text)
    switch language {
    case .Spanish:
        utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
    case .French:
        utterance.voice = AVSpeechSynthesisVoice(language:  "fr-FR")
    case .English:
//        utterance.voice = AVSpeechSynthesisVoice(language:  "en-US")
        utterance.voice = AVSpeechSynthesisVoice(language:  "en-NZ")
    default:
        utterance.voice = AVSpeechSynthesisVoice(language:  "es-US")
    }
    utterance.rate = 0.25
    let synthesizer = AVSpeechSynthesizer()
    synthesizer.speak(utterance)
}
