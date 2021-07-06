//
//  ResultTVCell.swift
//  Mideo
//
//  Created by mac on 7/16/20.
//  Copyright © 2020 IT PLUS. All rights reserved.
//

import UIKit

class ResultTVCell: UITableViewCell {
    @IBOutlet weak var LQuestions: UILabel!
    @IBOutlet weak var LAnswer: UILabel!
    @IBOutlet weak var LReason: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
}
