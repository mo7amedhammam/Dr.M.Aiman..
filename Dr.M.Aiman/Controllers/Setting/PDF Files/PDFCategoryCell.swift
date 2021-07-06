//
//  PDFCategoryCell.swift
//  Dr.M.Aiman
//
//  Created by mac on 01/07/2021.
//

import UIKit

class PDFCategoryCell: UITableViewCell {

    @IBOutlet weak var LaCategoryName: UILabel!
    @IBOutlet weak var BuMore: UIButton!
    
    @IBOutlet weak var ViewShadow: UIView!
    var delegate : moreActiondelegate!
    var index = 0
    var indexPath : IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func BtnMore(_ sender: Any) {
        delegate!.moreOptions(index: index)
    }
    
}
protocol  moreActiondelegate {
    func moreOptions( index : Int)
}
