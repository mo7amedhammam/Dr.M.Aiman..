//
//  LiveVC.swift
//  Dr.M.Aiman
//
//  Created by Muhamed Hammam on 24/05/2021.
//

import UIKit
import IQKeyboardManagerSwift
import PKHUD
import ImageViewer_swift

class LiveVC : UIViewController {
    
    
    @IBOutlet weak var LiveTV: UITableView!
    @IBOutlet weak var BuAddLiveOut: UIBarButtonItem!
    //---------- Add New Live -----
    @IBOutlet var popupViewOut: UIView!
    @IBOutlet weak var popUpLabel: UILabel!
    @IBOutlet weak var VideoUrl: UITextField!
    @IBOutlet weak var Videodescribtion : UITextField!
    
    
    
    var Id = 0
    var pagenum = 0
    var ArrLive = [PostModel]()
    let refreshControl = UIRefreshControl()
    
    override func viewWillAppear(_ animated: Bool) {
        self.ArrLive.removeAll()
        self.GetLive(Type: "live", Refresh: "reload")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Helper.getRoleName() == "Student"{
            self.navigationItem.rightBarButtonItem = nil
                }
        LiveTV.dataSource = self
        LiveTV.delegate = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        LiveTV.addSubview(refreshControl)
   
   }
    
   @objc func refresh() {
    LiveTV.reloadData()
    
      // Code to refresh table view
//       self.ArrLive.removeAll()
//       self.GetLive(Type: "live", Refresh: "refresh")
   }
    

//
//    @IBAction func RefreshBtn(_ sender: Any) {
//        if self.ArrLive.isEmpty == false && LiveTV.isHidden{
//            self.LiveTV.isHidden = false
//            self.ArrLive.removeAll()
//            self.refreshControl.beginRefreshing()
//            self.GetLive(Type: "live", Refresh: "refresh")
//        }else {
//            HUD.flash(.labeledError(title: "No Lives Found ", subtitle: ""), delay: 2)
//        }
//
//    }
    
    
    //---------- Get All Lives -----
    
    func GetLive (Type : String , Refresh : String ){
        if Refresh == "reload" {
            HUD.show(.progress)
        } else {
            self.refreshControl.beginRefreshing()
        }
        if Reachable.isConnectedToNetwork(){
            API.GetAllPosts(Type : Type , pageNum : 0) { [self] (error : Error?, info : [PostModel]?, message : String?) in
                
                if error == nil && info != nil  {
                    if info!.isEmpty {
                        self.showAlert(message: "No Content To show")
//                        LiveTV.isHidden = true
                        HUD.hide(animated: true)
                    } else {

                        for data in info! {
                            self.ArrLive.append(data)
                        }
                        //  LiveTV.isHidden = false
                        HUD.hide(animated: true)
//                        self.refreshControl.endRefreshing()
                    }

                } else if error == nil && info == nil {
                    HUD.flash(.label(message), delay: 2.0)
                    HUD.hide(animated: true)
                } else {
                    self.showAlert(message: "Server Error")
                    HUD.hide(animated: true)
                }
                LiveTV.reloadData()

            }

        } else {
            showAlert(message: "No Internet Connection")
        }
    }


    @IBAction func NewLivePopUp(_ sender: Any) {
        self.showPopUp(pop: popupViewOut)
    }
    @IBAction func saveBtnPressed(_ sender: Any) {
        AddLive()
    }
    @IBAction func cancelPopUp(_ sender: Any) {
        self.hidePopUp(pop: popupViewOut)
    }
    
    func AddLive(){
      
        API.addNewLive(Title: VideoUrl.text!, Detailes: Videodescribtion.text! ) { (error : Error?, status : Int? , message : String? ) in
            if Reachable.isConnectedToNetwork(){
                if error == nil && status == 0  {
                    //                    self.showAlert(message: "Success")
                    HUD.flash(.labeledSuccess(title: "Added", subtitle: ""), delay: 1.0)
                    self.hidePopUp(pop: self.popupViewOut)
                    //                    self.viewDidLoad()
//                    if self.LiveTV.isHidden == true{
//                        self.LiveTV.isHidden = false
//                        // -> empty array object
//                    }
                    self.ArrLive.removeAll()
                    self.viewDidLoad()
                } else if error == nil && status == -1 {
                    self.showAlert(message: message!)
                } else {
                    self.showAlert(message: "Server Error")
                }
            } else {
                self.showAlert(message: "No Internet Connection")
            }
        }
    }
}


extension LiveVC : UITableViewDataSource , UITableViewDelegate , LiveActionDelegate {
    
    func Favourite(id : Int , reactType : Int , index : Int , LCount : UILabel){
        // add or remove React
        if Reachable.isConnectedToNetwork(){
            //                    HUD.show(.progress)
            API.addOrRemovePostReact( Type : "live" , PostId: id , ReactTypeId: reactType , completion: { [self] (error : Error?, status : Int, message : String?) in
                if error == nil && status == 0 {
                    
                    for data in ArrLive {
                        if data.Id == id {
                            print(data.Id)

                            if data.ReactType == 1 {
                                data.ReactType = -1
                                data.ReactCount = data.ReactCount - 1
                                LCount.text = "\(data.ReactCount)"
//                                self.AllPostsTV.reloadRows(at: [index], with: .fade)
                                LiveTV.reloadData()
                            } else {
                                data.ReactType = 1
                                data.ReactCount = data.ReactCount + 1
                                LCount.text = "\(data.ReactCount)"
                                LiveTV.reloadData()
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
    
    
    func CommentFun(index: Int) {
        let vc = self.storyboard?.instantiateViewController(identifier: "CommentsVC") as? CommentsVC
        vc?.ArrSuper = self.ArrLive[index]
        vc?.VedioLive = self.ArrLive[index].Title
        Shared.shared.PostLive = 1
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func LoveFun(status: Int, Bulove: UIButton, LCount: UILabel, postId: Int) {
        if status == -1 {
            Favourite(id: postId, reactType: 1, index: status , LCount : LCount )
            Bulove.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            Favourite(id: postId, reactType: -1, index: status , LCount : LCount)
            Bulove.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
    }
    
    func MoreFun(index: Int, PostLa: UILabel, deleteIndex: IndexPath) {
        
        let alert = UIAlertController(title: nil, message: nil , preferredStyle: .actionSheet)
        
//        alert.addAction(UIAlertAction(title: "Edit Live" , style: .default, handler: { [self] (action) in
//            // action Here
//            self.showAlert(message: "Success Edit")
//        }))
        
        alert.addAction(UIAlertAction(title: "Delete Live", style: .destructive, handler: { [self] (action) in
            // action Here
            //                self.posttextarray.remove(at: indexPath.row)
            let alert1 = UIAlertController(title: "", message: "Are You Sure To Delete?", preferredStyle: .alert)
            alert1.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [self] (action) in
                //            self.cellsNumber -= 1
                API.deleteLive(Id: self.ArrLive[index].Id) { [self] (error : Error?, status : Int, message : String?) in
                    if Reachable.isConnectedToNetwork(){
                        if error == nil && status == 0  {
                            self.ArrLive.remove(at: index)
                            self.LiveTV.deleteRows(at: [deleteIndex] , with: .fade)
                            //                                self.showAlert(message: "Deleted")
                            HUD.flash(.labeledSuccess(title: "Deleted", subtitle: ""), delay: 1.0)
//                            if self.ArrLive.isEmpty {
//                                self.LiveTV.isHidden = true
//                            } else {
//                                self.LiveTV.reloadData()
//                            }
                            //                                self.ArrLive.count -= 1
                            //                                self.GetLive()
                            
                            LiveTV.reloadData()
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
                
            }))
            
            alert1.addAction(UIAlertAction(title: "Cacel", style: .cancel, handler: { [self] (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert1, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            //          cancel Button with cancel style
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrLive.count
    }
    
    //MARK: Pagination
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row == ArrLive.count - 1{
//            pagenum += 1
//            GetLive(Type: "live", Refresh: "reload")
//        }
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveTVCell") as! LiveTVCell
        
        cell.delegate = self
        cell.indexx = indexPath.row
        cell.deleteIndex = indexPath
//        cell.status = ArrLive[indexPath.row].ReactType
//        cell.postId = ArrLive[indexPath.row].Id
        
        if Helper.getRoleName() == "Student" {
            cell.BtnMore.isHidden  = true
        } else {
            cell.BtnMore.isHidden  = false
        }
        
        cell.cellMainLabel.text   = "\(ArrLive[indexPath.row].FirstName)"
        // no creationTime in Lives
        cell.TimeLabel.text       = "\(ArrLive[indexPath.row].CreationDate)"
        cell.WatchinNumberLa.text = "\(ArrLive[indexPath.row].ReactCount)"
        Helper.SetImage(EndPoint: "\(ArrLive[indexPath.row].UserImage)", image: cell.cellImage, name: "person.fill" , status: 0)
        cell.cellImage.setupImageViewer()
        
        cell.PostLa.text = ArrLive[indexPath.row].Detailes
        let vidurl       =  URL( string: ArrLive[indexPath.row].Title)
        cell.VideoViewOut.loadVideoURL(vidurl!)
     
        if indexPath.row == ArrLive.count-1{
            refreshControl.endRefreshing()
        }
        return cell
        
    }
    
}

extension LiveVC{
  
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
    func hidePopUp (pop : UIView) {
        self.VideoUrl.text = ""
        self.Videodescribtion.text = ""
        UIView.animate(withDuration: 0.3, animations: {
            pop.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            pop.alpha     = 0
        }) { (success:Bool) in
            pop.removeFromSuperview()
        }
    }
    
    
    
}
