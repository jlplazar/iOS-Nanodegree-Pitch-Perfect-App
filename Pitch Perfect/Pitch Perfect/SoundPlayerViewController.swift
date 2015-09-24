//
//  SoundPlayerViewController.swift
//  Pitch Perfect
//
//  Created by Jorge Plaza on 9/23/15.
//  Copyright (c) 2015 Jorge Plaza. All rights reserved.
//

import UIKit
import AVFoundation

class SoundPlayerViewController: UIViewController {

    @IBOutlet weak var effectLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioPlayer:AVAudioPlayer!
    var echoAudioPlayer:AVAudioPlayer!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var receivedAudio:RecordedAudio?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var error: NSError? = nil
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio!.filePathUrl, error: &error)
        audioPlayer.enableRate = true
        if let err = error {
            println("Error: \(err.localizedDescription)")
        }
        
        audioEngine = AVAudioEngine()
        
        audioFile = AVAudioFile(forReading: receivedAudio!.filePathUrl, error: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        effectLabel.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func playSoundSlow(sender: AnyObject) {
        playSound(speed: 0.5)
        effectLabel.text = "Slow Effect"
    }
    
    @IBAction func playSoundFast(sender: AnyObject) {
        playSound(speed: 1.5)
        effectLabel.text = "Fast Effect"
    }
    
    @IBAction func playSoundDarthVader(sender: AnyObject) {
        playSound(pitch: -1000)
        effectLabel.text = "Darth Vader Effect"
    }
    
    @IBAction func playSoundChipmunk(sender: AnyObject) {
        playSound(pitch: 1000)
        effectLabel.text = "Chipmunk Effect"
    }
    
    @IBAction func playSoundNormal(sender: AnyObject) {
        playSound(speed: 1)
        effectLabel.text = "No Effect - Echo"
    }
    
    @IBAction func playSoundWithReverb(sender: AnyObject) {
        playSound(hasReverb: true)
        effectLabel.text = "Reverb Effect"
    }
    
    @IBAction func stopSound(sender: AnyObject?) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioEngine.stop()
        audioEngine.reset()
    }
    
    
    func playSound(#speed: Float) {
        stopSound(nil)
        
        audioPlayer.rate = speed
        audioPlayer.play()
    }
    
    func playSound(#pitch: Float) {
        stopSound(nil)
        stopButton.hidden = false
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func playSound(hasReverb reverb: Bool) {
        stopSound(nil)
        stopButton.hidden = false
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        reverbEffect.wetDryMix = 50
        audioEngine.attachNode(reverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }

}
