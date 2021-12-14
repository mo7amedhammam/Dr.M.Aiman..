//
//  RefernceVC.swift
//  Mideo
//
//  Created by Mohamed Salman on 6/6/20.
//  Copyright © 2020 IT PLUS. All rights reserved.
//

import UIKit

class RefernceVC: UIViewController {

    @IBOutlet weak var TableViewRefernceLinks: UITableView!
    var links = [String]()
    var selectedCourseVideosNumber : Int!
    override func viewDidLoad() {
        super.viewDidLoad()

        TableViewRefernceLinks.delegate = self
        TableViewRefernceLinks.dataSource = self
        // Do any additional setup after loading the view.
    }
    
}

extension RefernceVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return Shared.shared.Links.count
        return selectedCourseVideosNumber
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RefernceTVCell", for: indexPath) as! RefernceTVCell
        //        cell.TVLink.text = Shared.shared.Links[indexPath.row]

        cell.TVLink.text = "https://www.youtube.com/watch?v=Lex4NKotiw4"
        return cell
    }
}
