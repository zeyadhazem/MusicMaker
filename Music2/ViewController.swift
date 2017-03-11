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
    
    // Global Vars for music generation
    var kick            = AKSynthKick()
    var snare           = AKSynthSnare(duration: 0.07)
    var flute           = AKFlute()
    var mandolin        = AKMandolin()
    var mandolin2       = AKMandolin()
    var clarinet        = AKClarinet()
    var timer = Timer()
    var timer2 = Timer()
    
    // Global vars for derivative calculation
    let time: [Double] = [0, 0.24, 2*0.24, 3*0.24, 4*0.24]
    var quadraticTime: [[Double]] = [[Double]](repeating: [0.0], count: 5)
    var linearTime: [[Double]] = [[Double]](repeating: [0.0], count: 5)
    
    let readingsNumber = 5
    var currentReadings = 0
    var temperatureReadings: [Double] = [0, 0, 0, 0, 0]
    var newTemperatureReading: Double = 0.0
    var GSRReadings: [Double] = [0, 0, 0, 0, 0]
    var newGSRReading: Double = 0.0
    
    var deltaTemp   : Double = 0.03
    var deltaEDA     : Double = 0.0025
    var baselineTemp: Double = 0
    var baselineEDA : Double = 0
    var currentTemp : Double = 36.4
    var currentEDA  : Double = 0.1
    var currentChord: Int    = 0
    var timerFrequency:Double = 1.0
    var pluckPosition   = 0.5
    var mandolin2PluckPosition = 0.2
    var majorScale = [0,2,4,5,7,9,11]
    var scaleIndex = 0
    
    
    var allGSRReadings: [Double] = [0.0781471,
                                    0.0755849,
                                    0.076866,
                                    0.0755849,
                                    0.0755849,
                                    0.076866,
                                    0.076866,
                                    0.0755849,
                                    0.076866,
                                    0.0755849,
                                    0.076866,
                                    0.0781471,
                                    0.0755849,
                                    0.0781471,
                                    0.076866,
                                    0.076866,
                                    0.076866,
                                    0.0781471,
                                    0.0781471,
                                    0.0781471,
                                    0.0781471,
                                    0.0781471,
                                    0.0794282,
                                    0.0781471,
                                    0.0794282,
                                    0.0781471,
                                    0.0781471,
                                    0.0781471,
                                    0.0794282,
                                    0.0794282,
                                    0.0781471,
                                    0.076866,
                                    0.0794282,
                                    0.0781471,
                                    0.076866,
                                    0.0794282,
                                    0.0781471,
                                    0.0755849,
                                    0.0781471,
                                    0.076866,
                                    0.076866,
                                    0.076866,
                                    0.0743038,
                                    0.0755849,
                                    0.076866,
                                    0.0743038,
                                    0.076866,
                                    0.0755849,
                                    0.0743038,
                                    0.0755849,
                                    0.0755849,
                                    0.0755849,
                                    0.0755849,
                                    0.076866,
                                    0.076866,
                                    0.0781471,
                                    0.076866,
                                    0.0781471,
                                    0.0781471,
                                    0.0781471,
                                    0.0781471,
                                    0.0794282,
                                    0.0794282,
                                    0.0807093,
                                    0.0794282,
                                    0.0807093,
                                    0.0819904,
                                    0.0794282,
                                    0.0832715,
                                    0.0832715,
                                    0.0819904,
                                    0.0832715,
                                    0.0845526,
                                    0.0832715,
                                    0.0845526,
                                    0.0845526,
                                    0.0832715,
                                    0.0832715,
                                    0.0819904,
                                    0.0845526,
                                    0.0845526,
                                    0.0832715,
                                    0.0845526,
                                    0.0845526,
                                    0.0845526,
                                    0.0845526,
                                    0.0858337,
                                    0.0845526,
                                    0.0845526,
                                    0.0858337,
                                    0.0858337,
                                    0.0858337,
                                    0.0845526,
                                    0.0845526,
                                    0.0858337,
                                    0.0845526,
                                    0.0845526,
                                    0.0845526,
                                    0.0845526,
                                    0.0871148,
                                    0.0858337,
                                    0.0871148,
                                    0.0871148,
                                    0.0858337,
                                    0.0871148,
                                    0.0871148,
                                    0.0858337,
                                    0.0858337,
                                    0.0845526,
                                    0.0858337,
                                    0.0871148,
                                    0.0845526,
                                    0.0858337,
                                    0.0845526]
    
    
    var allTemperatureReadings: [Double] = [30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.19,
                                         30.19,
                                         30.19,
                                         30.19,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.23,
                                         30.23,
                                         30.23,
                                         30.23,
                                         30.23,
                                         30.23,
                                         30.23,
                                         30.23,
                                         30.23,
                                         30.23,
                                         30.23,
                                         30.23,
                                         30.25,
                                         30.25,
                                         30.25,
                                         30.25,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.25,
                                         30.25,
                                         30.25,
                                         30.25,
                                         30.25,
                                         30.25,
                                         30.25,
                                         30.25,
                                         30.25,
                                         30.25,
                                         30.25,
                                         30.25,
                                         30.25,
                                         30.25,
                                         30.25,
                                         30.25,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.21,
                                         30.25,
                                         30.25,
                                         30.25,
                                         30.25,
                                         30.27,
                                         30.27,
                                         30.27,
                                         30.27,
                                         30.27,
                                         30.27,
                                         30.27,
                                         30.27,
                                         30.27,
                                         30.27,
                                         30.27,
                                         30.27,
                                         30.25,
                                         30.25,
                                         30.25,
                                         30.25,
                                         30.29,
                                         30.29,
                                         30.29,
                                         30.29,
                                         30.27,
                                         30.27,
                                         30.27,
                                         30.27,
                                         30.27,
                                         30.27,
                                         30.27,
                                         30.27,
                                         30.27,
                                         30.27,
                                         30.27,
                                         30.27,
                                         30.27,
                                         30.27,
                                         30.27,
                                         30.27,
                                         30.29,
                                         30.29,
                                         30.29,
                                         30.29]
    var readingsIndex = 0
    
    
    // Enums
    enum Notes: Int {
        case C = 0, C_Sharp, D, D_Sharp, E, F, F_Sharp, G, G_Sharp, A, A_Sharp, B
    }
    
    enum Scales {
        case Major, Minor
    }
    
    
    //Outlets
    @IBOutlet weak var isChord: UISwitch!
    @IBOutlet weak var temperatureDisplay: UITextView!
    @IBOutlet weak var biomusicOption: UISwitch!
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
        
        // Initializations
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
        
        mandolinReverb.feedback = 0.9
        
        mandolin2.detune = 1
        mandolin2.bodySize = 1.95
        //mandolin2.presetElectricGuitarMandolin()
       
        let mandolin2Effect = AKLowPassFilter(mandolin2)
        
        //mandolin2Effect.cutoffFrequency = 3000
        let mandolin2Reverb = AKCostelloReverb(mandolin2Effect)
        
        mandolin2Reverb.feedback = 2
        //mandolin2Reverb.rampTime = 0.5
        
        // Prepare Output
        let mix = AKMixer(kick, snare, mandolinReverb, mandolin2Reverb, clarinet)
        let reverb = AKReverb(mix)
        
        AudioKit.output = reverb
        AudioKit.start()
        
        // Effects
        reverb.loadFactoryPreset(.mediumRoom)
        
        // Setup for derivative calculation
        for i in 0...4{
            var temp = [Double](repeating: 0.0, count: 3)
            temp[0] = 1
            temp[1] = time[i]
            temp[2] = time[i] * time[i]
            quadraticTime[i] = temp
        }
        
        for i in 0...4{
            var temp = [Double](repeating: 0.0, count: 2)
            temp[0] = 1
            temp[1] = time[i]
            linearTime[i] = temp
        }
        
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
        // Fetch new reading
        newTemperatureReading = allTemperatureReadings[readingsIndex]
        newGSRReading = allGSRReadings[readingsIndex]
        temperatureDisplay.text = "\(newGSRReading)"
        
        // Update readings matrix
        if (currentReadings < readingsNumber){
            temperatureReadings[currentReadings] = newTemperatureReading
            GSRReadings[currentReadings] = newGSRReading
            currentReadings += 1
        }
        else {
            // Shift readings matrix to the left and add new value to its end
            for i in (0...readingsNumber - 2){
                temperatureReadings[i] = temperatureReadings[i+1]
                GSRReadings[i] = GSRReadings[i+1]
            }
            temperatureReadings[readingsNumber - 1] = newTemperatureReading
            GSRReadings[readingsNumber - 1] = newGSRReading
            
            // Do the derivative calculation
            var ATA = calculateATA(A: quadraticTime, rowsA: 5, columnsA: 3)
            var ATb = calculateATb(A: quadraticTime, B: temperatureReadings, rowsA:5, columnsA:3)
            var soln = solveSquareMatrix(A: ATA, b: ATb, dimA: 3)
            let secondDerivativeTemp = 2 * soln[2]
            
            ATA = calculateATA(A: linearTime, rowsA: 5, columnsA: 2)
            ATb = calculateATb(A: linearTime, B: GSRReadings, rowsA:5, columnsA:2)
            soln = solveSquareMatrix(A: ATA, b: ATb, dimA: 2)
            let firstDerivativeGSR = soln[1]
            
            currentTemp = secondDerivativeTemp
            currentEDA = firstDerivativeGSR
            print(firstDerivativeGSR)
        }
        
        // Stop fetching readings at end of array
        if (readingsIndex < allGSRReadings.count - 1){
            readingsIndex += 1
        }
        
        
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
    
    func solveSquareMatrix( A: [[Double]], b:[Double], dimA: Int) -> [Double] {
        var x = [Double](repeating: 0.0, count: dimA)                  // Has the size of RowsA
        
        var newA = A
        var newb = b
        
        for k in 0...dimA-2{
            for i in k+1...dimA-1{
                newA[i][k] /= newA[k][k];
                for j in k+1...dimA-1{
                    newA[i][j] -= newA[i][k]*newA[k][j];
                }
            }
        }
        
        for i in 0...dimA-2{
            for j in i+1...dimA-1{
                newb[j] -= newA[j][i] * newb[i];
            }
        }
        
        for i in (0...dimA-1).reversed(){
            var xsolve: Double = newb[i];
            
            if (i+1 > dimA-1){
                // Do nothing
            }
            else {
                for j in i+1...dimA-1{
                    xsolve -= newA[i][j] * x[j];
                }
            }
            x[i]=xsolve/newA[i][i];
        }
        return x;
    }
    
    func calculateATA(A: [[Double]], rowsA: Int, columnsA: Int) -> [[Double]] {
        var ATA = [[Double]](repeating: Array(repeating: 0, count: columnsA), count: columnsA)
        
        for i in 0...columnsA-1{
            for j in 0...columnsA-1{
                for k in 0...rowsA-1{
                    ATA[j][i] += A[k][i] * A[k][j]
                }
            }
        }
        return ATA
    }
    
    func calculateATb(A: [[Double]], B: [Double], rowsA: Int, columnsA: Int) -> [Double] {
        var ATb = [Double](repeating: 0.0, count: columnsA) //N * 1
        
        for i in 0...columnsA-1{
            for j in 0...rowsA-1{
                ATb[i] += A[j][i] * B[j]
            }
        }
        return ATb
    }
}

