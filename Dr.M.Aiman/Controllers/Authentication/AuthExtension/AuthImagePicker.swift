////
////  AuthImagePicker.swift
////  SAHL
////
////  Created by Mohamed Salman on 4/20/21.
////
//
//import UIKit
//extension ClientSignUPVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
//    public func imagePickerController(_ picker: UIImagePickerController,
//                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//        IVUser.contentMode = .scaleAspectFill
//        let chosenImage = info[.originalImage] as? UIImage
//        IVUser.image = chosenImage
//        dismiss(animated: true, completion: nil)
//        
//    }
//    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
//    {
//        
//        let actionSheet  = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
//        let imageOpenCamera = UIImage(systemName: "camera.fill")
//        let imageGallary    = UIImage(systemName:"photo.fill")
//        
//        ///
//        let alertActionCamera = UIAlertAction(title: "التقاط صوره", style: .default, handler: { (_) in
//            if UIImagePickerController.isSourceTypeAvailable(.camera)
//            {
//                self.imagePicker.sourceType = .camera;
//                self.imagePicker.allowsEditing = false
//                self.present(self.imagePicker, animated: true, completion: nil)
//                
//            }
//        })
//        alertActionCamera.setValue(imageOpenCamera, forKey: "image")
//        actionSheet.addAction(alertActionCamera)
//        ///
//        let alertActionGallary = UIAlertAction(title: "اختيار من المعرض", style: .default, handler: { (_) in
//            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
//            {
//                self.imagePicker.sourceType = .savedPhotosAlbum;
//                self.imagePicker.allowsEditing = false
//                self.present(self.imagePicker, animated: true, completion: nil)
//                
//            }
//            //            self.ViewPhotoIndicator.isHidden = false
//            
//        })
//        alertActionGallary.setValue(imageGallary, forKey: "image")
//        actionSheet.addAction(alertActionGallary)
//        //
//        actionSheet.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: nil))
//        // valide ipad action sheet
//        if let popoverController = actionSheet.popoverPresentationController {
//            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
//            popoverController.sourceView = self.view
//            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
//        }
//        //------------------------
//        present(actionSheet, animated: true, completion: nil)
//
//    }
//}
