//
//  PlaylistVC.swift
//  Dr.M.Aiman
//
//  Created by Mohamed Salman on 5/24/21.
//

import UIKit

class PlaylistVC: UIViewController {

    @IBOutlet weak var PlaylistCollectionViewList: UICollectionView!
    var selectedCourseID : String!
    var selectedCourseTitle : String!

    @IBOutlet weak var LAcourseName: UILabel!
    @IBOutlet weak var IVSelectedcourse: UIImageView!
    
    var indicator:ProgressIndicator?
    var arrPlaylists = [PlaylistModel]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

         // indicator hud ----------------//
        indicator = ProgressIndicator(inview:self.view,loadingViewColor: UIColor.lightGray, indicatorColor: #colorLiteral(red: 0.07058823529, green: 0.3568627451, blue: 0.6352941176, alpha: 1) , msg:  SalmanLocalize.textLocalize(key: "LPleaseWait") )
        indicator?.center = self.view.center
        self.view.addSubview(indicator!)
         //  end indicator hud ----------------//
    
        self.PlaylistCollectionViewList.delegate = self
        self.PlaylistCollectionViewList.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        PlaylistCollectionViewList.setCollectionViewLayout(layout, animated: true)
        // Do any additional setup after loading the view.
        LAcourseName.text! = selectedCourseTitle
        getPlayLists()
    }

    func getPlayLists() {
        self.indicator?.start()
        if Reachable.isConnectedToNetwork(){
            API.GetPlaylistByCourse(id: self.selectedCourseID!) { (error : Error?, Playlists : [PlaylistModel]?, message : String?) in
                
                if error == nil && Playlists != nil {
                    if Playlists!.isEmpty {
                        self.AlertShowMessage(controller: self, text: "No Content To Show", status: 1)
                        self.PlaylistCollectionViewList.isHidden = true
                        self.indicator?.stop()
                    }else{
                        for data in Playlists!  {
                            if self.PlaylistCollectionViewList.isHidden == true{
                                self.PlaylistCollectionViewList.isHidden = false
                            }
                            
                            self.arrPlaylists.append(data)
//                            self.ArrCourses.append(contentsOf: data.Courses)
                            self.PlaylistCollectionViewList.reloadData()
                            self.indicator?.stop()
                            
                        }
                        
                    }
                } else  if  error == nil && Playlists == nil {
                    self.AlertShowMessage(controller: self, text: message!, status: 1)
                    self.indicator?.stop()
                }else {
                    self.AlertServerError(controller: self)
                    self.indicator?.stop()
                }
            }
        } else {
            self.AlertInternet(controller: self)
            self.indicator?.stop()
        }
    }


}
extension PlaylistVC : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
       return arrPlaylists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = PlaylistCollectionViewList.dequeueReusableCell(withReuseIdentifier: "AllCourseCVCell", for: indexPath) as! AllCourseCVCell
        cell.LCourseName.text! = arrPlaylists[indexPath.row].Title
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
        //here your custom value for spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
        
        return CGSize(width:widthPerItem, height:120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "RefernceVC") as! RefernceVC
        vc.selectedCourseVideosNumber = arrPlaylists[indexPath.row].TotalVideos
//        vc.selectedCourseImage = "\(ArrUniversities[indexPath.section].Courses[indexPath.row].Image)"

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
