//
//  StartScreenVC.swift
//  SAHL
//
//  Created by Mohamed Salman on 4/20/21.
//

import UIKit
import PKHUD

class StartScreenVC: UIViewController {
    
    @IBOutlet weak var LSignIn: UILabel!  // SignIn
    @IBOutlet weak var VIewPhone: UIView!
    //    @IBOutlet weak var LSkip: UILabel!    // Skip
    //    @IBOutlet weak var LTerm: UILabel!    // Term
    @IBOutlet weak var TfEmail: UITextField!
    @IBOutlet weak var TfPassword: UITextField!
    @IBOutlet weak var BuShoworHidePasswordOut: UIButton!
    
    let currentDeviceMacAddress = UIDevice.current.identifierForVendor?.uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkActionPhone))
        //        self.VIewPhone.addGestureRecognizer(gesture)
        // Do any additional setup after loading the view.
    }
    @objc func checkActionPhone(sender : UITapGestureRecognizer) {
        // Do what you want
        Helper.GoToAnyScreen(storyboard: "Main", identifier: "EnterPhoneVC")
    }
    
    @IBAction func BtnShowandHidePassword(_ sender: Any) {
        BuShoworHidePasswordOut.isSelected = !BuShoworHidePasswordOut.isSelected
        TfPassword.isSecureTextEntry = !TfPassword.isSecureTextEntry
    }
    
    @IBAction func BULogin(_ sender: Any) {
        if Reachable.isConnectedToNetwork() {
            if TfEmail.text!.isEmpty  {
                self.showAlert(message: "Please Enter Your Email", title: "Whatch out")
            } else if TfPassword.text!.isEmpty {
                self.showAlert(message: "Please Enter Your Password", title: "Whatch out")
            } else{
                
                UserLogin(Email: TfEmail.text!, MacAdress: currentDeviceMacAddress! , Password: TfPassword.text! )

//                if Helper.isValidEmail(emailStr: TfEmail.text!) == false {
//                    // phone
//                    UserLogin(Email: TfEmail.text! , MacAdress: currentDeviceMacAddress! , Password: TfPassword.text!)
//                } else {
//                    // email
//                    UserLogin(Email: TfEmail.text!, MacAdress: currentDeviceMacAddress! , Password: TfPassword.text! )
//                }
                
            }
        } else {
            // no internet
            self.showAlert(message: "No Internet Connection ", title: "Error")
        }
    }
    @IBAction func BUSignUp(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ClientSignUPVC") as! ClientSignUPVC
        vc.currentDeviceMacAddress = self.currentDeviceMacAddress!
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func BUForgetPassword(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
        vc.currentDeviceMacAddress = self.currentDeviceMacAddress!
        present(vc, animated: true, completion: nil)
    }
    //    let mac : String!
    func UserLogin(Email: String , MacAdress: String , Password: String)  {
        if Reachable.isConnectedToNetwork(){
            HUD.show(.progress)
            API.userLogin(Email: Email, MacAdress: MacAdress , Password: Password) { (error : Error?, status : Int, message : String?, token : String?)  in
                if error == nil && status == 0 {
                    HUD.hide(animated: true, completion: nil)
                    //                    accessToken = token
                    Helper.setPasswordSave(password: self.TfPassword.text!)
                    self.UserInfo()
                } else if error == nil && status == -1 {
                    HUD.hide(animated: true, completion: nil)
                    HUD.flash(.label(message), delay: 2.0)
                }else{
                }
            }
        } else {
            HUD.flash(.labeledError(title: "No Internet Connection", subtitle: "") , delay: 2.0)
        }
    }
    
    func UserInfo()  {
        if Reachable.isConnectedToNetwork(){
            HUD.show(.progress)
            API.GetUserInfo(completion: { (error : Error?, status : Int, message : String?) in
                if error == nil && status == 0 {
                    // get user data
                    // HUD.flash(.label("No Content To Show"), delay: 2.0)
                    HUD.hide(animated: true, completion: nil)
                    //                    accessToken = token
                    self.goToMain()
                } else if error == nil && status != 0 {
                    HUD.hide(animated: true, completion: nil)
                    HUD.flash(.label(message), delay: 2.0)
                }else{
                }
            }
            )} else {
                HUD.flash(.labeledError(title: "No Internet Connection", subtitle: "") , delay: 2.0)
            }
    }
    
    
    
    
    func goToMain(){
        
        
        Helper.GoToAnyScreen(storyboard: "Main", identifier: "JBTabBarController")
        
        //        let vc = storyboard?.instantiateViewController(identifier: "JBTabBarController") as Any
        //        self.navigationController?.pushViewController(vc as! UIViewController, animated: true)
    }
}
