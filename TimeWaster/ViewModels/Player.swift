//
//  Player.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/7/23.
//

import SwiftUI
import UIKit
import AVKit

struct PlayerView: UIViewRepresentable {
    var videoFile: MediaManager.VideoFile.RawValue
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
    }
    
    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(videoFile: MediaManager.VideoFile(rawValue: videoFile) ?? MediaManager.VideoFile.riversstare)
    }
}

class PlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    
    init(videoFile: MediaManager.VideoFile) {
        super.init(frame: .zero)
        
        if let fileURL = Bundle.main.url(forResource: videoFile.rawValue, withExtension: "mp4") {
            let player = AVPlayer(url: fileURL)
            player.actionAtItemEnd = .none
            player.play()
            playerLayer.player = player
            playerLayer.videoGravity = .resizeAspectFill
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
            layer.addSublayer(playerLayer)
        }
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: .zero, completionHandler: nil)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
