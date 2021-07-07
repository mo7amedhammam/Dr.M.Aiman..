//
//  LiveTVCell.swift
//  Dr.M.Aiman
//
//  Created by Muhamed Hammam on 24/05/2021.
//

import UIKit
import YouTubePlayer

class LiveTVCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellMainLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var PostLa: UILabel!
    
    @IBOutlet weak var VideoViewOut: YouTubePlayerView!
    //    @IBOutlet weak var PostImage: UIImageView!
    @IBOutlet weak var LoveBuOutlet: UIButton!
    @IBOutlet weak var WatchinNumberLa: UILabel!
    
    @IBOutlet weak var BtnMore: UIButton!
    
    var deleteIndex : IndexPath!
    var indexx  = 0
    var status : Int!
    var postId : Int!
    var delegate : LiveActionDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //        StatusorImageV.addTapGesture(tapNumber: 1, target: self, action: #selector(move))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    @IBAction func BuMoreOptions(_ sender: Any) {
        delegate.MoreFun(index: indexx , PostLa: PostLa, deleteIndex: deleteIndex)
    }
    
    @IBAction func LoveBtn(_ sender: Any) {
        delegate.LoveFun(status: status, Bulove: LoveBuOutlet, LCount: WatchinNumberLa, postId: postId)
    }
    
    @IBAction func CommentBtn(_ sender: Any) {
        delegate.CommentFun(index: indexx)
        
    }
    
    
}

protocol LiveActionDelegate {
    func CommentFun (index : Int)
    func LoveFun    (status : Int , Bulove : UIButton , LCount : UILabel , postId : Int)
    func MoreFun    (index : Int , PostLa : UILabel , deleteIndex : IndexPath )
}

