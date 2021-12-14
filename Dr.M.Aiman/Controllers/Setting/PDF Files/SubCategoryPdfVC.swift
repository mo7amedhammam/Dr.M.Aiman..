//
//  SubCategoryPdfVC.swift
//  Dr.M.Aiman
//
//  Created by mac on 01/07/2021.
//

import UIKit
import PDFKit
import MobileCoreServices

class SubCategoryPdfVC: UIViewController {

    @IBOutlet weak var TVSub: UITableView!
    @IBOutlet weak var TitleBare: UILabel!
    @IBOutlet weak var BtnBack: UIButton!
    @IBOutlet weak var BUPlus: UIButton!
    
    //
    
    @IBOutlet weak var LaAddOrUpdate: UILabel!
    @IBOutlet weak var ViewAddPdf: UIView!
    @IBOutlet weak var TFPdfName: UITextField!
    
    @IBOutlet weak var BtnSelectPdf: UIButton!
    @IBOutlet weak var BtnAddOrUpdate: UIButton!
  
    var pdfView = PDFView()
    var PickedPDFData : Data?
    var pdfUrl : URL?
    
    var ArrPDFCAtegory : CategoryModel!
    var ArrSub         = [PDFModel]()
    
    
    var AddOrUpdate     = 0
    var idForUpdate     = 0
    
    var indicator:ProgressIndicator?

    override func viewDidLoad() {
        super.viewDidLoad()

        // indicator hud ----------------//
        indicator = ProgressIndicator(inview:self.view,loadingViewColor: UIColor.lightGray, indicatorColor: #colorLiteral(red: 0.07058823529, green: 0.3568627451, blue: 0.6352941176, alpha: 1) , msg:  SalmanLocalize.textLocalize(key: "LPleaseWait") )
        indicator?.center = self.view.center
        self.view.addSubview(indicator!)
        //  end indicator hud ----------------//
        
        ViewAddPdf.isHidden = true
        TVSub.dataSource = self
        TVSub.delegate   = self
        TitleBare.text = ArrPDFCAtegory.Name
        getdata()
        
//        if Helper.getRoleName() == "Student" {
//            self.BtnSelectPdf.isHidden = true
//        } else {
//            self.BtnSelectPdf.isHidden = false
//        }
        
        LaAddOrUpdate.text = "Add Pdf Description"
        BtnSelectPdf.isHidden = false
        BtnAddOrUpdate.setTitle("Add", for: .normal)
        
        if Helper.getRoleName() == "Student"{
            BUPlus.isHidden = true
        } else{
            BUPlus.isHidden = false
        }
        
    }
    
    func getdata(){
        for data in ArrPDFCAtegory.PDFs {
            ArrSub.append(data)
        }
        TVSub.reloadData()
    }
    
    @IBAction func BUBack(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        ViewAddPdf.isHidden = true
    }
 
    func upload_PDF (pdf: Data? )  {
        if Reachable.isConnectedToNetwork(){
            self.indicator?.start()
            API.uploadFileMultiPart(pdfDocument: pdf! as Data) { [self] (error : Error?, status  : Int?, message : String?,pdfUrl : String?) in
            if error == nil && status == 0 {
                self.pdfUrl = URL(string: pdfUrl!)
                self.Upload_Pdf_with_Name(Type: .add , PDFCategoryId:  ArrPDFCAtegory.Id  , Title: TFPdfName.text! , Url: pdfUrl! )
            } else {
                self.indicator?.stop()
                self.showAlert(message: "Error uploading file please try again")
            }
        }

        } else {
            self.AlertInternet(controller: self)
            self.indicator?.stop()
        }
    }
    
    
    func Upload_Pdf_with_Name ( Type : API.PdfEnum , PDFCategoryId : Int , Title : String , Url : String  ){
        
        self.indicator?.start()
        if Reachable.isConnectedToNetwork() {
            API.UploadPDF(type: Type , PDFCategoryId: PDFCategoryId, Title: Title, Url: Url) { [self] (error : Error?, status : Int, message : String?) in
                if error == nil && status == 0  {
                    self.indicator?.stop()
                    TFPdfName.text = ""
                    ViewAddPdf.isHidden = true
                    PDFCategoryReload(pagenum: 0)
                } else if error == nil && status == -1 {
                    self.indicator?.stop()
                    self.AlertShowMessage(controller: self, text: message!, status: 1)
                } else {
                    self.indicator?.stop()
                    self.AlertServerError(controller: self)
                }
            }
            
        } else {
            self.AlertInternet(controller: self)
            self.indicator?.stop()
        }
    }
    
    @IBAction func BUPlus(_ sender: Any) {
        AddOrUpdate = 0
        ViewAddPdf.isHidden = false
    }
    
    
    @IBAction func BUSelectPdf(_ sender: Any) {
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .automatic
        self.present(importMenu, animated: true, completion: nil)
    }
 
    @IBAction func BUAddPdf(_ sender: Any) {
        if AddOrUpdate == 0 {
            if PickedPDFData == nil {
                self.showAlert(message: "Please Select Pdf File")
            } else {
                upload_PDF (pdf: PickedPDFData )
            }
        } else {
            self.Upload_Pdf_with_Name(Type: .edit , PDFCategoryId: idForUpdate , Title: TFPdfName.text! , Url: "" )
        }
    }
    
    @IBAction func BUCancelPdf(_ sender: Any) {
        ViewAddPdf.isHidden = true
        TFPdfName.text = ""
        PickedPDFData = nil
    }
        
    func PDFCategoryReload(pagenum: Int){
        self.indicator?.start()
        if Reachable.isConnectedToNetwork(){
            API.GetAllPDfs(pagenum: pagenum, completion: { [self](error : Error?, pdfmodel : [CategoryModel]?, message : String?) -> Void in
                if error == nil && message == "Success"{
                    if error != nil {
                        self.AlertShowMessage(controller: self, text: "No Content To Show", status: 1)
                        self.indicator?.stop()
                    } else {
                        for data in pdfmodel! {
                            if data.Id ==  ArrPDFCAtegory.Id {
                                self.ArrPDFCAtegory = data
                            }
                        }
                        ArrSub.removeAll()
                        getdata()
                        self.indicator?.stop()
                    }
                    
                } else  if  error == nil && message != "Success"{
                    self.AlertShowMessage(controller: self, text: message!, status: 1)
                    self.indicator?.stop()
                }else {
                    self.AlertServerError(controller: self)
                    self.indicator?.stop()
                }
            }
            )} else {
                self.AlertInternet(controller: self)
                self.indicator?.stop()
        }
    }
}


extension SubCategoryPdfVC : UITableViewDataSource , UITableViewDelegate , MoreActionSubCategory {
    
    func More(index: Int) {
                
        let optionMenu = UIAlertController(title: nil, message: nil , preferredStyle: .actionSheet)
        let UpdateAction = UIAlertAction(title: "Update", style: .default, handler:
                                            { [self]
                                            (alert: UIAlertAction!) -> Void in
                                            
                                            // action
                                                AddOrUpdate = 1
                                                idForUpdate = ArrSub[index].Id
                                                TFPdfName.text = ArrSub[index].Title
                                                LaAddOrUpdate.text = "Update Pdf"
                                                BtnSelectPdf.isHidden = true
                                                BtnAddOrUpdate.setTitle("Update", for: .normal)
                                                ViewAddPdf.isHidden = false
                                        })
        let DeleteAction = UIAlertAction(title: "Delete", style: .default, handler:
                                            { [self]
                                                (alert: UIAlertAction!) -> Void in

                                                // action
                                                Upload_Pdf_with_Name(Type: .delete, PDFCategoryId: ArrSub[index].Id, Title: "", Url: "")

                                            })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
                                            {
                                                (alert: UIAlertAction!) -> Void in
                                                // action
                                            })
        optionMenu.addAction(UpdateAction)
        optionMenu.addAction(DeleteAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
        

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrSub.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryPdfTVCell", for: indexPath) as! SubCategoryPdfTVCell
        cell.index    = indexPath.row
        cell.delegate = self
        cell.LaName.text = ArrSub[indexPath.row].Title
        
        if Helper.getRoleName() == "Student" {
            cell.BtnMore.isHidden = true
        } else {
            cell.BtnMore.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "openPdfVC") as! openPdfVC
        vc.Title     = ArrSub[indexPath.row].Title
        vc.stringUrl =  URLs.ImageBaseURL + ArrSub[indexPath.row].Url
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}



extension SubCategoryPdfVC : UIDocumentPickerDelegate{

    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result url : \(myURL)")
        
        let data = NSData(contentsOf: myURL)
        
        do{
            self.PickedPDFData = data! as Data
//            TFPdfName.text =
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
        
    }

}
