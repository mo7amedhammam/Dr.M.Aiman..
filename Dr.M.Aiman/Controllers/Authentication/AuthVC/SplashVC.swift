//
//  SplashVC.swift
//  SAHL
//
//  Created by Mohamed Salman on 4/20/21.
//

import UIKit
import AVFoundation
import AVKit

class SplashVC: UIViewController {
    
    var player: AVPlayer?
    var timer: Timer?
    var second = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadVideo()
        LiveAnimate()
        // Do any additional setup after loading the view.
    }
    private func loadVideo() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        } catch { }

        let path = Bundle.main.path(forResource: "logo", ofType:"mp4")

        player = AVPlayer(url: NSURL(fileURLWithPath: path!) as URL)
        let playerLayer = AVPlayerLayer(player: player)

        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.zPosition = -1

        self.view.layer.addSublayer(playerLayer)

        player!.seek(to: CMTime.zero)
        player!.play()
    }
    
    
    func LiveAnimate () {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            self.updateTimer()
        })
    }
    
    @objc func updateTimer() {

        if second == 4 {
            // go to login or home
            if Helper.getUserId() == true {
                Helper.GoToAnyScreen(storyboard: "Main", identifier: "JBTabBarController")

            } else {
                Helper.GoToAnyScreen(storyboard: "Main", identifier: "StartScreenVC")

            }
        }
        second += 1
    }
}
