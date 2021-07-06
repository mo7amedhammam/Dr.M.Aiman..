//
//  FavouritePosts.swift
//  Dr.M.Aiman
//
//  Created by Muhamed Hammam on 29/06/2021.
//

import UIKit
import Alamofire
import PKHUD
import ImageViewer_swift

class FavouritePosts: UIViewController {
    
    let refreshControl = UIRefreshControl()
    
    var postArray = [PostModel]()
    
    @IBOutlet weak var ViewEditComment: UIView!
    @IBOutlet weak var IVEditComment: UIImageView!
    @IBOutlet weak var TVeditComment: UITextView!
    var EditId = 0
    
    @IBOutlet weak var HVEComment: NSLayoutConstraint!
    @IBOutlet weak var HSuperComment: NSLayoutConstraint!

    @IBOutlet weak var BtnCancelComment: UIButton!

    @IBOutlet weak var AllPostsTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        AllPostsTV.dataSource = self
        AllPostsTV.delegate = self
        ViewEditComment.isHidden = true
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        AllPostsTV.addSubview(refreshControl)
        
    }
    
    
    
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        self.postArray.removeAll()
        self.GetLive(Type: "Favourite", Refresh: "refresh")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.postArray.removeAll()
        self.GetLive(Type: "Favourite", Refresh: "reload")
    }
    
    
    func GetLive (Type : String , Refresh : String ){
        if Refresh == "reload" {
            HUD.show(.progress)
        } else {
            self.refreshControl.beginRefreshing()
        }
        if Reachable.isConnectedToNetwork(){
            API.GetAllPosts(Type : Type , pageNum : 0) { [self] (error : Error?, info : [PostModel]?, message : String?) in
                //                HUD.show(.progress)
                if error == nil && info != nil  {
                    
                    if info!.isEmpty {
                        self.showAlert(message: "No Content To show")
                        //                        AllPostsTV.isHidden = true
                        HUD.hide(animated: true)
                    } else {
                        for data in info! {
                            self.postArray.append(data)
                            AllPostsTV.isHidden = false
                        }
                        AllPostsTV.reloadData()
                        HUD.hide(animated: true)
                        self.refreshControl.endRefreshing()
                    }
                    
                } else if error == nil && info == nil {
                    HUD.flash(.label(message), delay: 2.0)
                    HUD.hide(animated: true)
                } else {
                    self.showAlert(message: "Server Error")
                    HUD.hide(animated: true)
                }
            }
            
        } else {
            showAlert(message: "No Internet Connection")
        }
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
            BtnCancelComment.isHidden = false
            IVEditComment.isHidden = false
            HSuperComment.constant = 390
            HVEComment.constant = 120
            IVEditComment.image = image
        }
        
    }
    @IBAction func BUImageGallaryEditComment(_ sender: Any) {
        showPhotoMenu()
    }
    
    func EditAll(Arr : [PostModel] , HideView : UIView , TV : UITableView ,  Type : API.Editenum ,  Id: Int, text: String, Image: String ){
        
        print(":::::::::::::::::::::::: \(Id)")
        
        
        API.EditAll(Type: Type , Id: Id , text: text, Image: Image) { (error : Error?, status : Int?, message : String?) in
            if error == nil && status == 0 {
                for data in Arr {
                    if data.Id == Id {
                        print(data.Id)
                        data.text  = text
                        data.Image = Image
                        TV.reloadData()
                        HideView.isHidden = true
                        HUD.hide(animated: true, completion: nil)
                        
                        print("data.text : \(data.text )      data.image : \(data.Image)")
                        
                    }
                }
                
            } else if error == nil && status == -1 {
                HUD.flash(.label(message), delay: 2.0)
            } else {
                HUD.flash(.label("Server Error"), delay: 2.0)
            }
        }
    }
    
    @IBAction func BUUpdateComment(_ sender: Any) {
        
        HUD.show(.progress)
        if Reachable.isConnectedToNetwork(){
            
            print(":::::::::::::::::::::::: \(EditId)")
            
            if IVEditComment.image == nil {
                EditAll( Arr: postArray , HideView : ViewEditComment , TV : AllPostsTV ,Type : .post , Id: EditId , text: TVeditComment.text! , Image: "" )
            } else {
                API.uploadImage(image: IVEditComment.image!) { [self] (error : Error?, status : Int?, message : String? ,imageEndPoint : String?) in
                    if error == nil && status == 0 {
                        
                        print(":::::::::::::::::::::::: \(EditId)")
                        
                        EditAll(Arr: postArray , HideView : ViewEditComment ,  TV : AllPostsTV ,Type : .post , Id: EditId , text: TVeditComment.text! , Image: "\(imageEndPoint!)" )
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
    
    
    
    @IBAction func BUCancelComment(_ sender: Any) {
        ViewEditComment.isHidden = true
    }
    
  
    
}



extension FavouritePosts : UITableViewDataSource , UITableViewDelegate , PostActionDelgate , PostActionNewPostDelgate {
    
    func Favourite(id : Int , reactType : Int , index : Int , LCount : UILabel){
        
        // add or remove React
        if Reachable.isConnectedToNetwork(){
            //                    HUD.show(.progress)
            API.addOrRemovePostReact(Type : "post" , PostId: id , ReactTypeId: reactType , completion: { [self] (error : Error?, status : Int, message : String?) in
                if error == nil && status == 0 {
                    
                    for data in postArray {
                        if data.Id == id {
                            print(data.Id)
                            
                            if data.ReactType == 1 {
                                data.ReactType = -1
                                data.ReactCount = data.ReactCount - 1
                                LCount.text = "\(data.ReactCount)"
                                //                                self.AllPostsTV.reloadRows(at: [index], with: .fade)
                                AllPostsTV.reloadData()
                            } else {
                                data.ReactType = 1
                                data.ReactCount = data.ReactCount + 1
                                LCount.text = "\(data.ReactCount)"
                                AllPostsTV.reloadData()
                                
                                //                                self.AllPostsTV.reloadRows(at: [index], with: .fade)
                            }
                        }
                    }
                } else if error == nil && status != 0 {
                    HUD.flash(.label(message), delay: 2.0)
                } else {
                    HUD.flash(.label("Server Error"), delay: 2.0)
                }
            }
            )} else {
                HUD.flash(.labeledError(title: "No Internet Connection", subtitle: "") , delay: 2.0)
            }
    }
    
    func NewPostFun () {
        let vc = self.storyboard?.instantiateViewController(identifier: "NewPostVC") as? NewPostVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    func CommentFun(index: Int) {
        let vc = self.storyboard?.instantiateViewController(identifier: "CommentsVC") as? CommentsVC
        vc?.ArrSuper = self.postArray[index]
        vc?.ImagePost = postArray[index].Image
        Shared.shared.PostLive = 0
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func LoveFun(status: Int , Bulove : UIButton , LCount : UILabel , postId: Int) {
        
        if status == -1 {
            Favourite(id: postId, reactType: 1, index: status , LCount : LCount )
            Bulove.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            Favourite(id: postId, reactType: -1, index: status , LCount : LCount)
            Bulove.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
    }
    
    func MoreFun(index: Int , PostLa : UILabel , deleteIndex : IndexPath) {
        
        
        
        let optionMenu = UIAlertController(title: nil, message: nil , preferredStyle: .actionSheet)
        
        let FavAction = UIAlertAction(title: "Remove From Favourit", style: .default, handler:
                                        { [self]
                                            (alert: UIAlertAction!) -> Void in
                                            
                                            // action here
                                            HUD.show(.labeledProgress(title: "Removing From Favourite", subtitle: ""))
                                            API.addOrRemoveFavouritePost(PostId: self.postArray[index].Id) { (error : Error?, status : Int, message : String?) in
                                                if error == nil && status == 0{
                                                    HUD.hide()
                                                    //                                                    HUD.flash(.label(message!), delay: 2.0 )
                                                    self.postArray.remove(at: index)
                                                    self.AllPostsTV.deleteRows(at: [deleteIndex], with: .fade)
                                                    self.AllPostsTV.reloadData()
                                                    
                                                }  else if error == nil && status == -1 {
                                                    HUD.flash(.label(message!), delay: 2.0)
                                                    HUD.hide()
                                                } else {
                                                    HUD.flash(.labeledError(title: nil , subtitle: " Server Error ") , delay: 3)
                                                    HUD.hide()
                                                }
                                            }
                                            
                                        })
        
        //        let PinAction = UIAlertAction(title: "Pin Post", style: .default, handler:
        //                                            { [self]
        //                                                (alert: UIAlertAction!) -> Void in
        //                                                // action
        //                                                HUD.show(.progress)
        //                                                API.addOrRemovePinPost(PostId: self.postArray[index - 1].Id) { (error : Error?, status : Int, message : String?) in
        //
        //                                                    if error == nil && status == 0{
        //                                                        HUD.flash(.label(" Pinned \(message!)"), delay: 2.0)
        //                                                        HUD.hide()
        //                                                    } else if error == nil && status == -1{
        //                                                        HUD.flash(.label(message!), delay: 2.0)
        //                                                        HUD.hide()
        //                                                    } else {
        //                                                        HUD.flash(.labeledError(title: nil , subtitle: " Server Error ") , delay: 3)
        //                                                        HUD.hide()
        //                                                    }
        //                                                }
        //
        //                                            })
        
        
        let UpdateAction = UIAlertAction(title: "Update Post", style: .default, handler:
                                            { [self]
                                                (alert: UIAlertAction!) -> Void in
                                                // action
                                                TVeditComment.text = postArray[index].text
                                                if postArray[index].Image == "" {
                                                    BtnCancelComment.isHidden = true
                                                    IVEditComment.isHidden = true
                                                    HSuperComment.constant = 320
                                                    HVEComment.constant = 50
                                                } else {
                                                    BtnCancelComment.isHidden = false
                                                    IVEditComment.isHidden = false
                                                    HSuperComment.constant = 390
                                                    HVEComment.constant = 120
                                                    Helper.SetImage(EndPoint: postArray[index].Image, image: IVEditComment, name: "2", status: 1)
                                                }
                                            
                                                ViewEditComment.isHidden = false
                                                EditId   = postArray[index].Id
                                                
                                                print(":::::::::::::::::::::::: \(EditId)")
                                                
                                            })
        
        let DeleteAction = UIAlertAction(title: "Delete Post", style: .destructive, handler:
                                            { [self]
                                                (alert: UIAlertAction!) -> Void in
                                                // action
                                                if Helper.getId() == String(postArray[index].UserId) {
                                                    
                                                    let alert2 = UIAlertController(title: "" , message: "Are You Sure To Delete ?", preferredStyle: .alert)
                                                    
                                                    alert2.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [self] (action) in
                                                        //                self.cellsNum -= 1
                                                        API.deletePost(Id: self.postArray[index].Id) { [self] (error : Error?, status : Int, message : String?) in
                                                            if Reachable.isConnectedToNetwork(){
                                                                if error == nil && status == 0  {
                                                                    self.postArray.remove(at: index)
                                                                    self.AllPostsTV.reloadData()
                                                                    HUD.flash(.labeledSuccess(title: message, subtitle: ""), delay: 1.0)
                                                                } else if error == nil && status == -1 {
                                                                    self.showAlert(message: message!)
                                                                } else {
                                                                    self.showAlert(message: "Server Error")
                                                                }
                                                            } else {
                                                                HUD.flash(.labeledError(title: "Network Error", subtitle: "Please Check your internet Connection"))
                                                                //                            self.showAlert(message: "No Internet Connection")
                                                            }
                                                        }
                                                    })
                                                    )
                                                    alert2.addAction(UIAlertAction(title: "Cacel", style: .cancel, handler: { [self] (action) in
                                                        self.dismiss(animated: true, completion: nil)
                                                        
                                                    }))
                                                    self.present(alert2, animated: true, completion: nil)
                                                    
                                                    
                                                } else {
                                                    self.showAlert(message: "You Dont Have Any Authorize To Delete This Post")
                                                }
                                            })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
                                            {
                                                (alert: UIAlertAction!) -> Void in
                                                // action
                                                print("cancel")
                                                
                                            })
        
        
        optionMenu.addAction(cancelAction)
        
        if Helper.getRoleName() != "Student" {
            optionMenu.addAction(DeleteAction)
        } else {
            if Helper.getId() == postArray[index].UserId {
                optionMenu.addAction(FavAction)
                optionMenu.addAction(UpdateAction)
                optionMenu.addAction(DeleteAction)
            } else {
                optionMenu.addAction(FavAction)
            }
        }
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(UINib(nibName: "PostBodyXibCell", bundle: nil), forCellReuseIdentifier: "PostBodyXibCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostBodyXibCell", for: indexPath) as! PostBodyXibCell
        
        cell.delegate = self
        cell.indexx = indexPath.row
        cell.deleteIndex = indexPath
        cell.status = postArray[indexPath.row ].ReactType
        cell.postId = postArray[indexPath.row].Id
        
        cell.cellMainLabel.text   = postArray[indexPath.row ].FirstName
        cell.LoveNumLaOutlet.text = "\(postArray[indexPath.row ].ReactCount)"
        cell.TimeLabel.text       = postArray[indexPath.row ].CreationTime
        
        if postArray[indexPath.row ].ReactType == 1 {
            cell.LoveBuOutlet.isSelected = true
        } else {
            cell.LoveBuOutlet.isSelected = false
        }
        
        
        
        if ( postArray[indexPath.row].Image.isEmpty == true &&  postArray[indexPath.row].text.isEmpty == false )   {
            cell.ViewImageFounded.isHidden = true
            cell.PostLa.isHidden           = false
            cell.PostLa.text               = postArray[indexPath.row - 1].text
        } else if postArray[indexPath.row].Image.isEmpty == false && postArray[indexPath.row].text.isEmpty == true {
            cell.PostLa.isHidden           = true
            cell.ViewImageFounded.isHidden = false
            Helper.SetImage(EndPoint: "\(postArray[indexPath.row].Image)", image: cell.PostImage! , name: "person.fill" , status: 0)
        } else {
            cell.PostLa.isHidden           = false
            cell.ViewImageFounded.isHidden = false
            
            cell.PostLa.text          = postArray[indexPath.row].text
            Helper.SetImage(EndPoint: "\(postArray[indexPath.row].Image)", image: cell.PostImage! , name: "person.fill" , status: 0)
        }
        
        
        
        
        Helper.SetImage(EndPoint: "\(postArray[indexPath.row].UserImage)", image: cell.cellImage!, name: "person.fill" , status: 0)
        cell.PostImage.setupImageViewer()
        
        return cell
        
    }
    

}


