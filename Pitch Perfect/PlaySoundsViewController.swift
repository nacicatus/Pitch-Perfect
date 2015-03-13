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
    
    // Create global object instances
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // Get the audioPlayer to access the receivedAudio from user input
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        // Initialize the audioEngine and the audioFile with the receivedAudio
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        // Prevent audio effects from bleeding into each other
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        // Set the rate for slow playback
        audioPlayer.rate = 0.5
        
        audioPlayer.play()
    }

    @IBAction func playFastAudio(sender: UIButton) {
        // Prevent audio effects from bleeding into each other
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        // Set the rate for fast playback
        audioPlayer.rate = 1.5
        audioPlayer.play()
    }
    
    @IBAction func stopPlayback(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        //Chipmunk effect
        playAudioWithVariablePitch(1000) // Set a pitch value
    }
    
    @IBAction func playDarthAudio(sender: UIButton) {
        // Darth Vader Effect
        playAudioWithVariablePitch(-700) // Set a pitch value
    }
    
    @IBAction func echoAudio(sender: UIButton) {
        playEchoAudio(40, delay: 0.2) // Set a wetDryMix value, and a delay value
    }
    
    @IBAction func reverbAudio(sender: UIButton) {
        playReverbAudio(70.0) // Set a wetDryMix value
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        // Prevent audio effects from bleeding into each other
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        // Create a player node
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // get the pitch value from the IBAction function above and apply it to a new instance of AVAudioTimePitch
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        
        //attach said node to the audioEngine
        audioEngine.attachNode(changePitchEffect)
        
        // Connect all nodes to each other in the audioEngine
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        // get the player node to access the audioFile
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        // Play it!
        audioPlayerNode.play()
    }
    
    
    func playReverbAudio(reverberate: Float) {
        // Prevent audio effects from bleeding into each other
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        // create a Reverberate node
        var audioReverbNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioReverbNode)
        
        // get the wetDryMix value from the IBAction above and attach it to a new instance of AVAudioUnitReverb; attach that node to engine
        var makeReverbEffect = AVAudioUnitReverb()
        makeReverbEffect.wetDryMix = reverberate
        audioEngine.attachNode(makeReverbEffect)
        
        // connect all nodes within Engine
        audioEngine.connect(audioReverbNode, to: makeReverbEffect, format: nil)
        audioEngine.connect(makeReverbEffect, to: audioEngine.outputNode, format: nil)
        
       // get the reverb node to access the audioFile
        audioReverbNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        // Play it!
        audioReverbNode.play()
    }
    
    func playEchoAudio(reverbEcho: Float, delay: NSTimeInterval) {
        // Prevent audio effects from bleeding into each other
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        // create an Echo Node and attach it to the audioEngine
        var audioEchoEffectNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioEchoEffectNode)
        
        // get the values for wetDryMix and delayTime from IBAction above and set them; attach node to engine
        var makeEchoEffect = AVAudioUnitDelay()
        makeEchoEffect.delayTime = delay
        makeEchoEffect.wetDryMix = reverbEcho
        audioEngine.attachNode(makeEchoEffect)
        
        // Connect all nodes within enginge
        audioEngine.connect(audioEchoEffectNode, to: makeEchoEffect, format: nil)
        audioEngine.connect(makeEchoEffect, to: audioEngine.outputNode, format: nil)
        
        // get the Echo Node to access the audioFile
        audioEchoEffectNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        //Play it!
        audioEchoEffectNode.play()

    }
}
    



