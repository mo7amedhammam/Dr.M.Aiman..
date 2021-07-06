//
//  RefernceTVCell.swift
//  Mideo
//
//  Created by Mohamed Salman on 6/6/20.
//  Copyright © 2020 IT PLUS. All rights reserved.
//

import UIKit
import ReadMoreTextView
class RefernceTVCell: UITableViewCell {
    
    @IBOutlet weak var TVLink: ReadMoreTextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
