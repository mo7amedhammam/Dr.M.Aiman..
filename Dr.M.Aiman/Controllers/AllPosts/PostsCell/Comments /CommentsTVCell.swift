//
//  CommentsTVCell.swift
//  Dr.M.Aiman
//
//  Created by mac on 27/06/2021.
//

import UIKit

class CommentsTVCell: UITableViewCell {

    
    @IBOutlet weak var IVPerson: UIImageView!
    @IBOutlet weak var LaName: UILabel!
    @IBOutlet weak var LaComment: UILabel!
    
    @IBOutlet weak var ViewComment: UIView!
    
    @IBOutlet weak var BtnPickImage: UIButton!
    @IBOutlet weak var TVAddComment: TextViewWithPlaceholder!
    @IBOutlet weak var BtnSend: UIButton!
    
    @IBOutlet weak var IVSubComment: UIImageView!
    @IBOutlet weak var HeightViewImage: NSLayoutConstraint!
    
    @IBOutlet weak var LaTimeAgo: UILabel!
    @IBOutlet weak var ViewReplayAdmin: UIView!
    @IBOutlet weak var BtnReplayAdmin: UIButton!
    
    @IBOutlet weak var HeightFootter: NSLayoutConstraint!
    @IBOutlet weak var IVFooter: UIImageView!
    @IBOutlet weak var ViewFootter: UIView!
    
    
    var delegate : ActionCommentsDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
//        BtnPickImage.addTarget(self, action: #selector(BUPickImage), for: .touchUpInside)
//        BtnSend.addTarget(self, action: #selector(BUSend), for: .touchUpInside)
    }
    
    var PickImage : () -> () = {}
    var sendMessage : () -> () = {}

    

    @IBAction func BUPickImage(_ sender: Any) {
//        delegate.PickImage()
        PickImage()
    }

    @IBAction func BUSend(_ sender: Any) {
//        delegate.SendComment()
        sendMessage()
    }
    
    
    @IBAction func BUReplayAdmin(_ sender: Any) {
    }
    

}



protocol ActionCommentsDelegate : NSObject {
    func PickImage()
    func SendComment()
}
