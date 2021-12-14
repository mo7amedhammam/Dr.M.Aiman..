//
//  EditProfileVC.swift
//  Dr.M.Aiman
//
//  Created by Muhamed Hammam on 31/05/2021.
//

import UIKit
import ImageViewer_swift

class EditProfileVC: UIViewController {
    
    
    @IBOutlet weak var LAname: UILabel!
    @IBOutlet weak var TFemail: UITextField!
    @IBOutlet weak var TFphone: UITextField!
    @IBOutlet weak var TFuniversity: UITextField!
    @IBOutlet weak var TFrole: UITextField!
    @IBOutlet weak var TFpasword: UITextField!
    
    //
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var popupfrontview: UIView!
    
    @IBOutlet var popupViewOut: UIView!
    @IBOutlet weak var popUpLabel: UILabel!
    @IBOutlet weak var popUpTextFeild: UITextField!
    
    var tag : Int!
    
    var indicator:ProgressIndicator?
    @IBOutlet weak var ViewSuper: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        // indicator hud ----------------//
        indicator = ProgressIndicator(inview:self.view,loadingViewColor: UIColor.lightGray, indicatorColor: #colorLiteral(red: 0.07058823529, green: 0.3568627451, blue: 0.6352941176, alpha: 1) , msg:  SalmanLocalize.textLocalize(key: "LPleaseWait") )
        indicator?.center = self.view.center
        self.view.addSubview(indicator!)
        //  end indicator hud ----------------//
        
        
//        Helper.addBlurEffect(targetView: popupbackview , targetstyle: .prominent, secondvc: popupfrontview)
        // Do any additional setup after loading the view.
        ViewSuper.isHidden = true
        getdata()
    }
    
    func getdata(){
        LAname.text       = Helper.getFirstName()
        TFemail.text      = Helper.getEmail()
        TFphone.text      = Helper.getPhoneNumber()
        Helper.SetImage(EndPoint: Helper.getImage(), image: profileImage, name: "person.fill", status: 0)
        Helper.SetImage(EndPoint: Helper.getCover(), image: coverImage, name: "person.fill", status: 0)
        profileImage.setupImageViewer()
        coverImage.setupImageViewer()
    }
 
    var imageindex = 0
    @IBAction func coveImageBtnPressed(_ sender: Any) {
        showPhotoMenu()
        imageindex = 1
//        coverImage.image = image
    }
    
    @IBAction func profileImageBtnPressed(_ sender: Any) {
        showPhotoMenu()
        imageindex = 2
        
    }
    
    // Pass Image To Your ImageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else { return }
        if imageindex == 1 {
            coverImage.image = image
            updateUserImage(type: .coverImage)
        } else  if imageindex == 2{
            profileImage.image = image
            updateUserImage(type: .profileImage)
        }else {
            
        }
        
    }
    
    
    @IBAction func editBtnPressed(_ sender: UIButton) {
        
        ViewSuper.isHidden = false
        self.showPopUp(pop: popupViewOut)
        switch sender.tag {
        case 0:
            tag = 0
            popUpLabel.text            = "Edit Name"
//            popUpTextFeild.placeholder = "Enter New Name"
            popUpTextFeild.text        = Helper.getFirstName()
            break
        case 1:
            tag = 1
            popUpLabel.text            = "Edit Email"
//            popUpTextFeild.placeholder = "Enter New Email"
            popUpTextFeild.text!        = Helper.getEmail()
            break
        case 2:
            tag = 2
            popUpLabel.text            = "Edit Mobile Number"
//            popUpTextFeild.placeholder = "Enter New Number"
            popUpTextFeild.text!        = Helper.getPhoneNumber()
            break
            
        case 3:
            tag = 3
            popUpLabel.text            = "Edit University"
            popUpTextFeild.placeholder = "Enter New University "
            break
            
        case 4:
            tag = 4
            popUpLabel.text            = "Edit Role"
            popUpTextFeild.placeholder = "Student"
            break
            
        case 5:
            tag = 5
            popUpLabel.text            = "Edit Password"
            popUpTextFeild.placeholder = "Enter New Password"
            break
        default:
            tag = 6
            popUpLabel.text            = ""
            popUpTextFeild.placeholder = ""
        }
        
        
    }
    
    func UpdateProfile (Email : String , PhoneNumber : String , FirstName : String ){
        
        if Reachable.isConnectedToNetwork() {
            self.indicator?.start()
            API.EditProfile(Email: Email, PhoneNumber: PhoneNumber, FirstName: FirstName) { [self] (error : Error?, status : Int?, message : String?) in
                if status == 0 && error == nil {
                    getdata()
                    self.indicator?.stop()
                    ViewSuper.isHidden = true
                    self.hidePopUp(pop: popupViewOut)
                } else if status == -1 && error == nil {
                    self.indicator?.stop()
                    self.AlertShowMessage(controller: self, text: message!, status: 1)
                    
                } else {
                    self.indicator?.stop()
                    self.AlertServerError(controller: self)
                }
            }
        } else {
            self.AlertInternet(controller: self)
        }
    }

    
    @IBAction func saveBtnPressed(_ sender: Any) {
        let newtext = popUpTextFeild.text!
        self.setNewValue(receiverTag: tag , value: newtext)
    }
    
    func setNewValue(receiverTag : Int , value : String ){
        //        print(value)
        switch receiverTag {
        case 0:
            // name
            UpdateProfile(Email: Helper.getEmail(), PhoneNumber: Helper.getPhoneNumber(), FirstName: value)
            break
        case 1:
            // email
            if Helper.isValidEmail(emailStr: popUpTextFeild.text!) == false {
                self.showAlert(message: "Please Enter Valid Email")
            } else {
                UpdateProfile(Email: value, PhoneNumber: Helper.getPhoneNumber(), FirstName: Helper.getFirstName())
            }
            
            break
        case 2:
            // mobile
            UpdateProfile(Email: Helper.getEmail(), PhoneNumber: value, FirstName: Helper.getFirstName())
            break
        case 3:
            TFuniversity.text = value
            break
        case 4:
            TFrole.text = value
            break
        case 5:
            TFpasword.text = value
            break
        default:
            print("default")
        }
        //        print(x)
    }
    
    
    //MARK: -------  upload User Image  -------
    func updateUserImage(type: API.newimageEnum) {
        let image : UIImage
        switch type {
        case.profileImage:
            image = profileImage.image!
        case.coverImage:
            image = coverImage.image!
        }
        
        if Reachable.isConnectedToNetwork(){
            self.indicator?.start()
            API.uploadUserImageMultipart(image: image) { (error : Error?, status : Int?, message : String? ,imageEndPoint : String?) in
                if error == nil && status == 0 {
                    if status != 0 {
                        self.indicator?.stop()
                        self.showAlert(message: "Not updated")
                    }else{
                        print("\(URLs.ImageBaseURL+imageEndPoint!)")
                        
                        self.saveNewImage(type: type, image: "\(imageEndPoint!)")
                        self.indicator?.stop()
                        
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
            self.AlertInternet(controller: self)
        }
    }
    
    //MARK: ---- save new image
    
    func saveNewImage(type: API.newimageEnum, image : String){
        if Reachable.isConnectedToNetwork(){
            API.updateImage(type: type, Image: image) { (error : Error?, status : Int, message : String?) in
                if error == nil && status == 0 {
                    if status != 0 {
                        self.indicator?.stop()
                        self.showAlert(message: "Not updated")
                    }else{
                        self.showAlert(message: "Image Updated")
                        self.indicator?.stop()
                        
                    }
                } else  if  error == nil && status == -1 {
                    self.indicator?.stop()
                    self.AlertShowMessage(controller: self, text: message!, status: 1)
                    
                } else {
                    self.indicator?.stop()
                    self.AlertServerError(controller: self)
                }
            }
        }else{
            self.AlertInternet(controller: self)
        }
    }
    
    
    func showPopUp(pop:UIView) {
        self.view.addSubview(pop)
        pop.center    = self.view.center
        pop.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        pop.alpha     = 0
        UIView.animate(withDuration: 0.4) {
            pop.alpha     = 1
            pop.transform = CGAffineTransform.identity
        }
    }
    @IBAction func cancelPopUp(_ sender: Any) {
        ViewSuper.isHidden = true
        self.hidePopUp(pop: popupViewOut)
    }
    
    func hidePopUp (pop : UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            pop.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            pop.alpha     = 0
        }) { (success:Bool) in
            pop.removeFromSuperview()
        }
    }
    
    

    
}



// Image from Library or By Camera
extension UIViewController:
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {
    
    // MARK:- Image Helper Methods
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK:- Image Helper Methods
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    // shoose library or camera
    func showPhotoMenu() {
        let alert = UIAlertController(title: nil, message: nil,
                                      preferredStyle: .actionSheet)
        
        let actCancel = UIAlertAction(title: "Cancel", style: .cancel,
                                      handler: nil)
        alert.addAction(actCancel)
        
        let actPhoto = UIAlertAction(title: "Take Photo",
                                     style: .default, handler: { (action) in
                                        self.takePhotoWithCamera()
                                        
                                     })
        alert.addAction(actPhoto)
        
        let actLibrary = UIAlertAction(title: "Choose From Library",
                                       style: .default, handler: { (action) in
                                        self.choosePhotoFromLibrary()
                                       })
        alert.addAction(actLibrary)
        
        present(alert, animated: true, completion: nil)
    }
}

