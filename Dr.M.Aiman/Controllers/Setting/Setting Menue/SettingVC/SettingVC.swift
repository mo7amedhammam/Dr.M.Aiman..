//
//  SettingVC.swift
//  Dr.M.Aiman
//
//  Created by Muhamed Hammam on 24/05/2021.
//

import UIKit
import PKHUD

class SettingVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var SettingTVOutlet: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableviewSetup()
        settingLabelNames.remove(at: [1,3,4])
        logoImage.remove(at: [1,3,4])

        //        self.navigationItem.title = "Settings"
    }
    
    
    var settingLabelNames = ["Edit Profile","Chat","PDF Files","Contact Us","About Us","Share App","Rate App","Sign Out"]
    
    var logoImage: [UIImage] = [
        UIImage(systemName: "square.and.pencil")!,
        UIImage(systemName: "message")!,
        UIImage(systemName: "doc.fill")!,
        UIImage(systemName: "phone.fill")!,
        UIImage(systemName: "exclamationmark.circle.fill")!,
        UIImage(systemName: "arrowshape.turn.up.right.fill")!,
        UIImage(systemName: "star.fill")!,
        UIImage(systemName: "arrow.left.square.fill")!
    ]
    //    var vcontrollers:[Any] = [ProfileVC()EditProfileVC(),ChatVC(),ContactUsVC(),AboutUsVC(),ShareAppVC(),RateAppVC(),SignOutVC()]
    
    func tableviewSetup() {
        SettingTVOutlet.dataSource = self
        SettingTVOutlet.delegate = self
        //        SettingTVOutlet.registerCellNib(cellClass: SettingTVCell.self)
        
    }
    
    
    
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        return settingLabelNames.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderSettingTVCell") as! SettingTVCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTVCell") as! SettingTVCell
            cell.settingCellLable.text = settingLabelNames[indexPath.row-1]
            cell.SettingCellImage.image = logoImage[indexPath.row-1]
            return cell
        }
    }
    
    
    
    
    
    func logout(){
        let alert = UIAlertController(title: nil , message: nil , preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Sign out" , style: .default, handler: { (action) in
            // action Here
            //                    self.showAlert(message: "Edited" )
            HUD.flash(.labeledProgress(title: "Signing you out", subtitle: ""), delay: 2.0)
            Helper.logout()
            Helper.GoToAnyScreen(storyboard: "Main", identifier: "StartScreenVC")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            //          cancel Button with cancel style
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func move(id: String ){
        if id == "Share App" {
            print("share")
        } else if id == "Rate App" {
            print("rate")
        } else {
            print("push from here")
            let vc = (storyboard?.instantiateViewController(withIdentifier: id))!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
}

extension Array {
    mutating func remove(at indexes: [Int]) {
        var lastIndex: Int? = nil
        for index in indexes.sorted(by: >) {
            guard lastIndex != index else {
                continue
            }
            remove(at: index)
            lastIndex = index
        }
    }
}
