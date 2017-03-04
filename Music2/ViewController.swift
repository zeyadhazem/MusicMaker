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
    var flute = AKFlute()
    var mandolin = AKMandolin()
    let scale = [0, 2, 4, 5, 7, 9, 11, 12]
    var pluckPosition = 0.2
    
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
            playANote()
        }
        else{
            playAChord()
        }
    }
    @IBAction func ASharpNote(_ sender: UIButton) {
        if (isNote.isOn){
            playASharpNote()
        }
        else{
            playASharpChord()
        }
    }
    @IBAction func BNote(_ sender: UIButton) {
        if (isNote.isOn){
            playBNote()
        }
        else{
            playBChord()
        }
    }
    @IBAction func CNote(_ sender: UIButton) {
        if (isNote.isOn){
            playCNote()
        }
        else{
            playCChord()
        }
    }
    @IBAction func CSharpNote(_ sender: UIButton) {
        if (isNote.isOn){
            playCSharpNote()
        }
        else{
            playCSharpChord()
        }
    }
    @IBAction func DNote(_ sender: UIButton) {
        if (isNote.isOn){
            playDNote()
        }
        else{
            playDChord()
        }
    }
    @IBAction func DSharpNote(_ sender: UIButton) {
        if (isNote.isOn){
            playDSharpNote()
        }
        else{
            playDSharpChord()
        }
    }
    @IBAction func ENote(_ sender: UIButton) {
        if (isNote.isOn){
            playENote()
        }
        else{
            playEChord()
        }
    }
    
    @IBAction func FNote(_ sender: UIButton) {
        if (isNote.isOn){
            playFNote()
        }
        else{
            playFChord()
        }
    }
    @IBAction func FSharpNote(_ sender: UIButton) {
        if (isNote.isOn){
            playFSharpNote()
        }
        else{
            playFSharpChord()
        }
    }
    @IBAction func GNote(_ sender: UIButton) {
        if (isNote.isOn){
            playGNote()
        }
        else{
            playGChord()
        }
    }
    @IBAction func GSharpNote(_ sender: UIButton) {
        if (isNote.isOn){
            playGSharpNote()
        }
        else{
            playGSharpChord()
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
    
    var oscillator = AKOscillator()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        kick = AKSynthKick()
        snare = AKSynthSnare(duration: 0.07)
        flute = AKFlute()
        mandolin = AKMandolin()
        mandolin.detune = 1
        mandolin.bodySize = 1
        mandolin.presetElectricGuitarMandolin()
        let mix = AKMixer(kick, snare, flute, mandolin)
        let reverb = AKReverb(mix)
        AudioKit.output = reverb
        AudioKit.start()
        reverb.loadFactoryPreset(.mediumRoom)
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
    
    func playANote(){
        mandolin.fret(noteNumber: 57, course: 1)
        mandolin.pluck(course: 1, position: pluckPosition, velocity: 127)
    }
    func playASharpNote(){
        mandolin.fret(noteNumber: 58, course: 1)
        mandolin.pluck(course: 1, position: pluckPosition, velocity: 127)
    }
    func playBNote(){
        mandolin.fret(noteNumber: 59, course: 1)
        mandolin.pluck(course: 1, position: pluckPosition, velocity: 127)
    }
    func playCNote(){
        mandolin.fret(noteNumber: 48, course: 1)
        mandolin.pluck(course: 1, position: pluckPosition, velocity: 127)
    }
    func playCSharpNote(){
        mandolin.fret(noteNumber: 49, course: 1)
        mandolin.pluck(course: 1, position: pluckPosition, velocity: 127)
    }
    func playDNote(){
        mandolin.fret(noteNumber: 50, course: 1)
        mandolin.pluck(course: 1, position: pluckPosition, velocity: 127)
    }
    func playDSharpNote(){
        mandolin.fret(noteNumber: 51, course: 1)
        mandolin.pluck(course: 1, position: pluckPosition, velocity: 127)
    }
    func playENote(){
        mandolin.fret(noteNumber: 52, course: 1)
        mandolin.pluck(course: 1, position: pluckPosition, velocity: 127)
    }
    func playFNote(){
        mandolin.fret(noteNumber: 53, course: 1)
        mandolin.pluck(course: 1, position: pluckPosition, velocity: 127)
    }
    func playFSharpNote(){
        mandolin.fret(noteNumber: 54, course: 1)
        mandolin.pluck(course: 1, position: pluckPosition, velocity: 127)
    }
    func playGNote(){
        mandolin.fret(noteNumber: 55, course: 1)
        mandolin.pluck(course: 1, position: pluckPosition, velocity: 127)
    }
    func playGSharpNote(){
        mandolin.fret(noteNumber: 56, course: 1)
        mandolin.pluck(course: 1, position: pluckPosition, velocity: 127)
    }
    
    
    
    func playAChord(){
        playANote()
        playCSharpNote()
        playENote()
    }
    func playASharpChord(){
        playASharpNote()
        playDNote()
        playFNote()
    }
    func playBChord(){
        playBNote()
        playDSharpNote()
        playFSharpNote()
    }
    func playCChord(){
        playCNote()
        playENote()
        playGNote()
    }
    func playCSharpChord(){
        playCSharpNote()
        playFChord()
        playGSharpNote()
    }
    func playDChord(){
        playDNote()
        playFSharpNote()
        playANote()
    }
    func playDSharpChord(){
        playDSharpNote()
        playENote()
        playASharpNote()
    }
    func playEChord(){
        playENote()
        playGSharpNote()
        playBNote()
    }
    func playFChord(){
        playFNote()
        playANote()
        playCNote()
    }
    func playFSharpChord(){
        playFSharpNote()
        playASharpNote()
        playCSharpNote()
    }
    func playGChord(){
        playGNote()
        playBNote()
        playDNote()
    }
    func playGSharpChord(){
        playGSharpNote()
        playCNote()
        playDSharpNote()
    }
    
    
    
    
    
    
    
    func createAndStartOscillator(frequency: Double) -> AKOscillator {
        let oscillator = AKOscillator()
        oscillator.frequency = frequency
        oscillator.start()
        return oscillator
    }


}

