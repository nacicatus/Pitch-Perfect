//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Saurabh Sikka on 10/03/15.
//  Copyright (c) 2015 Saurabh Sikka. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var audioReverb: AVAudioUnitReverbPreset!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.rate = 0.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }

    @IBAction func playFastAudio(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.rate = 1.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func stopPlayback(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        //chipmunk effect
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthAudio(sender: UIButton) {
        // Darth Vader Effect
        playAudioWithVariablePitch(-700)
    }
    
    @IBAction func echoAudio(sender: UIButton) {
        playEchoAudio(40, delay: 0.2)
    }
    
    @IBAction func reverbAudio(sender: UIButton) {
        playReverbAudio(70.0)
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
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
    
    
    func playReverbAudio(reverberate: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        // create a reverberate node
        var audioReverbNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioReverbNode)
        var changeReverbEffect = AVAudioUnitReverb()
        changeReverbEffect.wetDryMix = reverberate
        audioEngine.attachNode(changeReverbEffect)
        
        audioEngine.connect(audioReverbNode, to: changeReverbEffect, format: nil)
        audioEngine.connect(changeReverbEffect, to: audioEngine.outputNode, format: nil)
       
        audioReverbNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioReverbNode.play()
    }
    
    func playEchoAudio(reverbEcho: Float, delay: NSTimeInterval) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        // create an Echo Node
        var audioEchoEffect = AVAudioPlayerNode()
        audioEngine.attachNode(audioEchoEffect)
        var changeEchoEffect = AVAudioUnitDelay()
        changeEchoEffect.delayTime = delay
        changeEchoEffect.wetDryMix = reverbEcho
        audioEngine.attachNode(changeEchoEffect)
        
        audioEngine.connect(audioEchoEffect, to: changeEchoEffect, format: nil)
        audioEngine.connect(changeEchoEffect, to: audioEngine.outputNode, format: nil)
        audioEchoEffect.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioEchoEffect.play()

    }
}
    



