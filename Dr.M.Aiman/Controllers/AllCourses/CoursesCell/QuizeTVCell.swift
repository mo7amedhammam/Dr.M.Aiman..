//
//  QuizeTVCell.swift
//  Mideo
//
//  Created by mac on 7/15/20.
//  Copyright © 2020 IT PLUS. All rights reserved.
//

import UIKit

class QuizeTVCell: UITableViewCell {

    @IBOutlet weak var ViewAnswer: UIView!
    @IBOutlet weak var LAnswer: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
