//
//  VideoTVCell.swift
//  Mideo
//
//  Created by Mohamed Salman on 4/17/20.
//  Copyright © 2020 IT PLUS. All rights reserved.
//

import UIKit

class VideoTVCell: UITableViewCell {
    
    @IBOutlet weak var IVVideo: UIImageView!
    @IBOutlet weak var LTittleVideo: UILabel!
//    @IBOutlet weak var IVLock: UIImageView!
    @IBOutlet weak var ViewQuize: UIView!
    @IBOutlet weak var ViewDiscussion: UIView!
    @IBOutlet weak var LDescription: UILabel!
    
    @IBOutlet weak var ViewParent: UIView!
    @IBOutlet weak var ViewLock: UIView!
    @IBOutlet weak var BUMore: UIButton!
    var videoID : Int!
    var delegate : VideoTVCellDelegate!
    var MoreDelegate : More!
    var des : String!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ViewParent.dropShadow()
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.QuizeAction))
        self.ViewQuize.addGestureRecognizer(gesture)
        
        // Initialization code
    }
    @IBAction func BtnMore(_ sender: Any) {
        self.MoreDelegate.ShowMore(text: des)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    
    @objc func QuizeAction(sender : UITapGestureRecognizer) {
        if Shared.shared.cheeckQuize {
            delegate.ShowQuize(VideoId: videoID)
        } else {
            
        }
        // Do what you want
    }
    
}


protocol VideoTVCellDelegate : NSObject {
    

    func ShowQuize (VideoId : Int)
    
}


protocol More : NSObject {
    func ShowMore (text : String)

}
