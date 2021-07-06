//
//  PlaylistVC.swift
//  Dr.M.Aiman
//
//  Created by Mohamed Salman on 5/24/21.
//

import UIKit
import PKHUD

class PlaylistVC: UIViewController {

    @IBOutlet weak var PlaylistCollectionViewList: UICollectionView!
    var selectedCourseID : String!
    var selectedCourseTitle : String!

    @IBOutlet weak var LAcourseName: UILabel!
    @IBOutlet weak var IVSelectedcourse: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
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

    var arrPlaylists = [PlaylistModel]()
    func getPlayLists() {
        if Reachable.isConnectedToNetwork(){
            API.GetPlaylistByCourse(id: self.selectedCourseID!) { (error : Error?, Playlists : [PlaylistModel]?, message : String?) in
                
                if error == nil && Playlists != nil {
                    if Playlists!.isEmpty {
                        HUD.flash(.label("No Content To Show"), delay: 2.0)
                        self.PlaylistCollectionViewList.isHidden = true
                    }else{
                        for data in Playlists!  {
                            if self.PlaylistCollectionViewList.isHidden == true{
                                self.PlaylistCollectionViewList.isHidden = false
                            }
                            
                            self.arrPlaylists.append(data)
//                            self.ArrCourses.append(contentsOf: data.Courses)
                            
                            print("Arr course count :\(self.arrPlaylists.count)")
                            
                            self.PlaylistCollectionViewList.reloadData()
                            HUD.hide(animated: true, completion: nil)
                        }
                        
                    }
                } else  if  error == nil && Playlists == nil {
                    HUD.flash(.label(message), delay: 2.0)
                }else {
                    HUD.flash(.label("Server Error"), delay: 2.0)
                }
            }
        } else {
            HUD.flash(.labeledError(title: "No Internet Connection", subtitle: "") , delay: 2.0)
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
