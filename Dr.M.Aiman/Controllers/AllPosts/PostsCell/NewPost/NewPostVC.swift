//
//  NewPostVC.swift
//  Dr.M.Aiman
//
//  Created by Muhamed Hammam on 02/06/2021.
//

import UIKit
import Alamofire
import PKHUD

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
            HUD.flash(.label("Empty Post Not Allowed"), delay: 2.0)
        }else{
        addPostWithImage()
    }
    }
    
    func addPostWithImage() {
        if Reachable.isConnectedToNetwork() {
            HUD.show(.progress)
            if NewPostImage.image == nil {
                self.uploadPost(text: self.NewPostText.text!, imageurlString: "")
            } else {
//                HUD.show(.labeledProgress(title: "Uploading", subtitle: ""))
                API.uploadImage(image: NewPostImage.image!) { (error : Error?, status : Int?, message : String? ,imageEndPoint : String?) in
                    if error == nil && status == 0{
                        if status != 0 {
                            HUD.flash(.label("not uploaded"), delay: 2.0)
                        }else{
                            self.uploadPost(text: self.NewPostText.text!, imageurlString: "\(imageEndPoint!)")
                            print("\(URLs.ImageBaseURL+imageEndPoint!)")
                        }
                        
                    } else  if  error == nil && status != 0 {
                        HUD.flash(.label(message), delay: 2.0)
                    }else {
                        HUD.flash(.label("Server Error"), delay: 2.0)
                    }
                }
                
            }
     
        } else {
            HUD.flash(.labeledError(title: "No Internet Connection", subtitle: "") , delay: 2.0)
        }
        
        
        
    }
    
    func uploadPost(text : String , imageurlString : String)  {
        API.addPost(text: text , Image: imageurlString ) { (error : Error?, status : Int, message : String?) in
            if error == nil && status == 0{
                if status != 0 {
                    HUD.flash(.label("not uploaded"), delay: 2.0)
                }else{
                    HUD.hide(animated: true)
                    HUD.flash(.labeledSuccess(title: "Uploaded", subtitle: "") , delay: 2.0)
                    self.navigationController?.popViewController(animated: true)
                }
            } else  if  error == nil && status != 0 {
                HUD.flash(.label(message), delay: 2.0)
            }else {
                HUD.flash(.label("Server Error"), delay: 2.0)
            }
        }
    }
}
