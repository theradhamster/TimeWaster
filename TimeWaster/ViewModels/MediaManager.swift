//
//  MediaManager.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/6/23.
//

import AVFoundation
import SwiftUI

class MediaManager: ObservableObject {
    enum SoundFile: String {
        case chipmunklaugh, balloonboy, fart, speen, uhohstinky, jesse, whatthedogdoin, buddyhollylick, californiakids, theworldhasturned, onlyindreams, fallingforyou, takecontrol, slave, perfectsituation, smile, gigachadmusic, fnafambience, bensounds, teachernoise, augh
    }
    enum VideoFile: String {
        case careatsshoe, riversstare, weezeraolsessions
    }
    var player: AVAudioPlayer?
    
    func playSound(for soundFile: SoundFile) {
        Task {
            guard let path = Bundle.main.path(forResource: soundFile.rawValue, ofType: "mp3") else {
                return }
            let url = URL(fileURLWithPath: path)
            
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, options: AVAudioSession.CategoryOptions.mixWithOthers)
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    func pauseSound() {
        player!.pause()
    }
    func resumeSound() {
        player!.play()
    }
}
