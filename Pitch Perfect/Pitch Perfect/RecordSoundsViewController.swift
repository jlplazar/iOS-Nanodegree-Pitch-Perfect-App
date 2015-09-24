//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jorge Plaza on 9/21/15.
//  Copyright (c) 2015 Jorge Plaza. All rights reserved.
//

import UIKit
import AVFoundation

let SOUND_FILE_NAME = "recorded_sound.wav"

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    let START_RECORDING_TEXT = "Tap the microphone to start recording"
    let RECORDING_TEXT = "Recording ..."
    let PAUSED_TEXT = "Paused"
    
    let STOP_RECORDING_SEGUE = "stopRecording"
    
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    var audioRecorder:AVAudioRecorder?
    var recordedAudio:RecordedAudio?
    var recording: Bool?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAudioRecording()
        recording = false
    }
    
    override func viewWillAppear(animated: Bool) {
        micButton.enabled = true
        stopButton.hidden = true
        pauseButton.hidden = true
        recordingLabel.text = START_RECORDING_TEXT
        pauseButton.setImage(UIImage(named: "pause"), forState: UIControlState.Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == STOP_RECORDING_SEGUE) {
            let soundPlayerVC: SoundPlayerViewController = segue.destinationViewController as! SoundPlayerViewController
            let data = sender as! RecordedAudio
            soundPlayerVC.receivedAudio = data
        }
    }
    

    @IBAction func startRecording(sender: AnyObject) {
        micButton.enabled = false
        stopButton.hidden = false
        pauseButton.hidden = false
        recordingLabel.text = RECORDING_TEXT
        audioRecorder?.record()
        recording = true

    }
    
    @IBAction func pauseRecording(sender: AnyObject) {
        if (recording!) {
            audioRecorder?.pause()
            pauseButton.setImage(UIImage(named: "resume"), forState: UIControlState.Normal)
            recordingLabel.text = PAUSED_TEXT
        } else {
            audioRecorder?.record()
            pauseButton.setImage(UIImage(named: "pause"), forState: UIControlState.Normal)
            recordingLabel.text = RECORDING_TEXT
        }
        recording = !(recording!)
    }
    @IBAction func stopRecording(sender: AnyObject) {
        audioRecorder?.stop()
        micButton.enabled = true
        stopButton.hidden = true
        pauseButton.hidden = true
        recordingLabel.text = START_RECORDING_TEXT
        recording = false
        
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    
    func configureAudioRecording() {
        let directory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let soundFilePath = directory.stringByAppendingPathComponent(SOUND_FILE_NAME)
        let audioFileURL = NSURL(fileURLWithPath: soundFilePath)

        var error: NSError?
        
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, error: &error)
        if let err = error {
            println("Error: \(err)")
        }
        audioRecorder = AVAudioRecorder(URL: audioFileURL, settings: nil, error: &error)
        audioRecorder?.delegate = self
        audioRecorder?.meteringEnabled = true
        if let err = error {
            println("Error: \(err)")
        } else {
            audioRecorder?.prepareToRecord()
        }
    }

    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier(STOP_RECORDING_SEGUE, sender: recordedAudio)
        }
    }
    
}

