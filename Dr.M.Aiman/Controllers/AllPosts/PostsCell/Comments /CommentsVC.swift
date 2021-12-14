//
//  CommentsVC.swift
//  Dr.M.Aiman
//
//  Created by mac on 27/06/2021.
//

import UIKit
import ImageViewer_swift
import YouTubePlayer

class CommentsVC: UIViewController {
    
    
    @IBOutlet weak var ViewVedio: YouTubePlayerView!
    @IBOutlet weak var IVPost: UIImageView!
    @IBOutlet weak var TVComments: UITableView!
    
    
    @IBOutlet weak var HVEComment: NSLayoutConstraint!
    @IBOutlet weak var HSuperComment: NSLayoutConstraint!
    @IBOutlet weak var BtnCancelComment: UIButton!
    
    @IBOutlet weak var IVFooterSuper: UIImageView!
    
    var ArrSuper : PostModel!
    var ArrNew =  [PostModel]()
    var ArrComm = [CommentsModel]()
    
    var ImagePost = ""
    var VedioLive = "" 
    var HFooter = 75
    
    var click = 0
    
    var imagePicker = UIImagePickerController()
    var EditId   = 0
    
    var indicator : ProgressIndicator?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        // indicator hud ----------------//
        indicator = ProgressIndicator(inview:self.view,loadingViewColor: UIColor.lightGray, indicatorColor: #colorLiteral(red: 0.07058823529, green: 0.3568627451, blue: 0.6352941176, alpha: 1) , msg:  SalmanLocalize.textLocalize(key: "LPleaseWait") )
        indicator?.center = self.view.center
        self.view.addSubview(indicator!)
        //  end indicator hud ----------------//
        
                
        TVComments.dataSource = self
        TVComments.delegate   = self
        ViewEditComment.isHidden = true
        
        self.navigationController?.navigationBar.isHidden = true
        
        if Shared.shared.PostLive == 0 {
            Helper.SetImage(EndPoint: ImagePost , image: IVPost, name: "2", status: 1)
            reloadData ()
        } else {
            reloadData ()
            IVPost.isHidden = true
            let vidurl =  URL( string: ArrSuper.Title )
            ViewVedio.loadVideoURL(vidurl!)
            ViewVedio.clipsToBounds = true
        
        }
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(sender:)))
        TVComments.addGestureRecognizer(longPress)
    }
    
    
    @IBOutlet weak var ViewEditComment: UIView!
    @IBOutlet weak var IVEditComment: UIImageView!
    @IBOutlet weak var TVeditComment: TextViewWithPlaceholder!
    
    @IBAction func BUImageGallaryEditComment(_ sender: Any) {
        click = 1
        showPhotoMenu()
    }
    
    func EditAll (Arr : [CommentsModel] , HideView : UIView , TV : UITableView ,  Type : API.Editenum ,  Id: Int, text: String, Image: String ) {
        API.EditAll(Type: Type , Id: Id , text: text, Image: Image) { (error : Error?, status : Int?, message : String?) in
            if error == nil && status == 0 {
                
                for data in Arr {
                    if data.Id == Id {
                        print(data.Id)
                        data.text  = text
                        data.Image = Image
                        HideView.isHidden = true
                        self.indicator!.stop()
                        TV.reloadData()
                    }
                }
            } else if error == nil && status == -1 {
                self.AlertShowMessage(controller: self, text: message!, status: 1)
                self.indicator?.stop()

            } else {
                self.AlertServerError(controller: self)
                self.indicator?.stop()

            }
        }
    }
    
    
    
//    class func EditAll(Arr : [CommentsModel] , HideView : UIView , TV : UITableView ,  Type : API.Editenum ,  Id: Int, text: String, Image: String ){
//
//        API.EditAll(Type: Type , Id: Id , text: text, Image: Image) { (error : Error?, status : Int?, message : String?) in
//            if error == nil && status == 0 {
//
//                for data in Arr {
//                    if data.Id == Id {
//                        print(data.Id)
//                        data.text  = text
//                        data.Image = Image
//                        HideView.isHidden = true
//                        self.indicator!.stop()
//
//                        TV.reloadData()
//                    }
//                }
//
//            } else if error == nil && status == -1 {
//                self.AlertShowMessage(controller: self, text: message!, status: 1)
//                self.indicator?.stop()
//
//            } else {
//                self.AlertServerError(controller: self)
//                self.indicator?.stop()
//
//            }
//        }
//    }
    
    @IBAction func BUUpdateComment(_ sender: Any) {
        
        self.indicator?.start()
        
        if Reachable.isConnectedToNetwork(){
            if IVEditComment.image == nil {
                if Shared.shared.PostLive == 0 {
                    EditAll( Arr: ArrComm , HideView : ViewEditComment , TV : TVComments ,Type : .postComment , Id: EditId , text: TVeditComment.text! , Image: "" )
                } else {
                    EditAll( Arr: ArrComm , HideView : ViewEditComment , TV : TVComments ,Type : .LiveComment , Id: EditId , text: TVeditComment.text! , Image: "" )
                }
              
            } else {
                
                if Shared.shared.PostLive == 0 {
                    API.uploadImage(image: IVEditComment.image!) { [self] (error : Error?, status : Int?, message : String? ,imageEndPoint : String?) in
                        if error == nil && status == 0 {
                            EditAll(Arr: ArrComm , HideView : ViewEditComment ,  TV : TVComments ,Type : .postComment , Id: EditId , text: TVeditComment.text! , Image: "\(imageEndPoint!)" )
                        } else  if  error == nil && status == -1  {
                            self.AlertShowMessage(controller: self, text: message!, status: 1)
                            self.indicator?.stop()
                        } else {
                            self.AlertServerError(controller: self)
                            self.indicator?.stop()

                        }
                    }
                    
                } else {
                    API.uploadImage(image: IVEditComment.image!) { [self] (error : Error?, status : Int?, message : String? ,imageEndPoint : String?) in
                        if error == nil && status == 0 {
                            EditAll(Arr: ArrComm , HideView : ViewEditComment ,  TV : TVComments ,Type : .LiveComment , Id: EditId , text: TVeditComment.text! , Image: "\(imageEndPoint!)" )
                        } else  if  error == nil && status == -1  {
                            self.AlertShowMessage(controller: self, text: message!, status: 1)
                            self.indicator?.stop()
                        } else {
                            self.AlertServerError(controller: self)
                            self.indicator?.stop()

                        }
                    }
                    
                }
            
            }
                  
        } else {
            self.AlertInternet(controller: self)
            self.indicator?.stop()

        }
    
    }
    
    @IBAction func BUCancelComment(_ sender: Any) {
        ViewEditComment.isHidden = true
    }
    
    @IBAction func BUCancelImage(_ sender: Any) {
        BtnCancelComment.isHidden = true
        IVEditComment.isHidden = true
        HSuperComment.constant = 320
        HVEComment.constant = 50
        IVEditComment.image = nil
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage {
            
            if click == 0 {
                IVFooterSuper.image = image
            } else {
                BtnCancelComment.isHidden = false
                IVEditComment.isHidden = false
                HSuperComment.constant = 390
                HVEComment.constant = 120
                IVEditComment.image = image
            }
            
        }
        TVComments.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func longPress(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: TVComments)
            if let indexPath = TVComments.indexPathForRow(at: touchPoint) {
                // your code here, get the row for the indexPath or do whatever you want
                
                
                let optionMenu = UIAlertController(title: nil, message: "Delete Comment ", preferredStyle: .actionSheet)
                
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler:
                                                    { [self]
                                                        (alert: UIAlertAction!) -> Void in
                                                        
                                                        // action here
                                                        
                                                        if Shared.shared.PostLive == 0 {
                                                            self.DeleteComment (Type: "post", Id: ArrComm[indexPath.row].Id , IndexPath: indexPath)
                                                        } else {
                                                            self.DeleteComment (Type: "live", Id: ArrComm[indexPath.row].Id , IndexPath: indexPath)
                                                        }
                                                  
                                                    })
                
                let UpdateAction = UIAlertAction(title: "Update", style: .default, handler:
                                                    { [self]
                                                        (alert: UIAlertAction!) -> Void in
                                                        // action
                                                        TVeditComment.text = ArrComm[indexPath.row].text
                                                        
                                                        ViewEditComment.isHidden = false
                                                        EditId   = ArrComm[indexPath.row].Id
                                                        print("id comment : \(ArrComm[indexPath.row].Id)")

                                                        
                                                        if ArrComm[indexPath.row].Image == "" {
                                                            BtnCancelComment.isHidden = true
                                                            IVEditComment.isHidden = true
                                                            HSuperComment.constant = 320
                                                            HVEComment.constant = 50
                                                        } else {
                                                            BtnCancelComment.isHidden = false
                                                            IVEditComment.isHidden = false
                                                            HSuperComment.constant = 390
                                                            HVEComment.constant = 120
                                                            Helper.SetImage(EndPoint: ArrComm[indexPath.row].Image, image: IVEditComment, name: "2", status: 1)
                                                        }
                                                      
                                                   
                                                                                                       
                                                    })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
                                                    {
                                                        (alert: UIAlertAction!) -> Void in
                                                        // action
                                                        print("cancel")
                                                        
                                                    })
                
                if Helper.getId() == ArrComm[indexPath.row].UserId {
                    optionMenu.addAction(deleteAction)
                    optionMenu.addAction(UpdateAction)
                    optionMenu.addAction(cancelAction)
                } else {
                    showAlert(message: "You Have No permission On this Comment")
                }
                self.present(optionMenu, animated: true, completion: nil)
                
                //                        print("Long press Pressed:::: \(indexPath)")
            }
        }
        
        
    }
    func DeleteComment ( Type : String ,  Id  : Int , IndexPath : IndexPath){
        self.indicator?.start()
        if Reachable.isConnectedToNetwork(){
            API.deletePostComment(Type: Type , Id: Id) { (error : Error?, status : Int?, message : String?) in
                if status == 0 {
                    self.ArrComm.remove(at: IndexPath.item)
                    self.indicator?.stop()
                    self.TVComments.reloadData()
                } else if status == -1 {
                    self.indicator?.stop()
                    self.AlertShowMessage(controller: self, text: message!, status: 1)
                } else {
                    self.AlertServerError(controller: self)
                    self.indicator?.stop()
                }
            }
        } else {
            self.indicator?.stop()
            self.AlertInternet(controller: self)
        }
    }
    
    
    func reloadData (){
        for data in ArrSuper.Comments {
            self.ArrComm.append(data)
        }
        TVComments.reloadData()
    }
    
    func GetCommentOfPost(Type : String)  {
        self.indicator?.start()
        if Reachable.isConnectedToNetwork(){
            API.GetAllPosts(Type : Type , pageNum: 0) { [self] (error : Error?, info : [PostModel]?, message : String?) in
                if error == nil && info != nil{
                    if info!.isEmpty {
                        self.AlertShowMessage(controller: self, text: "No Content To Show", status: 1)
                        self.indicator?.stop()
                    } else {
                        for data in info! {
                            if ArrSuper.Id == data.Id {
                                self.ArrNew.append(data)
                                for data in ArrNew {
                                    ArrSuper = data
                                    ArrComm = data.Comments
                                }
                                TVComments.reloadData()
                                
                                let index = IndexPath(row: self.ArrComm.count-1, section: 0)
                                TVComments.scrollToRow(at: index , at: .bottom, animated: true)
                                self.indicator?.stop()
                            }
                        }
                        
                    }
                } else if  error == nil && info == nil{
                    self.AlertShowMessage(controller: self, text: message!, status: 1)
                    self.indicator?.stop()
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
    @IBAction func BUBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension CommentsVC : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrComm.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTVCell1", for: indexPath) as! CommentsTVCell
        cell.LaName.text    = ArrComm[indexPath.row].FirstName
        cell.LaComment.text = ArrComm[indexPath.row].text
        // ArrComm[indexPath.row].CreationTime
        cell.LaTimeAgo.text = ""
                Helper.SetImage(EndPoint: ArrComm[indexPath.row].UserImage, image: cell.IVPerson, name: "2", status: 1)
        if ArrComm[indexPath.row].Image.isEmpty == true  || ArrComm[indexPath.row].Image == "" {
            cell.HeightViewImage.constant = 0
        } else {
            cell.HeightViewImage.constant = 100
            Helper.SetImage(EndPoint: ArrComm[indexPath.row].Image, image: cell.IVSubComment, name: "2", status: 1)
            cell.IVSubComment.setupImageViewer()
        }
        
        
        if Helper.getRoleName() == "Student" {
            cell.ViewReplayAdmin.isHidden = true
        } else {
            cell.ViewReplayAdmin.isHidden = false
        }
        
        return cell
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTVCell2") as! CommentsTVCell
        
        cell.IVFooter.image = IVFooterSuper.image
                
        cell.PickImage = { [self] in
            
            HFooter = 175
            click = 0
//            let imagePickerVC = UIImagePickerController()
//            imagePickerVC.sourceType = .photoLibrary
//            imagePickerVC.delegate = self // new
//            present(imagePickerVC, animated: true)
            self.showPhotoMenu()
            //            TVComments.reloadData()
        }
        
        cell.sendMessage = { [self] in
            self.indicator?.start()

            if Reachable.isConnectedToNetwork() {
                if cell.IVFooter.image == nil {
                    if Shared.shared.PostLive == 0 {
                        AddCommentOnly(Type: "post", Id: ArrSuper.Id , text :  cell.TVAddComment.text , Img: "")
                    } else {
                        AddCommentOnly(Type: "live", Id: ArrSuper.Id , text :  cell.TVAddComment.text , Img: "")
                    }
                } else {
                        API.uploadImage(image: cell.IVFooter.image!) { (error : Error?, status : Int?, message : String? ,imageEndPoint : String?) in
                            if error == nil && status == 0 {
                                if Shared.shared.PostLive == 0 {
                                    AddCommentOnly(Type: "post", Id: ArrSuper.Id , text :  cell.TVAddComment.text , Img: "\(imageEndPoint!)")
                                } else {
                                    AddCommentOnly(Type: "live", Id: ArrSuper.Id , text :  cell.TVAddComment.text , Img: "\(imageEndPoint!)")
                                }
                            } else  if  error == nil && status != 0 {
                                self.AlertShowMessage(controller: self, text: message!, status: 1)
                                self.indicator?.stop()

                            }else {
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
        
        func AddCommentOnly ( Type : String ,  Id : Int , text : String ,  Img : String){
            API.addPostComment(Type : Type , Id: Id , text: text , Image: Img ) { [self] (error : Error?, status : Int, message : String?) in
                if status == 0 {
                    print("id : \(ArrSuper.Id)  text : \(cell.TVAddComment.text!)  img : \(Img)")
                    cell.TVAddComment.text = ""
                    ArrComm.removeAll()
                    ArrNew.removeAll()
                    HFooter = 75
                    if Shared.shared.PostLive == 0 {
                        GetCommentOfPost(Type: "post")
                    } else {
                        GetCommentOfPost(Type: "live")
                    }
                } else {
                    self.showAlert(message: message!)
                }
                
            }
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(HFooter)
    }
    
    //    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
    //        return UITableView.automaticDimension
    //    }
    
}
