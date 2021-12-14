//
//  ResetPasswordVC.swift
//  Dr.M.Aiman
//
//  Created by Muhamed Hammam on 21/06/2021.
//

import UIKit

class ResetPasswordVC: UIViewController {
    
    @IBOutlet weak var TFEmail: UITextField!
    var currentDeviceMacAddress : String!
    var indicator:ProgressIndicator?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // indicator hud ----------------//
        indicator = ProgressIndicator(inview:self.view,loadingViewColor: UIColor.lightGray, indicatorColor: #colorLiteral(red: 0.07058823529, green: 0.3568627451, blue: 0.6352941176, alpha: 1) , msg:  SalmanLocalize.textLocalize(key: "LPleaseWait") )
        indicator?.center = self.view.center
        self.view.addSubview(indicator!)
        //  end indicator hud ----------------//
        
    }
    
    @IBAction func BuRessetPassword(_ sender: Any) {
        if Reachable.isConnectedToNetwork() {
            if TFEmail.text!.isEmpty || Helper.isValidEmail(emailStr: TFEmail.text!) == false {
                self.showAlert(message: "Please Enter Your Email", title: "Error")
            } else {
                ChangePassword()
            }
        } else {
            self.AlertInternet(controller: self)
        }
    }
    
    @IBAction func BuBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func ChangePassword() {
        self.indicator?.start()
        if Reachable.isConnectedToNetwork(){
            API.userChangePassword(Email: TFEmail.text!, MacAdress: currentDeviceMacAddress!) { (error : Error?, status : Int, message : String?) in
                if error == nil && status == 0{
                    self.indicator?.stop()
                    self.dismiss(animated: true, completion: nil)
                } else if error == nil && status != 0 {
                    self.indicator?.stop()
                    self.AlertShowMessage(controller: self, text: message!, status: 1)
                } else {
                    self.AlertServerError(controller: self)
                    self.indicator?.stop()
                }
            }
        } else {
            self.AlertInternet(controller: self)
            self.indicator?.stop()

        }
    }
}
