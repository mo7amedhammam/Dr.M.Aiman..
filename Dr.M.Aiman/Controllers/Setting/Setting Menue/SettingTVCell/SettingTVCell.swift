//
//  SettingTVCell.swift
//  Dr.M.Aiman
//
//  Created by Muhamed Hammam on 24/05/2021.
//

import UIKit

class SettingTVCell: UITableViewCell {

    @IBOutlet weak var editProfileMainView: UIView!
    @IBOutlet weak var HeadersettingCellLable: UILabel!
    @IBOutlet weak var HeaderSettingCellImage: UIImageView!

    @IBOutlet weak var settingCellLable: UILabel!
    @IBOutlet weak var SettingCellImage: UIImageView!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            contentView.backgroundColor = UIColor.clear
        }
        
    }
    
}
extension UIView {
    func addTapGesture(tapNumber: Int, target: Any, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
}
