//
//  YoutubeVC.swift
//  Zag
//
//  Created by Mohamed Salman on 3/10/21.
//  Copyright © 2021 Mohamed Salman. All rights reserved.
//

import UIKit
import YouTubePlayer

class YoutubeVC: UIViewController , YouTubePlayerDelegate {
    
    
    var viewPlay : UIView!
    @IBOutlet weak var videoPlayer: YouTubePlayerView!
    var Url : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        videoPlayer.delegate = self
        videoPlayer.isUserInteractionEnabled = false
        
        let myVideoURL = URL(string: Url)
        videoPlayer.loadVideoURL(myVideoURL! as URL)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func BtnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func BtnPlay(_ sender: Any) {
        
        if videoPlayer.ready {
            if videoPlayer.playerState != YouTubePlayerState.Playing {
                videoPlayer.play()
            } else {
                videoPlayer.pause()
            }
        }
        
    }
    func playerQualityChanged(_ videoPlayer: YouTubePlayerView, playbackQuality: YouTubePlaybackQuality) {
    }
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        
    }
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
    }
}
