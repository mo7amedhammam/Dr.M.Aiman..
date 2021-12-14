//
//  UniversityCell.swift
//  Dr.M.Aiman
//
//  Created by Muhamed Hammam on 16/06/2021.
//

import UIKit

class UniversityCell: UITableViewCell {
    
    @IBOutlet weak var coursecCollection: UICollectionView!
    
    @IBOutlet weak var containerViewout: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        Helper.addBlurEffect(targetView: containerViewout)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        coursecCollection.delegate = dataSourceDelegate
        coursecCollection.dataSource = dataSourceDelegate
        coursecCollection.tag = row
        coursecCollection.reloadData()
    }
}
