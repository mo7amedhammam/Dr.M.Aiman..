//
//  coursesCell.swift
//  Dr.M.Aiman
//
//  Created by Muhamed Hammam on 16/06/2021.
//

import UIKit

class coursesCell: UICollectionViewCell {

    @IBOutlet weak var courseContainerView: UIView!
    @IBOutlet weak var BluryView: UIView!
    @IBOutlet weak var IVCourseOut: UIImageView!
    @IBOutlet weak var LAcourseNameOut: UILabel!
    @IBOutlet weak var LaPlaylistCount: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        Helper.addBlurEffect(targetView: BluryView , targetstyle: .regular , secondvc: nil)
    }
    
}
