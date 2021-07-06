//
//  PostBodyXibCell.swift
//  Dr.M.Aiman
//
//  Created by Muhamed Hammam on 30/05/2021.
//

import UIKit

class PostBodyXibCell: UITableViewCell {
    
    @IBOutlet weak var cellMainVC: UIView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerLa: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var statusLa: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var photoLa: UILabel!
    @IBOutlet weak var ViewImageFounded: UIView!
    

    @IBOutlet weak var PostLa: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellMainLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var PostImage: UIImageView!
    @IBOutlet weak var LoveBuOutlet: UIButton!
    @IBOutlet weak var BtnComm: UIButton!
    @IBOutlet weak var LoveNumLaOutlet: UILabel!
    @IBOutlet weak var BtnMore: UIButton!
    @IBOutlet weak var BtnNewpost: UIButton!
    
    var delegate  : PostActionDelgate!
    var delegate2 : PostActionNewPostDelgate!
    var indexx  = 0
    var deleteIndex : IndexPath!
    
    var status : Int!
    var postId : Int!
    override func awakeFromNib() {
        super.awakeFromNib()
//        BtnNewpost.addTarget(self, action: #selector(presentCreatNewPost), for: .touchUpInside)
//        BtnComm.addTarget(self, action: #selector(CommentBtn), for: .touchUpInside)
//        LoveBuOutlet.addTarget(self, action: #selector(LoveBtn), for: .touchUpInside)
//        BtnMore.addTarget(self, action: #selector(BuMoreOptions), for: .touchUpInside)
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

//
//    var didNewPost : () -> () = {}
//    var openImage : () -> () = {}
//
    @IBAction func presentCreatNewPost(_ sender: Any) {
        delegate2.NewPostFun()
    }
        
    @IBAction func BuMoreOptions(_ sender: Any) {
        delegate.MoreFun(index: indexx, PostLa: PostLa , deleteIndex: deleteIndex )
    }
    @IBAction func LoveBtn(_ sender: Any) {
        delegate.LoveFun(status: status, Bulove: LoveBuOutlet, LCount: LoveNumLaOutlet, postId: postId )
    }
    @IBAction func CommentBtn(_ sender: Any) {
        delegate.CommentFun(index: indexx )
    }

    
    
    //4
    @IBOutlet weak var FrontView: UIView!
    
    @IBAction func flipAction(_ sender: Any) {
        //        self.flipAnimation()
        
    }
    
    //    var isFlipped = false
    //    func flipAnimation()
    //    {
    //        if (!isFlipped){
    //            UIView.transition(with: FrontView, duration: 1, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    //            PostImage.image = UIImage(named: "EgypteLogo")
    //            isFlipped = true
    //        }else{
    //            UIView.transition(with: FrontView, duration: 1, options: .transitionFlipFromRight, animations: nil, completion: nil)
    //            PostImage.image = UIImage(named: "EgypteLogo")
    //            isFlipped = false
    //        }
    //    }
    
}

protocol PostActionDelgate {
    func CommentFun (index : Int)
    func LoveFun    (status : Int , Bulove : UIButton , LCount : UILabel , postId : Int)
    func MoreFun    (index : Int , PostLa : UILabel , deleteIndex : IndexPath )
}


protocol PostActionNewPostDelgate {
    func NewPostFun ()
}
