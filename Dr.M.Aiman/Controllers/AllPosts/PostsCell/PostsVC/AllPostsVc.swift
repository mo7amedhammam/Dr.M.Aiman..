//
//  AllPostsVc.swift
//  Dr.M.Aiman
//
//  Created by Muhamed Hammam on 24/05/2021.
//

import UIKit
import Alamofire
import ImageViewer_swift

class AllPostsVc: UIViewController  {
    
    //    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var AllPostsTV: UITableView!
    
    var postArray = [PostModel]()
    
    var pinArr = [PostModel]()
    var pinedpostIndex = 0
    
    @IBOutlet weak var HVEComment: NSLayoutConstraint!
    @IBOutlet weak var HSuperComment: NSLayoutConstraint!
    @IBOutlet weak var BtnCancelComment: UIButton!
    
    
    @IBOutlet weak var ViewEditComment: UIView!
    @IBOutlet weak var IVEditComment: UIImageView!
    @IBOutlet weak var TVeditComment: UITextView!
    var EditId = 0
    
    var indicator:ProgressIndicator?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // indicator hud ----------------//
        indicator = ProgressIndicator(inview:self.view,loadingViewColor: UIColor.lightGray, indicatorColor: #colorLiteral(red: 0.07058823529, green: 0.3568627451, blue: 0.6352941176, alpha: 1) , msg:  SalmanLocalize.textLocalize(key: "LPleaseWait") )
        indicator?.center = self.view.center
        self.view.addSubview(indicator!)
        //  end indicator hud ----------------//
        
        
        AllPostsTV.register(UINib(nibName: "PostBodyXibCell", bundle: nil), forCellReuseIdentifier: "PostBodyXibCell")
        self.navigationItem.rightBarButtonItem = nil
        
        
        //        let isoDate = "2016-04-14T10:44:00+0000"
        //
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        //        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        //        let date = dateFormatter.date(from:isoDate)!
        //
        //
        //        let TimeAt = Date()
        //        let dateFormatter2 = DateFormatter()
        //        dateFormatter2.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        //        dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        //        let date2 = dateFormatter.date(from: dateFormatter2.string(from: TimeAt) )!
        //
        //
        //        if date > date2 {
        //            print("isoDate Date...... ")
        //        } else {
        //            print("Date2....... ")
        //        }
        
        
        AllPostsTV.dataSource    = self
        AllPostsTV.delegate      = self
        ViewEditComment.isHidden = true
        
        //        self.GetPosts(Type: "reload")
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        AllPostsTV.addSubview(refreshControl)
        
        //        self.AllPostsTV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
    }
    
    
    //    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    //         if(keyPath == "contentSize"){
    //             if let newvalue = change?[.newKey]
    //             {
    //                 DispatchQueue.main.async {
    //                 let newsize  = newvalue as! CGSize
    //                 self.tableViewHeightConstraint.constant = newsize.height
    //                 }
    //
    //             }
    //         }
    //     }
    
    @objc func refresh() {
        AllPostsTV.reloadData()
        // Code to refresh table view
//        self.pinArr.removeAll()
//        self.postArray.removeAll()
//        self.GetPosts(Type: "refresh")
    }
    
    
    @IBAction func BURefreshEmpty(_ sender: Any) {
        self.postArray.removeAll()
        self.GetPosts(Type: "refresh")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.pinArr.removeAll()
        self.postArray.removeAll()
        self.GetPosts(Type: "reload")
    }
    
    
    @IBAction func GoToFavouritePosts(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "FavouritePosts") as? FavouritePosts
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func goToNotificationsVC(_ sender: Any) {
        //        let vc = storyboard?.instantiateViewController(identifier: "FavouritePosts") as? FavouritePosts
        //        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    // ---->  Get All Posts
    func GetPosts(Type : String )  {
        
        if Type == "reload" {
            self.indicator?.start()
        } else {
            self.refreshControl.beginRefreshing()
        }
        
        if Reachable.isConnectedToNetwork(){
            API.GetAllPosts(Type: "post", pageNum: 0) { [self] (error : Error?, info : [PostModel]?, message : String?) in
                if error == nil && info != nil{
                    if info!.isEmpty {
                        self.AlertShowMessage(controller: self, text: "No Content To Show", status: 1)
                        self.AllPostsTV.isHidden = true
                        self.indicator?.stop()

                    } else {
                        
                        self.indicator?.stop()
//                        self.refreshControl.endRefreshing()
                        for data in info! {
                            //                            if data.IsPinPost == true {
                            //                                self.pinArr.append(data)
                            //                            } else {
                            //                                self.postArray.append(data)
                            //                            }
                            
                            if  data.IsPinPost == true {
                                postArray.insert(data, at: pinedpostIndex)
                                pinedpostIndex += 1
                            } else{
                                postArray.append(data)
                            }
                        }
                        pinedpostIndex = 0
                        AllPostsTV.isHidden = false
//                        HUD.hide(animated: true, completion: nil)
//                        self.refreshControl.endRefreshing()
                        self.AllPostsTV.reloadData()

                        
                        //                        self.pinArr.append(contentsOf: postArray)
                        //                        self.postArray = self.pinArr
                        //                        self.AllPostsTV.reloadData()
                        //                        HUD.hide(animated: true, completion: nil)
                        //                        self.refreshControl.endRefreshing()
                        
                    }
                } else  if  error == nil && info == nil{
                    print("info = nil ")
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
                        self.indicator?.stop()
                        print("data.text : \(data.text )      data.image : \(data.Image)")
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
    
    @IBAction func BUUpdateComment(_ sender: Any) {
        
        self.indicator?.start()
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
    
    
    @IBAction func BUCancelComment(_ sender: Any) {
        ViewEditComment.isHidden = true
    }

}

extension AllPostsVc : UITableViewDataSource , UITableViewDelegate , PostActionDelgate , PostActionNewPostDelgate {
    
    func Favourite(id : Int , reactType : Int , index : Int , LCount : UILabel){
        
        if Reachable.isConnectedToNetwork(){
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
                    self.AlertShowMessage(controller: self, text: message!, status: 1)
                }
            }
            )} else {
                self.AlertInternet(controller: self)
            }
    }
    
    func NewPostFun () {
        let vc = self.storyboard?.instantiateViewController(identifier: "NewPostVC") as? NewPostVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    func CommentFun(index: Int) {
        let vc = self.storyboard?.instantiateViewController(identifier: "CommentsVC") as? CommentsVC
        vc?.ArrSuper = self.postArray[index - 1]
        vc?.ImagePost = postArray[index - 1 ].Image
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
        
        func PinOrUnpin(index : Int){
        API.addOrRemovePinPost(PostId: self.postArray[index].Id) { (error : Error?, status : Int, message : String?) in
            if error == nil && status == 0{
                self.AlertShowMessage(controller: self, text: message!, status: 1)
                self.indicator?.stop()
            }  else if error == nil && status == -1 {
                self.AlertShowMessage(controller: self, text: message!, status: 1)
                self.indicator?.stop()
            } else {
                self.AlertServerError(controller: self)
                self.indicator?.stop()
            }
            
        }
        }
        
        let optionMenu = UIAlertController(title: nil, message: nil , preferredStyle: .actionSheet)
        
        let FavAction = UIAlertAction(title: "Add To Favourit", style: .default, handler:
                                        { [self]
                                            (alert: UIAlertAction!) -> Void in
                                            
                                            // action here
                                            self.indicator?.start()
                                            API.addOrRemoveFavouritePost(PostId: self.postArray[index - 1].Id) { (error : Error?, status : Int, message : String?) in
                                                if error == nil && status == 0{
                                                    Toast.show(message: "Successfully Added", controller: self)
                                                    self.indicator?.stop()
                                                }  else if error == nil && status == -1 {
                                                    self.AlertShowMessage(controller: self, text: message!, status: 1)
                                                    self.indicator?.stop()
                                                } else {
                                                    self.AlertServerError(controller: self)
                                                    self.indicator?.stop()
                                                }
                                            }
                                            
                                            
                                        })
        
        let PinAction = UIAlertAction(title: "Pin Post", style: .default, handler:
                                        { [self]
                                            (alert: UIAlertAction!) -> Void in
                                            // action
                                            
                                            //note: Pinned post must be inserted at index 0
                                            if postArray[0].IsPinPost == true {
                                                PinOrUnpin(index: 0)
                                                PinOrUnpin(index: index - 1)
                                            }else{
                                                PinOrUnpin(index: index - 1)
                                            }
                                           
                                            
                                            
                                        })
        
        
        let UpdateAction = UIAlertAction(title: "Update Post", style: .default, handler:
                                            { [self]
                                                (alert: UIAlertAction!) -> Void in
                                                // action
                                                TVeditComment.text = postArray[index - 1].text
                                                
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
                                                    Helper.SetImage(EndPoint: postArray[index - 1].Image, image: IVEditComment, name: "2", status: 1)
                                                }
                                                ViewEditComment.isHidden = false
                                                EditId   = postArray[index - 1].Id
                                                
                                                print(":::::::::::::::::::::::: \(EditId)")
                                                
                                                
                                            })
        
        let DeleteAction = UIAlertAction(title: "Delete Post", style: .destructive, handler:
                                            { [self]
                                                (alert: UIAlertAction!) -> Void in
                                                // action
                                                if Helper.getId() == String(postArray[index - 1].UserId) {
                                                    
                                                    let alert2 = UIAlertController(title: "" , message: "Are You Sure To Delete ?", preferredStyle: .alert)
                                                    
                                                    alert2.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [self] (action) in
                                                        //                self.cellsNum -= 1
                                                        API.deletePost(Id: self.postArray[index - 1 ].Id) { [self] (error : Error?, status : Int, message : String?) in
                                                            if Reachable.isConnectedToNetwork(){
                                                                if error == nil && status == 0  {
                                                                    self.postArray.remove(at: index - 1 )
                                                                    self.AllPostsTV.reloadData()
                                                                } else if error == nil && status == -1 {
                                                                    self.showAlert(message: message!)
                                                                } else {
                                                                    self.AlertServerError(controller: self)
                                                                }
                                                            } else {
                                                                self.AlertInternet(controller: self)
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
        
        if Helper.getId() == postArray[index - 1 ].UserId {
            optionMenu.addAction(FavAction)
            optionMenu.addAction(UpdateAction)
            optionMenu.addAction(DeleteAction)
        } else if Helper.getRoleName() != "Student" {
            optionMenu.addAction(PinAction)
            optionMenu.addAction(DeleteAction)
        }else{
            optionMenu.addAction(FavAction)
        }
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
        
        //                        print("Long press Pressed:::: \(indexPath)")
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostsHeaderCell") as! PostBodyXibCell
            cell.delegate2 = self
            return cell
        } else {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostBodyXibCell", for: indexPath) as! PostBodyXibCell
            
            cell.delegate = self
            cell.indexx = indexPath.row
            cell.deleteIndex = indexPath
            cell.status = postArray[indexPath.row - 1].ReactType
            cell.postId = postArray[indexPath.row - 1].Id
            
            cell.cellMainLabel.text   = postArray[indexPath.row - 1].FirstName
            cell.LoveNumLaOutlet.text = "\(postArray[indexPath.row - 1].ReactCount)"
            cell.TimeLabel.text       = postArray[indexPath.row - 1].CreationTime
            
            if postArray[indexPath.row - 1 ].ReactType == 1 {
                cell.LoveBuOutlet.isSelected = true
            } else {
                cell.LoveBuOutlet.isSelected = false
            }
            
            
            
            if ( postArray[indexPath.row - 1].Image.isEmpty == true &&  postArray[indexPath.row - 1].text.isEmpty == false )   {
                cell.ViewImageFounded.isHidden = true
                cell.PostLa.isHidden           = false
                cell.PostLa.text               = postArray[indexPath.row - 1].text
            } else if postArray[indexPath.row - 1].Image.isEmpty == false && postArray[indexPath.row - 1].text.isEmpty == true {
                cell.PostLa.isHidden           = true
                cell.ViewImageFounded.isHidden = false
                Helper.SetImage(EndPoint: "\(postArray[indexPath.row - 1].Image)", image: cell.PostImage! , name: "person.fill" , status: 0)
            } else {
                cell.PostLa.isHidden           = false
                cell.ViewImageFounded.isHidden = false
                
                cell.PostLa.text          = postArray[indexPath.row - 1].text
                Helper.SetImage(EndPoint: "\(postArray[indexPath.row - 1].Image)", image: cell.PostImage! , name: "person.fill" , status: 0)
            }
            
            Helper.SetImage(EndPoint: postArray[indexPath.row - 1].UserImage, image: cell.cellImage!, name: "person.fill" , status: 0)
            cell.PostImage.setupImageViewer()
            
            
            if indexPath.row == postArray.count - 1{
                refreshControl.endRefreshing()
            }
            return cell
        }
    }
    
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return UITableView.automaticDimension
    //    }
}

