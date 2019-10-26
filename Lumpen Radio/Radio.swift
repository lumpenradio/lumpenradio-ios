//
//  Radio.swift
//  Lumpen Radio
//
//  Created by Anthony on 10/20/19.
//  Copyright © 2019 Public Media Institute. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

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
    private var playerItem: AVPlayerItem?
    private var radioDelegate: RadioDelegate?
    
    init(_ radioDelegate: RadioDelegate) {
        self.radioDelegate = radioDelegate
    }
    
    func toggleRadio() {
        if self.isPlaying {
            stopRadio()
        } else {
            startRadio()
            setupNowPlaying()
            setupRemoteCommandCenter()
        }
        
        self.radioDelegate?.radioToggled(bottomText)
    }
    
    // Reference:
    // https://stackoverflow.com/questions/48555049/how-to-stream-audio-from-url-without-downloading-mp3-file-on-device
    func startRadio() {
        if self.player != nil {
            self.player?.play()
            self.isPlaying = true
            self.bottomText = BOTTOM_TEXT_RADIO_ON
            return
        }
        guard let url = URL(string: LUMPEN_AUDIO_URL) else {
            print("Could not start radio")
            return
        }
        self.playerItem = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: playerItem)
        
        player.play()
        self.isPlaying = true
        self.bottomText = BOTTOM_TEXT_RADIO_ON
        self.player = player    }
    
    func stopRadio() {
        self.player?.pause()
        // no need to release the player, as it will cause a delay when tuning in again
//        self.player = nil
        self.isPlaying = false
        self.bottomText = BOTTOM_TEXT_RADIO_OFF
    }
    
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.allowBluetooth, .allowAirPlay])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
    func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = "Lumpen Radio - Now Playing"

        if let image = UIImage(named: "AppIcon") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
            }
        }
        
        nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = true
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playerItem?.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = playerItem?.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        
        if #available(iOS 13.0, *) {
            MPNowPlayingInfoCenter.default().playbackState = .playing
        } else {
            // Fallback on earlier versions
        }
    }
    
    func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared();
                commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget {[weak self] event in
            guard let `self` = self else {
                return .commandFailed
            }
            self.startRadio()
            self.radioDelegate?.radioToggled(self.bottomText)
            return .success
        }
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget {[weak self] event in
            guard let `self` = self else {
                return .commandFailed
            }
            self.stopRadio()
            self.radioDelegate?.radioToggled(self.bottomText)
            return .success
        }
    }
}
