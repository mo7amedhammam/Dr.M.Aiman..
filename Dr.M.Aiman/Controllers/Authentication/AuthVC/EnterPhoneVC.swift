//
//  EnterPhoneVC.swift
//  SAHL
//
//  Created by Mohamed Salman on 4/20/21.
//


import UIKit
import Alamofire
import PKHUD
class EnterPhoneVC: UIViewController {
    
    @IBOutlet weak var LPhoneNumber: UILabel!  // EnterMobileNumber
    @IBOutlet weak var TFPhoneNumber: UITextField!
    @IBOutlet weak var BUConfirm: UIButton!    // Confirm
    @IBOutlet weak var TFPerfixCode: UITextField!
    @IBOutlet weak var IVCountry: UIImageView!
    @IBOutlet weak var LPrefixCode: UILabel!

    var countryPrefixCode = ["+966","+2"]
    var pickerViewCountryCode = UIPickerView()
    
    var phoneNumberToConfirm : String! 

    override func viewDidLoad() {
        super.viewDidLoad()
        TFPhoneNumber.becomeFirstResponder()
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func BtnConfirm(_ sender: Any) {
        
        if Reachable.isConnectedToNetwork() {
            if TFPhoneNumber.text!.isEmpty {
                self.showAlert(message: "من فضلك أدخل رقم التلفون !!", title: "انتبه")

            } else {
                
                // get verify code
//                Helper.GoToAnyScreen(storyboard: "Main", identifier: "VerificationCodeVC"
//                VerifyMobile(Mobile: TFPhoneNumber.text!)
//                let vc = self.storyboard?.instantiateViewController(identifier: "VerificationCodeVC") as! VerificationCodeVC
//                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        } else {
            self.showAlert(message: "لا يوجد إتصال بالإنترنت !!", title: "انتبه")

        }

    }
    @IBAction func BtnBack(_ sender: Any) {
//        Helper.GoToAnyScreen(storyboard: "Main", identifier: "ClientSignUPVC")

        self.navigationController?.popViewController(animated: true)
    }
    
    
//    //MARK: -----Verify your code
//    func VerifyMobile( Mobile : String)  {
//        
//        API.requestLoginConfirmationCode(Mobile: Mobile ){ (error : Error?, status : Int, message : String?) in
//            if error == nil && status == 0{
//                if status != 0 {
//                    HUD.flash(.label("code not sent"), delay: 2.0)
//                    //                            self.AllPostsTV.isHidden = true
//                }else{
//                    HUD.hide(animated: true)
//                    HUD.flash(.labeledSuccess(title: message, subtitle: "") , delay: 2.0)
////                    self.phoneConfirmationVCObject.phoneNumberToConfirm = self.TFDateOfBirth.text!
//                    let vc = self.storyboard?.instantiateViewController(identifier: "VerificationCodeVC") as! VerificationCodeVC
//                    self.navigationController?.pushViewController(vc, animated: true)
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

