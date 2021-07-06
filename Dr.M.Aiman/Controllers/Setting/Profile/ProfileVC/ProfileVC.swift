//
//  ProfileVC.swift
//  Dr.M.Aiman
//
//  Created by Muhamed Hammam on 30/05/2021.
//

import UIKit

class ProfileVC : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var cellsNum = 3
    //    var arrDetail = ["mmmmmmm nn nn nn nnnn nnbbbb bbb hhjjjj jjjjjjjjjjjjjjj jjmmmmmmm nn nn nn nnnn nnbbbb bbb hhjjjj jjjjjjjjjjjjjjj mmmmmmm nn nn nn nnnn nnbbbb bbb hhjjjj jjjjjjjjjjjjjjj mmmmmmm nn nn nn nnnn nnbbbb bbb hhjjjj jjjjjjjjjjjjjjj mmmmmmm nn nn nn nnnn nnbbbb bbb hhjjjj jjjjjjjjjjjjjjj mmmmmmm nn nn nn nnnn nnbbbb bbb hhjjjj jjjjjjjjjjjjjjj mmmmmmm nn nn nn nnnn nnbbbb bbb hhjjjj jjjjjjjjjjjjjjj mmmmmmm nn nn nn nnnn nnbbbb bbb hhjjjj jjjjjjjjjjjjjjj " ,"mmmmmmm nn nn nn nnnn nnbbbb bbb hhjjjj jjjjjjjjjjjjjjj jjjjjj jjjjjjjjjjj iiiiiiiiii iiiii" ,"mmmmmmm nn nn nn nnnn nnbbbb bbb hhjjjj jjjjjjjjjjjjjjj jj" ,"mmmmmmm nn nn nn nnnn nnbbbb bbb hhjjjj jjjjmmm oookv;ldmvkv kk;vkjhd jnjhhcb jjjjjjjjjjj jj" ,"mmmmmmm nn nn nn nnnn nnbbbb bbb hhjjjj jjjjjjjjjjjjjjj jj" ,"mmmmmmm nn nn nn nnnn nnbbbb bbb hhjjjj jjjjjjjjjjjjjjj jj" ,"mmmmmmm nn nn nn nnnn nnbbbb bbb hhjjjj jjjjjjjjjjjjjjj jj" ,"mmmmmmm nn nn nn nnnn nnbbbb bbb hhjjjj jjjjjjjjjjjjjjj jj" ,"mmmmmmm nn nn nn nnnn nnbbbb bbb hhjjjj jjjjjjjjjjjjjjj jj" ,"mmmmmmm nn nn nn nnnn nnbbbb bbb hhjjjj jjjjjjjjjjjjjjj jj" ]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            tableView.register(UINib(nibName: "ProfileHeaderXibCell", bundle: nil), forCellReuseIdentifier: "ProfileHeaderXibCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderXibCell") as! ProfileHeaderXibCell
            //setCardView(view: cell.StatusorImageV)
            //            cell.delegate = self
            return cell
        }else{
            tableView.register(UINib(nibName: "PostBodyXibCell", bundle: nil), forCellReuseIdentifier: "PostBodyXibCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostBodyXibCell", for: indexPath) as! PostBodyXibCell
            //            cell.PostLa.text! = arrDetail[indexPath.row]
            
//            cell.didMore = {
//                [weak self] in
//                guard let self = self else { return }
//
//
//                // --------- Edit
//                let alert = UIAlertController(title: "", message: "What Would you Like To Do ?", preferredStyle: .actionSheet)
//
//                alert.addAction(UIAlertAction(title: "Edit Post" , style: .default, handler: { [self] (action) in
//                    // action Here
//                    //                    self.showAlert(message: "Edited" )
//
//                    let alert1 = UIAlertController(title: "", message: "Edit Your Post", preferredStyle: .alert)
//
//                    // text input TF
//                    alert1.addTextField(configurationHandler: { TitleTF in
//                        TitleTF.placeholder = "New Post..."
//                        TitleTF.textAlignment = .center
//                    })
//
//
//                    alert1.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
//                        let NewPostText = alert1.textFields?.first?.text
//                        //                        let noteBody = alert.textFields?.last?.text
//                        print(NewPostText!)
//                        cell.PostLa.text = NewPostText
//                        self.ProfileTV.reloadData()
//                        //            self.determineMyCurrentLocation()
//
//                    }))
//                    alert1.addAction(UIAlertAction(title: "Cencel", style: .cancel, handler: nil))
//                    self.present(alert1, animated: true, completion: nil)
//                }))
//
//                //-------- Delete
//                alert.addAction(UIAlertAction(title: "Delete Post", style: .destructive, handler: { [self] (action) in
//                    let alert2 = UIAlertController(title: "", message: "Are You Sure To Delete?", preferredStyle: .alert)
//                    alert2.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [self] (action) in
//                        self.cellsNum -= 1
//                        self.ProfileTV.deleteRows(at: [indexPath], with: .fade)
//                        self.ProfileTV.reloadData()
//
//                    }))
//                    alert2.addAction(UIAlertAction(title: "Cacel", style: .cancel, handler: { [self] (action) in
//                        self.dismiss(animated: true, completion: nil)
//                    }))
//                    self.present(alert2, animated: true, completion: nil)
//                }))
//
//                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
//                    //          cancel Button with cancel style
//                }))
//                self.present(alert, animated: true, completion: nil)
//            }
//            var clicked1 = 0
            
            
//            cell.didLove = {
//                let loveCounter = Int(cell.LoveNumLaOutlet.text!)!
//                if cell.clicked1 == true{
//                    cell.LoveNumLaOutlet.text = String( loveCounter  + 1 )
////                self.AllPostsTV.reloadData()
//                }else if cell.clicked1 == false {
//                    cell.LoveNumLaOutlet.text = String( loveCounter  - 1 )
//                }
//                                self.ProfileTV.reloadData()
//
//            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    @IBOutlet weak var ProfileTV: UITableView!
    //    var logedIn = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        // Do any additional setup after loading the view.
        ProfileTV.dataSource = self
        ProfileTV.delegate = self
        //        self.navigationItem.title = "All P"
        
    }
}
