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
    @IBOutlet weak var radioButton: UIButton!
    
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.player?.pause()
    }
    
    @IBAction func radioButtonTapped(_ sender: Any) {
        radio?.toggleRadio()
    }
    
    func radioToggled(_ textContent: String) {
        radioSubtext.text = textContent
        toggleVideo()
    }
    
    private func registerAppLifeCycleEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(pauseVideo), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(toggleVideo), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    private func unregisterAppLifeCycleEvents() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc private func pauseVideo() {
        self.player?.pause()
    }
    
    // Create the transition animation
    private func createTransitionAnimation() -> CATransition {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeIn)
        transition.type = .fade
        return transition
    }
    
    @objc private func toggleVideo() {
        if self.radio?.isPlaying == true {
            self.player?.play()
            
            radioButton.layer.add(createTransitionAnimation(), forKey: nil)
            radioButton.setImage(UIImage(named: "lumpen_hand_on"), for: .normal)
        } else {
            pauseVideo()
            
            radioButton.layer.add(createTransitionAnimation(), forKey: nil)
            radioButton.setImage(UIImage(named: "lumpen_hand_off"), for: .normal)
        }
    }
    
    private func initializeVideoPlayerWithVideo() {


        // create a video layer for the player
        let layer: AVPlayerLayer = AVPlayerLayer(player: player)

        // make the layer the same size as the container view
        layer.frame = self.view.bounds

        // make the video fill the layer as much as possible while keeping its aspect size
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill

        // add the layer to the container
        self.view.layer.insertSublayer(layer, at: 0)
        
    }
}
