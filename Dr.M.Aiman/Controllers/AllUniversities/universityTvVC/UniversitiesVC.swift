//
//  UniversitiesVC.swift
//  Dr.M.Aiman
//
//  Created by Muhamed Hammam on 16/06/2021.
//

import UIKit
import PKHUD

class UniversitiesVC: UIViewController {
    
    @IBOutlet weak var TvUniversities: UITableView!
    
    
//    var universities = ["Menofia University", "Banha University" , "Cairo Uinversity","Menofia University", "Banha University" , "Cairo Uinversity"]
//    var courses = ["Data structure", "Algorithms" , "File" , "MultiMedia","Data structure", "Algorithms" , "File" , "MultiMedia"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TvUniversities.dataSource = self
        self.TvUniversities.delegate = self
        
//        print(accessToken)
        GetUniversities()
        
        
    }
    
    
    
    
    //MARK:---------- GET ALL UNIVERSITIES
    var ArrUniversities = [UniversitiesModel]()
    var ArrCourses = [coursesModel]()
    
    func GetUniversities()  {
//        API.GetUniversitiesAndCourses { (error : Error?, universities : [UniversitiesModel]?, message : String?) in
//
//        }
        if Reachable.isConnectedToNetwork(){
            API.GetUniversitiesAndCourses { (error : Error?, universities : [UniversitiesModel]?, message : String?) in
                if error == nil && universities != nil {
                    if universities!.isEmpty {
                        HUD.flash(.label("No Content To Show"), delay: 2.0)
                        self.TvUniversities.isHidden = true
                    }else{
                        for data in universities!  {
                            if self.TvUniversities.isHidden == true{
                                self.TvUniversities.isHidden = false
                            }
                            
                            self.ArrUniversities.append(data)
                            self.ArrCourses.append(contentsOf: data.Courses)
                            
                            print("Arr course count :\(self.ArrCourses.count)")
                            
                            self.TvUniversities.reloadData()
                            HUD.hide(animated: true, completion: nil)
                        }
                        
                    }
                } else  if  error == nil && universities == nil {
                    HUD.flash(.label(message), delay: 2.0)
                }else {
                    HUD.flash(.label("Server Error"), delay: 2.0)
                }
            }
        } else {
            HUD.flash(.labeledError(title: "No Internet Connection", subtitle: "") , delay: 2.0)
        }
    }
    
    var tappedindex : Int! = 0
}

extension UniversitiesVC : UITableViewDataSource, UITableViewDelegate,
                           UICollectionViewDataSource,
                           UICollectionViewDelegate
{
    //MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ArrUniversities.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < ArrUniversities.count{
            return ArrUniversities[section].Title
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        TvUniversities.register(UINib(nibName: "UniversityCell", bundle: nil), forCellReuseIdentifier: "UniversityCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "UniversityCell", for: indexPath) as! UniversityCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    //set delegate and data sourses for collection inside table
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? UniversityCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
    
    
    //MARK: collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ArrUniversities[section].Courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(UINib(nibName: "coursesCell", bundle: nil), forCellWithReuseIdentifier: "coursesCell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "coursesCell", for: indexPath) as! coursesCell
        
        cell.LAcourseNameOut.text! = ArrUniversities[indexPath.section].Courses[indexPath.row].Title
        cell.LaPlaylistCount.text! = "( \(ArrUniversities[indexPath.section].Courses[indexPath.row].TotalPlayLists) Playlist )"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        tappedindex = indexPath.item
//        collectionView.reloadData()
        print("\(ArrUniversities[indexPath.section].Courses[indexPath.row].Id)")

        let vc = storyboard?.instantiateViewController(identifier: "PlaylistVC") as! PlaylistVC
        vc.selectedCourseID = "\(ArrUniversities[indexPath.section].Courses[indexPath.row].Id)"
        vc.selectedCourseTitle = "\(ArrUniversities[indexPath.section].Courses[indexPath.row].Title)"
//        vc.selectedCourseImage = "\(ArrUniversities[indexPath.section].Courses[indexPath.row].Image)"

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
}
