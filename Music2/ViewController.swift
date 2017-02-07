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

    @IBAction func toggleSound(_ sender: UIButton) {
        if oscillator.isPlaying {
            oscillator.stop()
            sender.setTitle("Play Sine Wave", for: .normal)
        } else {
            oscillator.start()
            sender.setTitle("Stop Sine Wave", for: .normal)
        }
    }
   
    @IBAction func frequencySlider(_ sender: UISlider) {
        oscillator.frequency = Double (sender.value * 880.0)
    }
    
    var oscillator = AKOscillator()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        oscillator.amplitude = 0.1
        AudioKit.output = oscillator
        AudioKit.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

