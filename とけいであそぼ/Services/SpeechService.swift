//
//  SpeechService.swift
//  とけいであそぼ
//

import AVFoundation

class SpeechService {
    static let shared = SpeechService()
    
    private let synthesizer = AVSpeechSynthesizer()
    private var isEnabled = true
    
    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session setup failed: \(error)")
        }
    }
    
    func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
    }
    
    func speakTime(_ time: ClockTime) {
        guard isEnabled else { return }
        
        let text = time.spokenJapanese
        speak(text)
    }
    
    func speak(_ text: String) {
        guard isEnabled else { return }
        
        // Stop any current speech
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        utterance.rate = 0.45
        utterance.pitchMultiplier = 1.2
        utterance.volume = 1.0
        
        synthesizer.speak(utterance)
    }
    
    func speakCorrect() {
        speak("せいかい！")
    }
    
    func speakTryAgain() {
        speak("もういちど やってみよう")
    }
    
    func stop() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
}
