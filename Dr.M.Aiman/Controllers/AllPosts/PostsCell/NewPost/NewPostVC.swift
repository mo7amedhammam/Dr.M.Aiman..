//
//  NewPostVC.swift
//  Dr.M.Aiman
//
//  Created by Muhamed Hammam on 02/06/2021.
//

import UIKit
import Alamofire

class NewPostVC: UIViewController {
    
    @IBOutlet weak var NewPostText: TextViewWithPlaceholder!
    @IBOutlet weak var NewPostImage: UIImageView!
    @IBOutlet weak var PostBtnOut: UIButton!
    
    @IBOutlet weak var HView: NSLayoutConstraint!
 
    
    
    //
    @IBOutlet weak var IVPerson: UIImageView!
    @IBOutlet weak var LaNamePerson: UILabel!
    @IBOutlet weak var LaTypePerson: UILabel!
    @IBOutlet weak var BtnClose: UIButton!
    @IBOutlet weak var BtnPhoto: UIButton!
    
    var indicator:ProgressIndicator?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // indicator hud ----------------//
        indicator = ProgressIndicator(inview:self.view,loadingViewColor: UIColor.lightGray, indicatorColor: #colorLiteral(red: 0.07058823529, green: 0.3568627451, blue: 0.6352941176, alpha: 1) , msg:  SalmanLocalize.textLocalize(key: "LPleaseWait") )
        indicator?.center = self.view.center
        self.view.addSubview(indicator!)
        //  end indicator hud ----------------//
        
        
        
        NewPostImage.isHidden = true
        BtnClose.isHidden     = true
        HView.constant = 40
        
        let url = URL(string: "\(URLs.ImageBaseURL + Helper.getImage())")
        IVPerson.kf.indicatorType = .activity
        IVPerson.kf.setImage(with: url)
        
        LaNamePerson.text = Helper.getFirstName()
        LaTypePerson.text = Helper.getRoleName()
        
    }
    
    @IBAction func BUPickImage(_ sender: Any) {
        showPhotoMenu()
    }
    
    @IBAction func BUCloseImage(_ sender: Any) {
        NewPostImage.isHidden = true
        BtnClose.isHidden     = true
        BtnPhoto.isHidden     = false
        HView.constant = 40
        NewPostImage.image = nil
    }
  
    // Pass Image To Your ImageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        NewPostImage.isHidden = false
        BtnClose.isHidden     = false
        HView.constant = 180
        NewPostImage.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func PostBtnPressed(_ sender: Any) {
        if NewPostImage.image == nil && (NewPostText.text == "" || NewPostText.text.isEmpty){
            self.showAlert(message: "Empty Post Not Allowed")
        } else {
        addPostWithImage()
    }
    }
    
    func addPostWithImage() {
        self.indicator?.start()

        if Reachable.isConnectedToNetwork() {
            
            if NewPostImage.image == nil {
                self.uploadPost(text: self.NewPostText.text!, imageurlString: "")
            } else {
                API.uploadImage(image: NewPostImage.image!) { (error : Error?, status : Int?, message : String? ,imageEndPoint : String?) in
                    if error == nil && status == 0{
                        if status != 0 {
                            self.showAlert(message: "Not Uploaded")
                            self.indicator?.stop()
                        }else{
                            self.uploadPost(text: self.NewPostText.text!, imageurlString: "\(imageEndPoint!)")
                            print("\(URLs.ImageBaseURL+imageEndPoint!)")
                        }
                        
                    } else  if  error == nil && status != 0 {
                        self.AlertShowMessage(controller: self, text: message!, status: 1)
                        self.indicator?.stop()
                        
                    } else {
                        self.AlertServerError(controller: self)
                        self.indicator?.stop()
                    }
                }
                
            }
     
        } else {
            self.AlertInternet(controller: self)
            self.indicator?.stop()
            
        }
                
    }
    
    func uploadPost(text : String , imageurlString : String)  {
        API.addPost(text: text , Image: imageurlString ) { (error : Error?, status : Int, message : String?) in
            if error == nil && status == 0{
                if status != 0 {
                    self.showAlert(message: "Not Uploaded")
                    self.indicator?.stop()
                } else {
                    self.indicator?.stop()
                    self.navigationController?.popViewController(animated: true)
                }
            } else  if  error == nil && status != 0 {
                self.indicator?.stop()
                self.AlertShowMessage(controller: self, text: message!, status: 1)
            } else {
                self.indicator?.stop()
                self.AlertServerError(controller: self)
            }
        }
    }
}
