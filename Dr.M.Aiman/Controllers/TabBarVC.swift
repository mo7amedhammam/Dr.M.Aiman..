//
//  TabBarVC.swift
//  Dr.M.Aiman
//
//  Created by Muhamed Hammam on 18/06/2021.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let vc = storyboard?.instantiateViewController(identifier: "ClientSignUPVC") as! ClientSignUPVC
        self.present(vc, animated: true, completion: nil)
        Helper.GoToAnyScreen(storyboard: "Main", identifier: "ClientSignUPVC")
    }
    


}
