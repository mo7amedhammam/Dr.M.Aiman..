//
//  HomeModel.swift
//  Mideo
//
//  Created by Mohamed Salman on 3/29/20.
//  Copyright © 2020 IT PLUS. All rights reserved.
//

import UIKit
import SwiftyJSON

class FeaturedModel : NSObject {
    
    var Id                 = ""
    var Image              = ""
    var Description        = ""
    var CreationDate       = ""
    var Quizzes            = ""
    var UserPlaylistVideos = ""
    var PlayListId         = 0
    var VideoUrl           = ""
    var Extention          = ""
    var Views              = ""
    var IsChatAvailable    = false
    var PlayList           = ""
    var IsFeatured         = false
    var IsPaid             = false
    var Order              = 0
    var Title              = ""
    var IsAvailable        = false
    var WatchLater         = ""
    var IsFree             = false
    
    
    init(Id : String , Image : String , Description : String , CreationDate : String , Quizzes : String , UserPlaylistVideos : String , PlayListId : Int , VideoUrl : String , Extention : String , Views : String , IsChatAvailable : Bool , PlayList : String , IsFeatured : Bool , IsPaid : Bool , Order : Int , Title : String , IsAvailable : Bool , WatchLater : String , IsFree : Bool ) {
        
        self.Id                   = Id
        self.Image                = Image
        self.Description          = Description
        self.CreationDate         = CreationDate
        self.Quizzes              = Quizzes
        self.UserPlaylistVideos   = UserPlaylistVideos
        self.PlayListId           = PlayListId
        self.VideoUrl             = VideoUrl
        self.Extention            = Extention
        self.Views                = Views
        self.IsChatAvailable      = IsChatAvailable
        self.PlayList             = PlayList
        self.IsFeatured           = IsFeatured
        self.IsPaid               = IsPaid
        self.Order                = Order
        self.Title                = Title
        self.IsAvailable          = IsAvailable
        self.WatchLater           = WatchLater
        self.IsFree               = IsFree
        
    }
    
    
}

class AllUniversityModel : NSObject {
    var Id             = 0
    var Title          = ""
    var Image          = ""
    init(Id : Int , Title : String , Image : String) {
        self.Id             = Id
        self.Title          = Title
        self.Image          = Image.filter { $0 != " " }
    }
}


class AllCoursesModel : NSObject {
    var Id             = 0
    var Title          = ""
    var Image          = ""
    var Created        = ""
    var Price          = 0.0
    var TotalPlayLists = 0
    
    init(Id : Int , Title : String , Image : String , Created : String , Price : Double , TotalPlayLists : Int) {
        
        self.Id             = Id
        self.Title          = Title
        self.Image          = Image
        self.Created        = Created
        self.Price          = Price
        self.TotalPlayLists = TotalPlayLists
    }
    
    
    
}

class oldPlaylistModel : NSObject {
    var Id             = 0
    var Title          = ""
    var Image          = ""
    var Description    = ""
    var IsAvailable    = false
    var CreationDate   = ""
    var Price          = 0.0
    var TotalVideos    = 0
    var CourseId       = 0
    var CourseName     = ""
    var Reference = [String]()
    init(Id : Int , Title : String , Image : String , Description : String , IsAvailable : Bool ,CreationDate : String , Price : Double , TotalVideos : Int , CourseId : Int , CourseName : String , Reference : [String]) {
        
        self.Id             = Id
        self.Title          = Title
        self.Image          = Image
        self.Description    = Description
        self.IsAvailable    = IsAvailable
        self.CreationDate   = CreationDate
        self.Price          = Price
        self.TotalVideos    = TotalVideos
        self.CourseId       = CourseId
        self.CourseName     = CourseName
        self.Reference      = Reference
    }
    
    
    
}

class oldVideosModel : NSObject {
    var Id           = 0
    var Title        = ""
    var Image        = ""
    var Description  = ""
    var IsAvailable  = false
    var CreationDate = ""
    var IsFree       = false
    var IsPaid       = false
    var IsFeatured   = false
    var VideoUrl     = ""
    var Extention    = ""
    var Order        = 0
    var PlayListId   = 0
    var Messages     = ""
    var Views        = ""
    var IsYoutube    = false

    init(Id : Int , Title : String , Image : String , Description : String , IsAvailable : Bool , CreationDate : String , IsFree : Bool , IsPaid : Bool , IsFeatured : Bool , VideoUrl : String , Extention : String , Order : Int , PlayListId : Int , Messages : String , Views : String , IsYoutube : Bool) {

        self.Id    = Id
        self.Title  = Title
        self.Image  = Image
        self.Description = Description
        self.IsAvailable = IsAvailable
        self.CreationDate = CreationDate
        self.IsFree       = IsFree
        self.IsPaid       = IsPaid
        self.IsFeatured   = IsFeatured
        self.VideoUrl     = VideoUrl
        self.Extention    = Extention
        self.Order        = Order
        self.PlayListId   = PlayListId
        self.Messages     = Messages
        self.Views        = Views
        self.IsYoutube    = IsYoutube
    }
    
}

class oldAllVideoUrlModel : NSObject {
    var EncryptedURLVlaue = ""
    var EncryptedURLKey   = ""
    init (EncryptedURLVlaue : String , EncryptedURLKey : String) {
        self.EncryptedURLVlaue  = EncryptedURLVlaue
        self.EncryptedURLKey    = EncryptedURLKey
    }
}
