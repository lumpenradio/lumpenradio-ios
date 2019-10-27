//
//  MainViewController.swift
//  Lumpen Radio
//
//  Created by Anthony on 10/22/19.
//  Copyright © 2019 Public Media Institute. All rights reserved.
//

import UIKit
import MediaPlayer

class MainViewController: UIViewController, RadioDelegate {

    private var radio: Radio?
    private var player: AVPlayer?
    
    @IBOutlet weak var radioSubtext: UILabel!
    
    deinit {
        unregisterAppLifeCycleEvents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        radio = Radio(self)
        radio?.setupAudioSession()
        initializeVideoPlayerWithVideo()
        registerAppLifeCycleEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.player?.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.player?.pause()
    }
    
    @IBAction func radioButtonTapped(_ sender: Any) {
        radio?.toggleRadio()
    }
    
    func radioToggled(_ textContent: String) {
        radioSubtext.text = textContent
    }
    
    private func registerAppLifeCycleEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(pauseVideo), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playVideo), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    private func unregisterAppLifeCycleEvents() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc private func pauseVideo() {
        self.player?.pause()
    }
    
    @objc private func playVideo() {
        self.player?.play()
    }
    
    private func initializeVideoPlayerWithVideo() {

        // get the path string for the video from assets
        let videoString:String? = Bundle.main.path(forResource: "turntable-loop-1920x500-h264-512kbps-h264", ofType: "mp4")
        guard let unwrappedVideoPath = videoString else {return}

        // convert the path string to a url
        let videoUrl = URL(fileURLWithPath: unwrappedVideoPath)

        // initialize the video player with the url
        self.player = AVPlayer(url: videoUrl)

        // create a video layer for the player
        let layer: AVPlayerLayer = AVPlayerLayer(player: player)

        // make the layer the same size as the container view
        layer.frame = self.view.bounds

        // make the video fill the layer as much as possible while keeping its aspect size
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill

        // add the layer to the container
        self.view.layer.insertSublayer(layer, at: 0)
        
        // play video
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) { [weak self] _ in
            guard let `self` = self else {return}
            self.player?.seek(to: CMTime.zero)
            self.player?.play()
        }
    }
}
