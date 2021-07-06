//
//  VerificationCodeVC.swift
//  SAHL
//
//  Created by Mohamed Salman on 4/20/21.
//


import UIKit
import CountdownLabel
import Alamofire
import PKHUD

class VerificationCodeVC: UIViewController {
    @IBOutlet weak var LVerificationCode: UILabel!    // VerificationCode
    @IBOutlet weak var LCountDown: CountdownLabel!
    @IBOutlet weak var LEnterVerificationCode: UILabel!   // EnterVerificationCode
    @IBOutlet weak var LPhone: UILabel!
    @IBOutlet weak var LDataSqure: UILabel!               // YourDataIsSafe
    @IBOutlet weak var TFCodeIndex1: UITextField!
    @IBOutlet weak var TFCodeIndex2: UITextField!
    @IBOutlet weak var TFCodeIndex3: UITextField!
    @IBOutlet weak var TFCodeIndex4: UITextField!
    @IBOutlet weak var ViewCodeIndex1: UIView!
    @IBOutlet weak var ViewCodeIndex2: UIView!
    @IBOutlet weak var ViewCodeIndex3: UIView!
    @IBOutlet weak var ViewCodeIndex4: UIView!
    @IBOutlet weak var BUResendCode: UIButton!      // ResendCode
    @IBOutlet weak var BUConfirm: UIButton!         // Confirm
    @IBOutlet weak var ViewVerificationIndicator: UIView!
    @IBOutlet weak var VerificationIndicator: UIActivityIndicatorView!
    var PhoneNumber : String!
    let macAddress = UIDevice.current.identifierForVendor
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.LPhone.text = Shared.shared.MobileNumber
        
        self.TFCodeIndex1.delegate = self
        self.TFCodeIndex2.delegate = self
        self.TFCodeIndex3.delegate = self
        self.TFCodeIndex4.delegate = self
        
        TFCodeIndex1.becomeFirstResponder()

        TFCodeIndex1.addTarget(self, action: #selector(didChangeText1(field:)), for: .editingChanged)
        TFCodeIndex2.addTarget(self, action: #selector(didChangeText2(field:)), for: .editingChanged)
        TFCodeIndex3.addTarget(self, action: #selector(didChangeText3(field:)), for: .editingChanged)
        TFCodeIndex4.addTarget(self, action: #selector(didChangeText4(field:)), for: .editingChanged)
        
        // Text Field Action
        self.TFCodeIndex1.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.TFCodeIndex2.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.TFCodeIndex3.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.TFCodeIndex4.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        // end action text field
        
        
        // count Down
        self.BUResendCode.isHidden = true
        self.LCountDown.countdownDelegate = self
        self.LCountDown.setCountDownTime(minutes: 60)
        self.LCountDown.animationType = .none
        self.LCountDown.start()
        // end count down

        // Do any additional setup after loading the view.
        

    }
    
    @IBAction func BtnResend(_ sender: Any) {
        self.BUResendCode.isHidden = true
        self.LCountDown.countdownDelegate = self
        self.LCountDown.setCountDownTime(minutes: 60)
        self.LCountDown.animationType = .none
        self.LCountDown.start()
    }
    
    @IBAction func BtnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func BtnConfirm(_ sender: Any) {
        
        
        
        if Reachable.isConnectedToNetwork() {
            if TFCodeIndex1.text!.isEmpty || TFCodeIndex2.text!.isEmpty || TFCodeIndex3.text!.isEmpty || TFCodeIndex4.text!.isEmpty{
                self.showAlert(message: "لم يتم كتابه الكود بالكامل !!" , title: "انتبه")
            } else {
//                let verificationCode = TFCodeIndex1.text!+TFCodeIndex2.text!+TFCodeIndex3.text!+TFCodeIndex4.text!

        //        Helper.GoToAnyScreen(storyboard: "Main", identifier: "EnterPhoneVC")
//                login(Mobile: self.LPhone.text!, MacAdress: "\(macAddress!)", ConfirmationCode: verificationCode)
//                login(Mobile: self.LPhone.text!, MacAdress: "12345", ConfirmationCode: verificationCode)

            }
            
        } else {
            self.showAlert(message: "لا يوجد إتصال بالإنترنت !!", title: "انتبه")

        }

    }
    
    @objc func didChangeText1(field: UITextField) {
        if TFCodeIndex1.text?.containsNonEnglishNumbers != nil {
            TFCodeIndex1.text = TFCodeIndex1.text?.english
        }
    }
    @objc func didChangeText2(field: UITextField) {
        if TFCodeIndex2.text?.containsNonEnglishNumbers != nil {
            TFCodeIndex2.text = TFCodeIndex2.text?.english
        }
    }
    @objc func didChangeText3(field: UITextField) {
        if TFCodeIndex3.text?.containsNonEnglishNumbers != nil {
            TFCodeIndex3.text = TFCodeIndex3.text?.english
        }
    }
    @objc func didChangeText4(field: UITextField) {
        if TFCodeIndex4.text?.containsNonEnglishNumbers != nil {
            TFCodeIndex4.text = TFCodeIndex4.text?.english
        }
    }
    
    
//    //MARK: -----Verify your code then login
//    func login( Mobile : String, MacAdress : String ,ConfirmationCode : String )  {
//        
//        API.userLogin(Mobile: Mobile, MacAdress: MacAdress , ConfirmationCode: ConfirmationCode ){ (error : Error?, status : Int, message : String?) in
//            if error == nil && status == 0{
//                if status != 0 {
//                    HUD.flash(.label("Error"), delay: 2.0)
//                    //                            self.AllPostsTV.isHidden = true
//                }else{
//                    HUD.hide(animated: true)
//                    HUD.flash(.labeledSuccess(title: "user Loged in", subtitle: "") , delay: 2.0)
////                    self.phoneConfirmationVCObject.phoneNumberToConfirm = self.TFDateOfBirth.text!
//                    
////                    let vc = self.storyboard?.instantiateViewController(identifier: "VerificationCodeVC") as! VerificationCodeVC
////                    self.navigationController?.pushViewController(vc, animated: true)
//                    
//                }
//            } else  if  error == nil && status != 0 {
//                HUD.flash(.label(message), delay: 2.0)
//            }else {
//                HUD.flash(.label("Server Error"), delay: 2.0)
//            }
//        }
//        
//    }
    
}
