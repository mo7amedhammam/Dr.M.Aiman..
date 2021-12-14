//
//  LiveModel.swift
//  Dr.M.Aiman
//
//  Created by Muhamed Hammam on 31/05/2021.
//

import Foundation
import UIKit


class LiveModel: NSObject {
         
    var Id = 0
    var Title = ""   //
    var Detailes = ""  // 
    var CreationDate = ""    // 
    var UserId = ""
    var FirstName = ""
    var ReactType = 0
    var ReactCount = 0
    var UserImage = ""
    var liveComments = [LiveCommentsModel]()

     init(
        Id : Int ,
        Title : String ,
        Detailes : String ,
        CreationDate : String,
        UserId : String,
        FirstName : String,
        ReactType: Int,
        ReactCount: Int,
        UserImage : String,
        liveComments : [LiveCommentsModel]

     ) {
        self.Id = Id
        self.Title = Title
        self.Detailes = Detailes
        self.CreationDate = CreationDate
        self.UserId = UserId
        self.FirstName = FirstName
        self.ReactType = ReactType
        self.ReactCount = ReactCount
        self.UserImage = UserImage
        self.liveComments = liveComments
    }
    
}

class LiveCommentsModel : NSObject {
  
    var CreationTime = ""
    var text = ""
    var Id = 0
    var Image = ""
    var UserId = ""
    var FirstName = ""
    
    init(
        CreationTime : String ,
        text : String ,
        Id : Int ,
        Image : String ,
        UserId : String,
        FirstName : String
    ){
        self.CreationTime = CreationTime
        self.text = text
        self.Id = Id
        self.Image = Image
        self.UserId = UserId
        self.FirstName = FirstName
        
    }
    
    
    
}


