//
//  ViewController.swift
//  Music2
//
//  Created by zeyad saleh on 2017-01-31.
//  Copyright © 2017 com.example. All rights reserved.
//

import UIKit
import AudioKit

class ViewController: UIViewController {
    
    var kick = AKSynthKick()
    var snare = AKSynthSnare(duration: 0.07)
    
    @IBAction func kickBtn(_ sender: UIButton) {
        kick.play(noteNumber: 60, velocity: 100)
        kick.stop(noteNumber: 60)
        print("kick")
    }
    @IBAction func snareBtn(_ sender: UIButton) {
        snare.play(noteNumber: 60, velocity: 50)
        snare.stop(noteNumber: 60)
        print("snare")
    }
   
    @IBAction func frequencySlider(_ sender: UISlider) {
        oscillator.frequency = Double (sender.value * 261.63)
    }
    
    var oscillator = AKOscillator()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        kick = AKSynthKick()
        snare = AKSynthSnare(duration: 0.07)
        let mix = AKMixer(kick, snare)
        let reverb = AKReverb(mix)
        AudioKit.output = reverb
        AudioKit.start()
        reverb.loadFactoryPreset(.mediumRoom)
        
        kick.play(noteNumber: 20, velocity: 100)
        kick.stop(noteNumber: 20)
        print("kick")
        
        snare.play(noteNumber: 21, velocity: 50)
        snare.stop(noteNumber: 21)
        print("snare")
    }
    
    
    
    
    
//    func playCChord(){
//        bank.play(noteNumber: 72, velocity: 80)
//        bank.play(noteNumber: 76, velocity: 80)
//        bank.play(noteNumber: 79, velocity: 80)
//        sleep(2)
//        bank.stop(noteNumber: 72)
//        bank.stop(noteNumber: 76)
//        bank.stop(noteNumber: 79)
//    }
    
    func createAndStartOscillator(frequency: Double) -> AKOscillator {
        let oscillator = AKOscillator()
        oscillator.frequency = frequency
        oscillator.start()
        return oscillator
    }


}

