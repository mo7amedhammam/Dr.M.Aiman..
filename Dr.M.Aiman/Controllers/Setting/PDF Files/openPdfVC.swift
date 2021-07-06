//
//  openPdfVC.swift
//  Dr.M.Aiman
//
//  Created by mac on 04/07/2021.
//
import UIKit
import PKHUD
import PDFKit

class openPdfVC: UIViewController, UIDocumentInteractionControllerDelegate {
    
    
    @IBOutlet weak var ViewPdfOpen: UIView!
    @IBOutlet weak var LaTitle: UILabel!
    
    var pdfView   = PDFView()
    var stringUrl : String!
    var Title     = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        LaTitle.text = Title
        openPDFView()
    }
    func openPDFView(){
                let pdfview = PDFView(frame : self.view.frame)
                let url = URL(string: stringUrl)!
                if let pdf = PDFDocument(url: url){
                    pdfview.displayMode = .singlePageContinuous
                    pdfview.autoScales = true
                    pdfview.displayDirection = .vertical
                    pdfview.document = pdf
                    HUD.hide()
                }
        self.ViewPdfOpen.addSubview(pdfview)
    }
    
    
    
    @IBAction func DismissBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
    }
    

    
}
