//
//  ResetPasswordVC.swift
//  Dr.M.Aiman
//
//  Created by Muhamed Hammam on 21/06/2021.
//

import UIKit
import PKHUD

class ResetPasswordVC: UIViewController {
    @IBOutlet weak var TFEmail: UITextField!
    var currentDeviceMacAddress : String!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func BuRessetPassword(_ sender: Any) {
        if Reachable.isConnectedToNetwork() {
            if TFEmail.text!.isEmpty || Helper.isValidEmail(emailStr: TFEmail.text!) == false {
                self.showAlert(message: "Please Enter Your Email", title: "Error")
            }else{
//    Call API for resseting Password
                ChangePassword()
            }
        } else {
            // no internet
            self.showAlert(message: "No Internet Connection ", title: "Error")
        }
    }
    
    @IBAction func BuBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func ChangePassword() {
        if Reachable.isConnectedToNetwork(){
            HUD.show(.labeledProgress(title: "Sendibg Request", subtitle: ""))
            API.userChangePassword(Email: TFEmail.text!, MacAdress: currentDeviceMacAddress!) { (error : Error?, status : Int, message : String?) in
                if error == nil && status == 0{
                    //                    HUD.flash(.label("No Content To Show"), delay: 2.0)
                    HUD.hide(animated: true, completion: nil)
                    HUD.flash(.labeledSuccess(title: "", subtitle: "New Password Sent To your Email"))
                    self.dismiss(animated: true, completion: nil)
                } else if error == nil && status != 0 {
                    HUD.hide(animated: true, completion: nil)
                    HUD.flash(.label(message), delay: 2.0)
                }else{
                }
            }
        } else {
            HUD.flash(.labeledError(title: "No Internet Connection", subtitle: "") , delay: 2.0)
        }
    }


}
