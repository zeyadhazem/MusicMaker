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
    var pluckedString   = AKPluckedString()
    var oscillator      = AKOscillator()
    var currentChord : Int = 0
    
    let scale           = [0, 2, 4, 5, 7, 9, 11, 12]
    var pluckPosition   = 0.2
    
    // Enums
    enum Notes: Int {
        case C = 0, C_Sharp, D, D_Sharp, E, F, F_Sharp, G, G_Sharp, A, A_Sharp, B
    }
    
    enum Scales {
        case Major, Minor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialization
        kick            = AKSynthKick()
        snare           = AKSynthSnare(duration: 0.07)
        flute           = AKFlute()
        mandolin        = AKMandolin()
        mandolin2       = AKMandolin()
        pluckedString   = AKPluckedString()
        
        // Config
        mandolin.detune = 1
        mandolin.bodySize = 10
        mandolin.presetLargeResonantMandolin()
        let mandolinReverb = AKReverb(mandolin)
        
        mandolin2.detune = 1
        mandolin2.bodySize = 1
        mandolin2.presetElectricGuitarMandolin()
        
        // Prepare Output
        let mix = AKMixer(kick, snare, flute, mandolinReverb, mandolin2)
        let reverb = AKReverb(mix)
        
        AudioKit.output = reverb
        AudioKit.start()
        
        // Effects
        reverb.loadFactoryPreset(.mediumRoom)
        
        // "Loop"
        var timerFrequency = 1.0
        var timer = Timer.scheduledTimer(timeInterval: timerFrequency, target: self, selector: Selector("playChord"), userInfo: nil, repeats: true)
        
        var timer2 = Timer.scheduledTimer(timeInterval: timerFrequency/4, target: self, selector: Selector("playMelody"), userInfo: nil, repeats: true)
    }
    
    func playChord(){
        playChord(note: ViewController.Notes(rawValue: currentChord)!, scale: .Major)
        currentChord = Int((currentChord + 7).truncatingRemainder(dividingBy: 12))
    }

    func playMelody(){
        playMelodyNote(note: currentChord, generator: 1, octave: 4)
    }
    
    // Takes a note as an argument
    func playChordNote(note: Notes, generator: Int, octave: Int){
        mandolin.fret(noteNumber: note.rawValue + 12*octave, course: generator)
        mandolin.pluck(course: generator, position: pluckPosition, velocity: 127)
    }
    
    // Takes an Int representing a note as an argument
    func playChordNote(note: Int, generator: Int, octave: Int){
        mandolin.fret(noteNumber: note + 12*octave, course: generator)
        mandolin.pluck(course: generator, position: pluckPosition, velocity: 127)
    }
    
    // Takes a note as an argument
    func playMelodyNote(note: Notes, generator: Int, octave: Int){
        mandolin2.fret(noteNumber: note.rawValue + 12*octave, course: generator)
        mandolin2.pluck(course: generator, position: pluckPosition, velocity: 127)
    }
    
    // Takes an Int representing a note as an argument
    func playMelodyNote(note: Int, generator: Int, octave: Int){
        mandolin2.fret(noteNumber: note + 12*octave, course: generator)
        mandolin2.pluck(course: generator, position: pluckPosition, velocity: 127)
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
    @IBOutlet weak var isNote: UISwitch!
   
    
    
    
    
    @IBAction func ANote(_ sender: UIButton) {
        if (isNote.isOn){
            playChordNote(note: .A, generator: 1, octave: 4)
        }
        else{
            playChord(note: .A, scale: .Major)
        }
    }
    @IBAction func ASharpNote(_ sender: UIButton) {
        if (isNote.isOn){
            playChordNote(note: .A_Sharp, generator: 1, octave: 4)
        }
        else{
            playChord(note: .A_Sharp, scale: .Major)
        }
    }
    @IBAction func BNote(_ sender: UIButton) {
        if (isNote.isOn){
            playChordNote(note: .B, generator: 1, octave: 4)
        }
        else{
            playChord(note: .B, scale: .Major)
        }
    }
    @IBAction func CNote(_ sender: UIButton) {
        if (isNote.isOn){
            playChordNote(note: .C, generator: 1, octave: 4)
        }
        else{
            playChord(note: .C, scale: .Major)
        }
    }
    @IBAction func CSharpNote(_ sender: UIButton) {
        if (isNote.isOn){
            playChordNote(note: .C_Sharp, generator: 1, octave: 4)
        }
        else{
            playChord(note: .C_Sharp, scale: .Major)
        }
    }
    @IBAction func DNote(_ sender: UIButton) {
        if (isNote.isOn){
            playChordNote(note: .D, generator: 1, octave: 4)
        }
        else{
            playChord(note: .D, scale: .Major)
        }
    }
    @IBAction func DSharpNote(_ sender: UIButton) {
        if (isNote.isOn){
            playChordNote(note: .D_Sharp, generator: 1, octave: 4)
        }
        else{
            playChord(note: .D_Sharp, scale: .Major)
        }
    }
    @IBAction func ENote(_ sender: UIButton) {
        if (isNote.isOn){
            playChordNote(note: .E, generator: 1, octave: 4)
        }
        else{
            playChord(note: .E, scale: .Major)
        }
    }
    
    @IBAction func FNote(_ sender: UIButton) {
        if (isNote.isOn) {
            playChordNote(note: .F, generator: 1, octave: 4)
        }
        else {
            playChord(note: .F, scale: .Major)
        }
    }
    @IBAction func FSharpNote(_ sender: UIButton) {
        if (isNote.isOn){
            playChordNote(note: .F_Sharp, generator: 1, octave: 4)
        }
        else{
            playChord(note: .F_Sharp, scale: .Major)
        }
    }
    @IBAction func GNote(_ sender: UIButton) {
        if (isNote.isOn){
            playChordNote(note: .G, generator: 1, octave: 4)
        }
        else{
            playChord(note: .G, scale: .Major)
        }
    }
    @IBAction func GSharpNote(_ sender: UIButton) {
        if (isNote.isOn){
            playChordNote(note: .G_Sharp, generator: 1, octave: 4)
        }
        else{
            playChord(note: .G_Sharp, scale: .Major)
        }
    }
    
    @IBAction func randomFlute(_ sender: UIButton) {
        playRandomFluteNote()
    }
    @IBAction func randomMandolinBtn(_ sender: UIButton) {
        playRandomMandolin()
    }
   
    @IBAction func frequencySlider(_ sender: UISlider) {
        oscillator.frequency = Double (sender.value * 261.63)
    }
    
    func playRandomFluteNote(){
        var note = scale.randomElement()
        let octave = (2..<6).randomElement() * 12
        if random(0, 10) < 1.0 { note += 1 }
        if !scale.contains(note % 12) { print("ACCIDENT!") }
        
        let frequency = (note+octave).midiNoteToFrequency()
        if random(0, 6) > 1.0 {
            flute.trigger(frequency: frequency, amplitude: 0.1)
        } else {
            flute.stop()
        }
    }
    
    func playRandomMandolin(){
        var note1 = scale.randomElement()
        let octave1 = [2,3,4,5].randomElement() * 12
        let course1 = [1,2,3,4].randomElement()
        if random(0, 10) < 1.0 { note1 += 1 }
        
        var note2 = scale.randomElement()
        let octave2 = [2,3,4,5].randomElement() * 12
        let course2 = [1,2,3,4].randomElement()
        if random(0, 10) < 1.0 { note2 += 1 }
        
        
        if random(0, 6) > 1.0 {
            mandolin.fret(noteNumber: note1+octave1, course: course1 - 1)
            mandolin.pluck(course: course1 - 1, position: pluckPosition, velocity: 127)
        }
        if random(0, 6) > 3.0 {
            mandolin.fret(noteNumber: note2+octave2, course: course2 - 1)
            mandolin.pluck(course: course2 - 1, position: pluckPosition, velocity: 127)
        }
    }
    
    func createAndStartOscillator(frequency: Double) -> AKOscillator {
        let oscillator = AKOscillator()
        oscillator.frequency = frequency
        oscillator.start()
        return oscillator
    }


}

