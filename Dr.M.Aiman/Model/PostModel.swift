//
//  PostModel.swift
//  Dr.M.Aiman
//
//  Created by Muhamed Hammam on 02/06/2021.
//

import Foundation

class PostModel :NSObject {
    
   
    var Title = ""   //
    var Detailes = ""  //
    var CreationDate = ""    // 
    var CreationTime    = ""
    var Id               = 0       //
    var text             = ""
    var Image            = ""
    var UserId           = ""
    var UserImage        = ""
    var IsPinPost        = false     //
    var FirstName        = ""
    var ReactType        = 0
    var IsFavoritePost   = false       //
    var ReactCount       = 0           //
    var PinTime          = ""
    var Comments         = [CommentsModel]()
    
    init(
        
        Title             : String ,
        Detailes          : String ,
        CreationDate      : String ,
        CreationTime      : String ,
        Id                : Int,
        text              : String ,
        Image             : String ,
        UserId            : String ,
        UserImage         : String ,
        IsPinPost         : Bool ,
        FirstName         : String ,
        IsFavoritePost    : Bool ,
        ReactType         : Int ,
        ReactCount        : Int,          //
        PinTime           : String ,
        Comments          : [CommentsModel]
    ) {
        
        self.Title            = Title
        self.Detailes         = Detailes
        self.CreationDate     = CreationDate
        self.CreationTime     = CreationTime
        self.Id                = Id
        self.text              = text
        self.Image             =  Image
        self.UserId            =  UserId
        self.UserImage         = UserImage
        self.IsPinPost         = IsPinPost
        self.IsFavoritePost    = IsFavoritePost
        self.FirstName         =  FirstName
        self.ReactType         =  ReactType
        self.ReactCount        =  ReactCount
        self.PinTime           = PinTime
        self.Comments          = Comments
    }
    
}



class CommentsModel : NSObject {
        var CreationTime = ""
        var text = ""
        var Id = 0
        var Image = ""
        var UserId = ""
        var UserImage  = ""
        var FirstName = ""
        
        init(
            CreationTime : String ,
            text : String ,
            Id : Int ,
            Image : String ,
            UserId : String,
            UserImage : String,
            FirstName : String
        ){
            self.CreationTime = CreationTime
            self.text = text
            self.Id = Id
            self.Image = Image
            self.UserId = UserId
            self.UserImage = UserImage
            self.FirstName = FirstName
            
        }
}
