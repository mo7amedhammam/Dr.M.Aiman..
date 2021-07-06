//
//  PdfCategoryVC.swift
//  Dr.M.Aiman
//
//  Created by mac on 01/07/2021.
//
import UIKit
import PKHUD

class PdfCategoryVC: UIViewController {
    
    @IBOutlet weak var BtnAddCat: UIBarButtonItem!
    @IBOutlet weak var TVCategory: UITableView!
    var ArrPDFCAtegory = [CategoryModel]()
    
    
    @IBOutlet weak var LaWrite: UILabel!
    @IBOutlet weak var ViewAddCat: UIView!
    @IBOutlet weak var TFNewCat: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var BtnAddOrUpdate: UIButton!
    var AddOrUpdate     = 0
    var idForUpdate     = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        TVCategory.dataSource = self
        TVCategory.delegate = self
        PDFCategory(pagenum: 0)
        
        LaWrite.text = "Write Category Name"
        BtnAddOrUpdate.setTitle("Add", for: .normal)
        ViewAddCat.isHidden = true
        
        if Helper.getRoleName() == "Student" {
            self.navigationItem.rightBarButtonItem = nil
        } else {
            self.BtnAddCat.isEnabled = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ArrPDFCAtegory.removeAll()
        PDFCategory(pagenum: 0)
    }
 
    
    
    func Upload_Pdf_with_Name ( Type : API.Category , Id : Int , Name : String){
                
        print("type  : \(Type)    id  : \(Id)")
        if Reachable.isConnectedToNetwork() {
            HUD.show(.progress)
            API.PDFCategory(type : Type , Id : Id ,  Name : Name ) { [self] (error : Error?, status : Int, message : String?) in
                if error == nil && status == 0  {
                    HUD.hide()
                    ViewAddCat.isHidden = true
                    HUD.flash(.label("Success"), delay: 2.0)
                    TFNewCat.text = ""
                    ArrPDFCAtegory.removeAll()
                    PDFCategory(pagenum: 0)
                } else if error == nil && status == -1 {
                    HUD.hide()
                    HUD.flash(.label(message), delay: 2.0)
                } else {
                    HUD.hide()
                    HUD.flash(.label("Server Error"), delay: 2.0)
                }
            }
            
        } else {
            HUD.flash(.labeledError(title: "no connection", subtitle: "please check your internet connection"), delay: 2.0)
        }
        
    }
    
    
    @IBAction func BUAddCategory(_ sender: Any) {
        AddOrUpdate = 0
        ViewAddCat.isHidden = false
    }

    @IBAction func BUAddNewCat(_ sender: Any) {
        
        if AddOrUpdate == 0 {
            Upload_Pdf_with_Name(Type: .add, Id: 0 , Name: TFNewCat.text! )
        } else {
            Upload_Pdf_with_Name(Type: .edit, Id: idForUpdate , Name: TFNewCat.text! )
        }
       
    }
    
    @IBAction func BUCancel(_ sender: Any) {
        ViewAddCat.isHidden = true
        TFNewCat.text = ""
    }
    
    
}


extension PdfCategoryVC : UITableViewDelegate , UITableViewDataSource, moreActiondelegate {
    
    func moreOptions(index : Int) {
        
        let optionMenu = UIAlertController(title: nil, message: nil , preferredStyle: .actionSheet)
        let EditAction = UIAlertAction(title: "Edit Pdf", style: .default, handler:
                                        { [self]
                                            (alert: UIAlertAction!) -> Void in
                                            
                                            // action
                                            AddOrUpdate   = 1
                                            idForUpdate   = ArrPDFCAtegory[index].Id
                                            TFNewCat.text = ArrPDFCAtegory[index].Name
                                            LaWrite.text  = "Edit Category Name"
                                            BtnAddOrUpdate.setTitle("Update", for: .normal)
                                            ViewAddCat.isHidden = false
                                            
                                        })
        let DeleteAction = UIAlertAction(title: "Delete Pdf", style: .default, handler:
                                            { [self]
                                                (alert: UIAlertAction!) -> Void in
                                                
                                                // action
                                                Upload_Pdf_with_Name(Type: .delete, Id: ArrPDFCAtegory[index].Id , Name: "" )
                                                
                                            })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
                                            {
                                                (alert: UIAlertAction!) -> Void in
                                                // action
                                                print("cancel")
                                                
                                            })
        optionMenu.addAction(EditAction)
        optionMenu.addAction(DeleteAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrPDFCAtegory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PDFCategoryCell") as! PDFCategoryCell
        cell.delegate = self
        cell.index = indexPath.row
        cell.indexPath = indexPath
        cell.LaCategoryName.text = ArrPDFCAtegory[indexPath.row].Name
        
        if Helper.getRoleName() == "Student" {
            cell.BuMore.isHidden = true
        } else {
            cell.BuMore.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SubCategoryPdfVC") as! SubCategoryPdfVC
        vc.modalPresentationStyle = .fullScreen
        vc.ArrPDFCAtegory = ArrPDFCAtegory[indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }
    
    func PDFCategory(pagenum: Int){
        
        if Reachable.isConnectedToNetwork(){
            HUD.show(.progress)
            API.GetAllPDfs(pagenum: pagenum, completion: {(error : Error?, pdfmodel : [CategoryModel]?, message : String?) -> Void in
                if error == nil && message == "Success"{
                    if error != nil {
                        HUD.flash(.label("No Content To Show"), delay: 2.0)
                    }else{
                        for data in pdfmodel! {
                            if self.TVCategory.isHidden == true{
                                self.TVCategory.isHidden = false
                            }
                            self.ArrPDFCAtegory.append(data)
                        }
                        self.TVCategory.reloadData()
                        HUD.hide(animated: true, completion: nil)
                        
                    }
                } else  if  error == nil && message != "Success"{
                    HUD.flash(.label(message), delay: 2.0)
                }else {
                    HUD.flash(.label("Server Error"), delay: 2.0)
                }
            }
            
            )} else {
                showAlert(message: "No internet connection", title: "Alert")
            }
    }
    
}
