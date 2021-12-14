//
//  PDFModel.swift
//  Dr.M.Aiman
//
//  Created by mac on 01/07/2021.
//

import UIKit

class CategoryModel : NSObject {
    
    var Id = 0
    var Name = ""
    var PDFs = [PDFModel]()

     init(
        Id : Int ,
        Name : String,
        PDFModel : [PDFModel]

     ) {
        self.Id = Id
        self.Name = Name
        self.PDFs = PDFModel
    }
    
}

class PDFModel : NSObject {
  
    var CreationTime = ""
    var Title = ""
    var Id = 0
    var Url = ""
    var UserImage = ""
    var UserId = ""
    var FirstName = ""
    
    init(
        CreationTime : String ,
        Title : String ,
        Id : Int ,
        Url : String ,
        UserImage : String ,
        UserId : String,
        FirstName : String
    ){
        self.CreationTime = CreationTime
        self.Title = Title
        self.Id = Id
        self.Url = Url
        self.UserImage = UserImage
        self.UserId = UserId
        self.FirstName = FirstName
        
    }
    
    
    
}
