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

    // Create a random float generator between a range of values
    // http://stackoverflow.com/questions/26029393/random-number-between-two-decimals-in-swift
    func randomBetweenNumbers(firstNum: Float, secondNum: Float) -> Float{
        return Float(arc4random()) / Float(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    func randomTimeInterval(firstNum: NSTimeInterval, secondNum: NSTimeInterval) -> NSTimeInterval{
    return NSTimeInterval(arc4random()) / NSTimeInterval(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
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
        
        // create a random slow rate
        var slowRate: Float = randomBetweenNumbers(0.0, secondNum: 1.0)
        println(slowRate)
        // Set the rate for slow playback
        audioPlayer.rate = slowRate
        audioPlayer.play()
    }

    @IBAction func playFastAudio(sender: UIButton) {
        // Prevent audio effects from bleeding into each other
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        // create a random fast rate
        var fastRate = randomBetweenNumbers(1.0, secondNum: 2.0)
        println(fastRate)
        // Set the rate for fast playback
        audioPlayer.rate = fastRate
        audioPlayer.play()
    }
    
    @IBAction func stopPlayback(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        //Chipmunk effect
        var pitchMunk = randomBetweenNumbers(1.0, secondNum: 2400)
        println(pitchMunk)
        playAudioWithVariablePitch(pitchMunk) // Set a pitch value
    }
    
    @IBAction func playDarthAudio(sender: UIButton) {
        // Darth Vader Effect
        var pitchVader = randomBetweenNumbers(-2400, secondNum: 1.0)
        println(pitchVader)
        playAudioWithVariablePitch(pitchVader) // Set a pitch value
    }
    
    @IBAction func echoAudio(sender: UIButton) {
        // Randomize a wetDryMix value, and a delay value
        var wDM = randomBetweenNumbers(0, secondNum: 100)
        var dT = randomTimeInterval(0.0, secondNum: 2.0)
        println(wDM)
        println(dT)
        playEchoAudio(wDM, delay: dT)
    }
    
    @IBAction func reverbAudio(sender: UIButton) {
        // Randomize a wetDryMix value
        var wDM2 = randomBetweenNumbers(0, secondNum: 100)
        println(wDM2)
        playReverbAudio(wDM2)
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
    



