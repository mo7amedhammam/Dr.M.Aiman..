//
//  SubCategoryPdfTVCell.swift
//  Dr.M.Aiman
//
//  Created by mac on 01/07/2021.
//

import UIKit

class SubCategoryPdfTVCell: UITableViewCell {

    
    
    @IBOutlet weak var IVPdf: UIImageView!
    @IBOutlet weak var LaName: UILabel!
    @IBOutlet weak var BtnMore: UIButton!
    var index = 0
    var delegate : MoreActionSubCategory!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
        
    @IBAction func BUMore(_ sender: Any) {
        delegate.More(index: index)
    }

}

protocol MoreActionSubCategory {
    func More(index : Int)
}
