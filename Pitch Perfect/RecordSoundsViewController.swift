//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Saurabh Sikka on 09/03/15.
//  Copyright (c) 2015 Saurabh Sikka. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopLabel: UILabel!
    @IBOutlet weak var pauseLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        // Make sure these UI elements appear every time
        stopButton.hidden = true
        stopLabel.hidden = true
        pauseButton.hidden = true
        pauseLabel.hidden = true
        recordButton.enabled = true
        recLabel.text = "Tap to Record"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        // Do Magic with buttons
        recLabel.text = "Recording..."
        stopButton.hidden = false
        stopLabel.hidden = false
        pauseButton.hidden = false
        pauseLabel.hidden = false
        recordButton.enabled = false
        
        
        // Set up to Record Audio

        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) [0] 
        // Use current date and time to give the recorded sound an identity
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        // Create an Audio Play & Record session
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
        }
        
        // Record it!
        do {
           try audioRecorder = AVAudioRecorder(URL: filePath!, settings: [dirPath : recordingName])
        } catch _ {
            
        }
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag) {
            // Initialize the recorded audio when you're done recording
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            // Perform a segue to the second View
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
                } else {
                    print("Unsuccessful recording")
                    recordButton.enabled = true
                    stopButton.hidden =  true
                    stopLabel.hidden = true
                    pauseButton.hidden = true
                    pauseLabel.hidden = true
                }
        }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Pass the recorded audio in the first ViewController to the second ViewController
        if (segue.identifier == "stopRecording") {
            let PlaySoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            PlaySoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        // Do magic with buttons
        recLabel.text = "Recording Paused"
        stopButton.enabled = false
        stopLabel.hidden = true
        pauseButton.hidden = false
        pauseLabel.text = "Release to Resume"
        recordButton.enabled = true
        audioRecorder.pause()
    }
    
    @IBAction func resumeRecording(sender: UIButton) {
        // Do Magic with buttons
        recLabel.text = "Recording..."
        stopButton.enabled = true
        stopLabel.hidden = false
        pauseButton.hidden = false
        pauseLabel.text = "Hold to Pause"
        recordButton.enabled = false
        
        
        // Set up to Record Audio
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        // Use current date and time to give the recorded sound an identity
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        // Create an Audio Play & Record session
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
        }
        
        // Record it!
       // audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        // Stop and reset the recording scene
        recLabel.text = "Tap to Record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
    }
}

