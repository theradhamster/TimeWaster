//
//  ViewModel.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/6/23.
//

import AVFoundation

class ViewModel: ObservableObject {
    @Published var current: String = ""
    var player: AVAudioPlayer?
    var soundFiles = [
        "chipmunklaugh",
        "balloonboy",
        "fart"
    ]
    
    func playSound() {
        Task {
            guard let path = Bundle.main.path(forResource: current, ofType: "mp3") else {
                return }
            let url = URL(fileURLWithPath: path)
            
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
