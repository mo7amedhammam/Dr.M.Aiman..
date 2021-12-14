//
//  AllCoursesVC.swift
//  Mideo
//
//  Created by Mohamed Salman on 3/28/20.
//  Copyright © 2020 IT PLUS. All rights reserved.
//

import UIKit

class AllCoursesVC: UIViewController {

    @IBOutlet weak var CourseCollectionViewList: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleGesture))
        self.CourseCollectionViewList!.addGestureRecognizer(gesture)
        
        self.CourseCollectionViewList.delegate = self
        self.CourseCollectionViewList.dataSource = self

        
        if let layout = CourseCollectionViewList.collectionViewLayout as? PinterestLayout{
            layout.delegate = self
        }
        
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical //.horizontal
//        layout.minimumLineSpacing = 5
//        layout.minimumInteritemSpacing = 5
//        CourseCollectionViewList.setCollectionViewLayout(layout, animated: true)
        // Do any additional setup after loading the view.
    }
    
    @objc func handleGesture(gesture : UILongPressGestureRecognizer){
        guard let collectionview = CourseCollectionViewList else {
            return
        }
        
        switch gesture.state {
        case .began:
            guard let targetIndexpath = collectionview.indexPathForItem(at: gesture.location(in: collectionview)) else {
                return
            }
            collectionview.beginInteractiveMovementForItem(at: targetIndexpath)
            
        case.changed:
            collectionview.updateInteractiveMovementTargetPosition(gesture.location(in: collectionview))
        case.ended:
            collectionview.endInteractiveMovement()
        default:
            collectionview.cancelInteractiveMovement()
        }
        
    }
    
    
    

    
    var collectionarray = ["course 1","course 2","course 3","course 4","course 5","course 6","course 1","course 2","course 3","course 4","course 5","course 6"]
    var coursesImagearray = ["1","2","3","4","5","6","2","1","3","4","5","6"]

}

extension AllCoursesVC : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PinterestLayoutDelegate   {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = UIImage(named: "\(coursesImagearray[indexPath.row])")
//        image?.scale
        if let height = image?.size.height {
            
            if height > 5000 {
                return height / 25
            }else if height > 2000 && height <= 5000 {
            return height / 15
            }else if height > 1000 && height <= 2000 {
                return height / 10
            } else{
                return height / 4
            }
            
        }
        return 0
    }
    
    func scaleImage(image: UIImage, maximumWidth: CGFloat) -> UIImage
    {
        let rect: CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        let cgImage: CGImage = image.cgImage!.cropping(to: rect)!

        return UIImage(cgImage: cgImage, scale: image.size.width / maximumWidth, orientation: image.imageOrientation)

    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
        return collectionarray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CourseCollectionViewList.dequeueReusableCell(withReuseIdentifier: "AllCourseCVCell", for: indexPath) as! AllCourseCVCell
        cell.IVCourse.image = UIImage(named: "\(coursesImagearray[indexPath.row])")
        cell.LCourseName.text = collectionarray[indexPath.row]

        cell.layer.cornerRadius = 12
        cell.LCourseName.textColor = .white
//        cell.IVCourse
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "playListSegue", sender: self)
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

    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = collectionarray.remove(at: sourceIndexPath.row)
        collectionarray.insert(item, at: destinationIndexPath.row)
    }
    
}
