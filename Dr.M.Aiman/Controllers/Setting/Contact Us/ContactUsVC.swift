//
//  ContactUsVC.swift
//  Dr.M.Aiman
//
//  Created by Muhamed Hammam on 03/06/2021.
//

import UIKit

class ContactUsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func BuFacebook(_ sender: Any) {
//        Helper.openFAcebook(FacebookID: "1420618394665689")
        Helper.openFaceBook(pageId: "1420618394665689", pageName: "MohamedAyman3333")
    }
    
    @IBAction func BuYoutube(_ sender: Any) {
        Helper.OpenYoutube(youtubeID: "UChF4j3TSfNn3fu_WfhUw6aw")
    }
    
    @IBAction func BuWhatsapp(_ sender: Any) {
        Helper.openWhatsapp(WhatsappNumber: "+201008987601")
    }
    
    @IBAction func BuTelegram(_ sender: Any) {
        Helper.openTelegram(telegramID: "NujqkN0suwE1MzU0")
    }
}
