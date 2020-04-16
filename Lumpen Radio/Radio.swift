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
fileprivate let LUMPEN_AUDIO_URL: String = "http://mensajito.mx:8000/lumpen"
fileprivate let NOW_PLAYING_TITLE = "Lumpen Radio"
fileprivate let NOW_PLAYING_ALBUM_TITLE = "WLPN 105.5 FM Chicago"
fileprivate let NOW_PLAYING_ARTWORK_IMG = "AppIcon"

protocol RadioDelegate {
    func radioToggled()
}

// UIKit Version
class Radio {
    
// END UIKit Version
    
// SwiftUI Version
/*
class Radio: ObservableObject {
 */
// END SwiftUI Version
    
    // Tells whether the radio is currently playing
    var isPlaying = false
    
    // The audio player object
    private var player: AVPlayer?
    private var radioDelegate: RadioDelegate?
    
    init(_ radioDelegate: RadioDelegate) {
        self.radioDelegate = radioDelegate
    }
    
    @objc func introHasPlayed() {
        // Set that the intro has been played already for this session
        UserDefaults.standard.set(false, forKey: USERDEFAULTS_KEY_RADIO_INTRO)
        
        // Remove observer just in case this is called from NotificationCenter
        NotificationCenter.default.removeObserver(self)
        stopRadio()
        toggleRadio()
    }
    
    func toggleRadio() {
        if self.isPlaying {
            stopRadio()
        } else {
            if UserDefaults.standard.bool(forKey: USERDEFAULTS_KEY_RADIO_INTRO) {
                // Play intro
                guard let url = Bundle.main.url(forResource: RADIO_INTRO_FILENAME,
                                                withExtension: RADIO_INTRO_FILETYPE) else {
                    UserDefaults.standard.set(false,
                                              forKey: USERDEFAULTS_KEY_RADIO_INTRO)
                    toggleRadio()
                    return
                }
                let playerItem = AVPlayerItem(url: url)
                self.player = AVPlayer(playerItem: playerItem)
                
                // Set observer
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(introHasPlayed),
                                                       name: .AVPlayerItemDidPlayToEndTime,
                                                       object: self.player?.currentItem)
                
                self.player?.play()
            } else {
                startRadio()
                setupNowPlaying()
                setupRemoteCommandCenter()
            }
        }
        
        self.radioDelegate?.radioToggled()
    }
    
    // Helper function to extract out the give player's URLAsset as absolute string
    static func getItemAssetURLAsString(_ player: AVPlayer?) -> String {
        return ((player?.currentItem?.asset) as? AVURLAsset)?.url.absoluteString ?? ""
    }
    
    // Reference:
    // https://stackoverflow.com/questions/48555049/how-to-stream-audio-from-url-without-downloading-mp3-file-on-device
    func startRadio() {
        
        guard let url = URL(string: LUMPEN_AUDIO_URL) else {
            print("Could not start radio")
            return
        }
        let playerItem = AVPlayerItem(url: url)
        
        // Set up player if it's nil
        if (self.player == nil || Radio.getItemAssetURLAsString(self.player) != url.absoluteString) {
            self.player = AVPlayer(playerItem: playerItem)
        }
        
        self.player?.play()
        self.isPlaying = true
    }
    
    func stopRadio() {
        self.player?.pause()
        self.isPlaying = false
        
        // Add a fresh PlayerItem so when feed starts again it plays the latest off the feed
        guard let url = URL(string: LUMPEN_AUDIO_URL) else {
            print("Could not start radio")
            return
        }
        let playerItem = AVPlayerItem(url: url)
        self.player?.replaceCurrentItem(with: playerItem)
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
        nowPlayingInfo[MPMediaItemPropertyTitle] = NOW_PLAYING_TITLE
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = NOW_PLAYING_ALBUM_TITLE

        if let image = UIImage(named: NOW_PLAYING_ARTWORK_IMG) {
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
            }
        }
        
        let playerItem = self.player?.currentItem
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
            self.radioDelegate?.radioToggled()
            return .success
        }
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget {[weak self] event in
            guard let `self` = self else {
                return .commandFailed
            }
            self.stopRadio()
            self.radioDelegate?.radioToggled()
            return .success
        }
    }
}
