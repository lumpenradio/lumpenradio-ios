//
//  Radio.swift
//  Lumpen Radio
//
//  Created by Anthony on 10/20/19.
//  Copyright © 2019 Public Media Institute. All rights reserved.
//

import Foundation
import AVFoundation

// Constants
fileprivate let BOTTOM_TEXT_RADIO_ON: String = "Tap above to tune out."
fileprivate let BOTTOM_TEXT_RADIO_OFF: String = "Tap above to tune in."
fileprivate let LUMPEN_AUDIO_URL: String = "http://mensajito.mx:8000/lumpen"

protocol RadioDelegate {
    func radioToggled(_ textContent: String)
}

// UIKit Version
class Radio {
    var bottomText = BOTTOM_TEXT_RADIO_OFF
    
// END UIKit Version
    
// SwiftUI Version
/*
class Radio: ObservableObject {
    
    @Published var bottomText = BOTTOM_TEXT_RADIO_OFF
 */
// END SwiftUI Version
    
    // Tells whether the radio is currently playing
    private var isPlaying = false
    
    // The audio player object
    private var player: AVPlayer?
    private var radioDelegate: RadioDelegate?
    
    init(_ radioDelegate: RadioDelegate) {
        self.radioDelegate = radioDelegate
    }
    
    func toggleRadio() {
        if self.isPlaying {
            stopRadio()
        } else {
            startRadio()
        }
        
        self.radioDelegate?.radioToggled(bottomText)
    }
    
    // Reference:
    // https://stackoverflow.com/questions/48555049/how-to-stream-audio-from-url-without-downloading-mp3-file-on-device
    func startRadio() {
        guard let url = URL(string: LUMPEN_AUDIO_URL) else {
            print("Could not start radio")
            return
        }
        let playerItem = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: playerItem)
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback,
                                         mode: .default,
                                         options: [.mixWithOthers, .allowAirPlay])
            try audioSession.setActive(true)
            player.play()
            self.isPlaying = true
            self.bottomText = BOTTOM_TEXT_RADIO_ON
            self.player = player
        } catch {
            print(error)
        }
    }
    
    func stopRadio() {
        self.player?.pause()
        self.player = nil
        self.isPlaying = false
        self.bottomText = BOTTOM_TEXT_RADIO_OFF
    }
    
}
