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
    
    // Global Vars
    var kick            = AKSynthKick()
    var snare           = AKSynthSnare(duration: 0.07)
    var flute           = AKFlute()
    var mandolin        = AKMandolin()
    var mandolin2       = AKMandolin()
    var clarinet        = AKClarinet()
    var timer = Timer()
    var timer2 = Timer()
    
    var deltaTemp   : Double = 0.3
    var deltaEDA     : Double = 0.3
    var baselineTemp: Double = 36
    var baselineEDA : Double = 0
    var currentTemp : Double = 36.4
    var currentEDA  : Double = 0.2
    var currentChord: Int    = 0
    var timerFrequency:Double = 1.0
    var pluckPosition   = 0.5
    var mandolin2PluckPosition = 0.2
    var majorScale = [0,2,4,5,7,9,11]
    var scaleIndex = 0
    
    
    // Enums
    enum Notes: Int {
        case C = 0, C_Sharp, D, D_Sharp, E, F, F_Sharp, G, G_Sharp, A, A_Sharp, B
    }
    
    enum Scales {
        case Major, Minor
    }
    
    //Outlets
    @IBOutlet weak var isChord: UISwitch!
    @IBOutlet weak var biomusicOption: UISwitch!
    @IBAction func tempPlus(_ sender: UIButton) {
        currentTemp+=0.1
    }
    @IBAction func tempMinus(_ sender: UIButton) {
        currentTemp-=0.1
    }
    @IBAction func edaPlus(_ sender: UIButton) {
        currentEDA+=0.1
    }
    @IBAction func edaMinus(_ sender: UIButton) {
        currentEDA-=0.1
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialization
        kick            = AKSynthKick()
        snare           = AKSynthSnare(duration: 0.07)
        mandolin        = AKMandolin()
        mandolin2       = AKMandolin()
        
        // Config
        mandolin.detune = 1
        mandolin.bodySize = 1000
        mandolin.rampTime = 10000
        mandolin.presetLargeResonantMandolin()
        let mandolinReverb = AKCostelloReverb(mandolin)
        
        mandolinReverb.feedback = 2.0
        
        mandolin2.detune = 1
        mandolin2.bodySize = 1.95
        //mandolin2.presetElectricGuitarMandolin()
       
        let mandolin2Effect = AKLowPassFilter(mandolin2)
        
        //mandolin2Effect.cutoffFrequency = 3000
        let mandolin2Reverb = AKCostelloReverb(mandolin2Effect)
        
        mandolin2Reverb.feedback = 0.9
        
        // Prepare Output
        let mix = AKMixer(kick, snare, mandolinReverb, mandolin2Reverb, clarinet)
        let reverb = AKReverb(mix)
        
        AudioKit.output = reverb
        AudioKit.start()
        
        // Effects
        reverb.loadFactoryPreset(.mediumRoom)
        
        // Start Timers
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.playChord as (ViewController) -> () -> ()), userInfo: nil, repeats: true)
        timer2 = Timer.scheduledTimer(timeInterval: 1.0/4, target: self, selector: #selector(ViewController.playMelody), userInfo: nil, repeats: true)
    }
    
    func playChord(){
        let lastChord = currentChord
        
        if (abs(currentTemp - baselineTemp) > deltaTemp){
            stopChord(note: ViewController.Notes(rawValue: currentChord)!, scale: .Major)
            
            if (currentTemp > baselineTemp){    //Step up to the next chord in the cycle of fifth
                currentChord = Int((currentChord + 7).truncatingRemainder(dividingBy: 12))
                baselineTemp += deltaTemp
            }
            else {      //Step down to the precious chord in the cycle of fifth
                currentChord = Int((currentChord - 7).truncatingRemainder(dividingBy: 12))
                baselineTemp -= deltaTemp
            }
            if (currentChord < 0){
                currentChord = 12 + currentChord
            }
            scaleIndex = 0
        }
        
        if(biomusicOption.isOn && lastChord != currentChord){
            playChord(note: ViewController.Notes(rawValue: currentChord)!, scale: .Major)
        }
    }

    func playMelody(){
        if (abs(currentEDA - baselineEDA) > deltaEDA){
            if (currentEDA > baselineEDA){    //Step up to the next chord in the cycle of fifth
                scaleIndex = Int((scaleIndex + 1).truncatingRemainder(dividingBy: 7))
                baselineEDA += deltaEDA
            }
            else {      //Step down to the precious chord in the cycle of fifth
                scaleIndex = Int((scaleIndex - 1).truncatingRemainder(dividingBy: 7))
                baselineEDA -= deltaEDA
            }
            if (scaleIndex < 0){
                scaleIndex = 7 + scaleIndex
            }
        }
        
        
        if(biomusicOption.isOn){
            playMelodyNote(note: currentChord + majorScale[scaleIndex], generator: 1, octave: 4)
        }
    }
    
    func stopChordNote(note: Int, generator: Int, octave: Int){
        //mandolin.fret(noteNumber: note + 12*octave, course: generator)
        //mandolin.pluck(course: generator, position: pluckPosition, velocity: 127)
    }
    
    
    // Takes an Int representing a note as an argument
    func playChordNote(note: Int, generator: Int, octave: Int){
        mandolin.fret(noteNumber: note + 12*octave, course: generator)
        mandolin.pluck(course: generator, position: pluckPosition, velocity: 127)
    }
    
    // Takes a note as an argument
    func playMelodyNote(note: Notes, generator: Int, octave: Int){
        mandolin2.fret(noteNumber: note.rawValue + 12*octave, course: generator)
        mandolin2.pluck(course: generator, position: mandolin2PluckPosition, velocity: 127)
    }
    
    // Takes an Int representing a note as an argument
    func playMelodyNote(note: Int, generator: Int, octave: Int){
        mandolin2.fret(noteNumber: note + 12*octave, course: generator)
        mandolin2.pluck(course: generator, position: mandolin2PluckPosition, velocity: 127)
    }

    
    func stopChord(note: Notes, scale: Scales){
        switch scale {
        case .Major:    //1 - 4 - 7
            stopChordNote(note: note.rawValue, generator: 1, octave: 4)
            stopChordNote(note: (Int)((note.rawValue + 4).truncatingRemainder(dividingBy: 12)), generator: 2, octave: 4)  //Mod
            stopChordNote(note: (Int)((note.rawValue + 7).truncatingRemainder(dividingBy:12)), generator: 3, octave: 4)
        case .Minor:    //1 - 3 - 7
            stopChordNote(note: note.rawValue, generator: 1, octave: 4)
            stopChordNote(note: (Int)((note.rawValue + 3).truncatingRemainder(dividingBy: 12)), generator: 2, octave: 4)
            stopChordNote(note: (Int)((note.rawValue + 7).truncatingRemainder(dividingBy:12)), generator: 3, octave: 4)
        }
    }
    
    
    func playChord(note: Notes, scale: Scales){
        switch scale {
        case .Major:    //1 - 4 - 7
            playChordNote(note: note.rawValue, generator: 1, octave: 4)
            playChordNote(note: (Int)((note.rawValue + 4).truncatingRemainder(dividingBy: 12)), generator: 2, octave: 4)  //Mod
            playChordNote(note: (Int)((note.rawValue + 7).truncatingRemainder(dividingBy:12)), generator: 3, octave: 4)
        case .Minor:    //1 - 3 - 7
            playChordNote(note: note.rawValue, generator: 1, octave: 4)
            playChordNote(note: (Int)((note.rawValue + 3).truncatingRemainder(dividingBy: 12)), generator: 2, octave: 4)
            playChordNote(note: (Int)((note.rawValue + 7).truncatingRemainder(dividingBy:12)), generator: 3, octave: 4)
        }
    }
    
    
    @IBAction func ANote(_ sender: UIButton) {
        if (isChord.isOn){
            playChord(note: .A, scale: .Major)
        }
        else{
            playMelodyNote(note: .A, generator: 2, octave: 4)
        }
    }
    @IBAction func ASharpNote(_ sender: UIButton) {
        if (isChord.isOn){
            playChord(note: .A_Sharp, scale: .Major)
        }
        else{
            playMelodyNote(note: .A_Sharp, generator: 2, octave: 4)
        }
    }
    @IBAction func BNote(_ sender: UIButton) {
        if (isChord.isOn){
            playChord(note: .B, scale: .Major)
        }
        else{
            playMelodyNote(note: .B, generator: 2, octave: 4)
        }
    }
    @IBAction func CNote(_ sender: UIButton) {
        if (isChord.isOn){
            playChord(note: .C, scale: .Major)
        }
        else{
            playMelodyNote(note: .C, generator: 2, octave: 4)
        }
    }
    @IBAction func CSharpNote(_ sender: UIButton) {
        if (isChord.isOn){
            playChord(note: .C_Sharp, scale: .Major)
        }
        else{
            playMelodyNote(note: .C_Sharp, generator: 2, octave: 4)
        }
    }
    @IBAction func DNote(_ sender: UIButton) {
        if (isChord.isOn){
            playChord(note: .D, scale: .Major)
        }
        else{
            playMelodyNote(note: .D, generator: 2, octave: 4)
        }
    }
    @IBAction func DSharpNote(_ sender: UIButton) {
        if (isChord.isOn){
            playChord(note: .D_Sharp, scale: .Major)
        }
        else{
            playMelodyNote(note: .D_Sharp, generator: 2, octave: 4)
        }
    }
    @IBAction func ENote(_ sender: UIButton) {
        if (isChord.isOn){
            playChord(note: .E, scale: .Major)
        }
        else{
            playMelodyNote(note: .E, generator: 2, octave: 4)
        }
    }
    
    @IBAction func FNote(_ sender: UIButton) {
        if (isChord.isOn) {
            playChord(note: .F, scale: .Major)
        }
        else {
            playMelodyNote(note: .F, generator: 2, octave: 4)
        }
    }
    @IBAction func FSharpNote(_ sender: UIButton) {
        if (isChord.isOn){
            playChord(note: .F_Sharp, scale: .Major)
        }
        else{
            playMelodyNote(note: .F_Sharp, generator: 2, octave: 4)
        }
    }
    @IBAction func GNote(_ sender: UIButton) {
        if (isChord.isOn){
            playChord(note: .G, scale: .Major)
        }
        else{
            playMelodyNote(note: .G, generator: 2, octave: 4)
        }
    }
    @IBAction func GSharpNote(_ sender: UIButton) {
        if (isChord.isOn){
            playChord(note: .G_Sharp, scale: .Major)
        }
        else{
            playMelodyNote(note: .G_Sharp, generator: 2, octave: 4)
        }
    }
    
    @IBAction func frequencySlider(_ sender: UISlider) {
        timer.invalidate()
        timer2.invalidate()
        
        timerFrequency = (Double(sender.value))
        print(sender.value)
        timer = Timer.scheduledTimer(timeInterval: timerFrequency, target: self, selector: #selector(ViewController.playChord as (ViewController) -> () -> ()), userInfo: nil, repeats: true)
        
        timer2 = Timer.scheduledTimer(timeInterval: timerFrequency/4, target: self, selector: #selector(ViewController.playMelody), userInfo: nil, repeats: true)
    }
}

