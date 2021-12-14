//
//  ClientSignUPVC.swift
//  SAHL
//
//  Created by Mohamed Salman on 4/20/21.
//


import UIKit
import Alamofire

class ClientSignUPVC: UIViewController {
    
    //    @IBOutlet weak var LEndStep: UILabel!          // OneLastStep
    @IBOutlet weak var IVUser: UIImageView!
    @IBOutlet weak var IVAddUser: UIImageView!
    @IBOutlet weak var TFName: UITextField!        // Name
    @IBOutlet weak var TFEmail: UITextField!       // Email
    @IBOutlet weak var TFGender: UITextField!      // Gender
    @IBOutlet weak var TFPhoneNumber: UITextField! // BobileNumber
    @IBOutlet weak var TFPassword: UITextField! // BobileNumber
    @IBOutlet weak var TFConfirmPassword: UITextField! // BobileNumber
    @IBOutlet weak var BuPasswordEye: UIButton!           // Done
    @IBOutlet weak var BuConfirmPasswordEye: UIButton!           // Done
    
    @IBOutlet weak var BUDone: UIButton!           // Done
    
    var pickerViewGender = UIPickerView()
    var imagePicker = UIImagePickerController()
    let datePicker = UIDatePicker()
    
    var genderArr = ["Male","Female"]
    var currentDeviceMacAddress : String!
    var indicator:ProgressIndicator?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // indicator hud ----------------//
        indicator = ProgressIndicator(inview:self.view,loadingViewColor: UIColor.lightGray, indicatorColor: #colorLiteral(red: 0.07058823529, green: 0.3568627451, blue: 0.6352941176, alpha: 1) , msg:  SalmanLocalize.textLocalize(key: "LPleaseWait") )
        indicator?.center = self.view.center
        self.view.addSubview(indicator!)
        //  end indicator hud ----------------//
        
        
        self.imagePicker.delegate  = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PickImage))
        IVAddUser.isUserInteractionEnabled = true
        IVAddUser.addGestureRecognizer(tapGestureRecognizer)
        
        TFGender.inputView           = pickerViewGender
        pickerViewGender.dataSource = self
        pickerViewGender.delegate   = self
        
        //        setDatePicker()
        print(currentDeviceMacAddress!)
    }
    
    @objc func PickImage (){
        showPhotoMenu()
    }
    
    //    var agreeClicked = 0
    @IBOutlet weak var BtnAgreeTermsOutlet: UIButton!
    @IBAction func BUAgreeTerms(_ sender: Any) {
        BtnAgreeTermsOutlet.isSelected  = !BtnAgreeTermsOutlet.isSelected
        //        if agreeClicked == 0 {
        //            BtnAgreeTermsOutlet.isSelected = true
        //            agreeClicked = 1
        //        }else{
        //            BtnAgreeTermsOutlet.isSelected = false
        //            agreeClicked = 0
        //        }
        
    }
    @IBAction func BuShowandHidePassword(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            BuPasswordEye.isSelected = !BuPasswordEye.isSelected
            TFPassword.isSecureTextEntry = !TFPassword.isSecureTextEntry
        case 1:
            BuConfirmPasswordEye.isSelected = !BuConfirmPasswordEye.isSelected
            TFConfirmPassword.isSecureTextEntry = !TFConfirmPassword.isSecureTextEntry
        default:
            break
        }
    }
    
    @IBAction func BuGoToLogin(_ sender: Any) {
        //        print("go to login")
        //        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    // Pass Image To Your ImageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else { return }
        IVUser.image = image
    }
    
    //    @IBAction func BtnBack(_ sender: Any) {
    //        self.navigationController?.popViewController(animated: true)
    ////        Helper.GoToAnyScreen(storyboard: "Main", identifier: "StartScreenVC")
    //
    //    }
    
    @IBAction func confirmPasswordEditingDidChange(_ sender: Any) {
        print("textField: \(TFConfirmPassword.text!)")
        
        if isMatchingPassword(PasswordToMatch: TFConfirmPassword.text!) {
            // correct password
            print("Password Match")
            
            //            button.isEnabled = true
        } else {
            print("Password Match")
            
            //            button.isEnabled = false
        }
    }
    
    func isMatchingPassword(PasswordToMatch: String) -> Bool {
        var result = false
        // test password
        if TFPassword.text!.isEmpty == false && PasswordToMatch == TFPassword.text! {
            result = true
        }
        return result
    }
    
    
    var userGender : Int!
    @IBAction func BtnDone(_ sender: Any) {
        if TFGender.text! == "Male"{
            userGender = 1
        }else if TFGender.text! == "Female"{
            userGender = 0
        }
        
        if Reachable.isConnectedToNetwork() {
            if TFName.text!.isEmpty {
                self.showAlert(message: "Please enter your full name!! " , title: "Whatch out")
            } else if TFEmail.text!.isEmpty || Helper.isValidEmail(emailStr: TFEmail.text!) == false {
                self.showAlert(message: "Please enter your email!!", title: "Whatch out")
            } else if TFGender.text!.isEmpty {
                self.showAlert(message: "Please enter your type!!", title: "Whatch out")
            } else if TFPhoneNumber.text!.isEmpty {
                self.showAlert(message: "Please enter your phone number!!", title: "Whatch out")
            } else if TFPassword.text!.isEmpty{
                self.showAlert(message: "Please password Incorrect" , title: "Whatch out")
                
            }  else if TFConfirmPassword.text!.isEmpty{
                self.showAlert(message: "Re-enter the password correctly Incorrect !!" , title: "Whatch out")
                
            } else if TFPassword.text! != TFConfirmPassword.text!{
                self.showAlert(message: "The password does not match!" , title: "Whatch out")
                
            } else if BtnAgreeTermsOutlet.isSelected == false{
                self.showAlert(message: "Please agree to the application usage policy.", title: "Whatch out")
            }  else if IVUser.image == nil {
                self.showAlert(message: "Please Select Your Personal Image . ", title: "Whatch out")
            }  else {
                addUserImageThenREgister()
            }
        } else {
            // no internet
            self.showAlert(message: "No internet connection!!", title: "Whatch out")
        }
    }
    
    //MARK: -------  upload User Image  -------
    func addUserImageThenREgister() {
        self.indicator?.start()
        
        if Reachable.isConnectedToNetwork(){
            API.uploadUserImageMultipart(image: IVUser.image!) { (error : Error?, status : Int?, message : String? ,imageEndPoint : String?) in
                if error == nil && status == 0 {
                    if status != 0 {
                        self.indicator?.stop()
                        self.showAlert(message: "Not Created")
                    } else {
                        print("\(URLs.ImageBaseURL+imageEndPoint!)")
                        if self.IVUser.image != nil {
                            self.registerUser(imageurlString : "\(imageEndPoint!)")
                        } else {
                            print("******  nil image *****")
                            self.registerUser(imageurlString : "")
                        }
                    }
                } else  if  error == nil && status == -1 {
                    self.indicator?.stop()
                    self.AlertShowMessage(controller: self, text: message!, status: 1)
                }else {
                    self.indicator?.stop()
                    self.AlertServerError(controller: self)
                }
            }
        } else {
            self.indicator?.stop()
            self.AlertInternet(controller: self)
        }
    }
    
    //MARK: register new user
    func registerUser( imageurlString : String)  {
        API.userRegisteration(Email: TFEmail.text!, MacAdress: "\(currentDeviceMacAddress!)", FirstName: TFName.text!, Gender: userGender, PhoneNumber: TFPhoneNumber.text!, Image: imageurlString, Password: TFPassword.text!) { (error : Error?, status : Int, message : String?) in
            if error == nil && status == 0 {
                self.indicator?.stop()
                //                Helper.setUserImage(user_imagee: imageurlString)
                self.dismiss(animated: true, completion: nil)
            } else  if  error == nil && status == -1 {
                self.AlertShowMessage(controller: self, text: message!, status: 1)
                self.indicator?.stop()
                
            }else {
                self.AlertServerError(controller: self)
                self.indicator?.stop()
                
            }
        }
        
    }
    
}
