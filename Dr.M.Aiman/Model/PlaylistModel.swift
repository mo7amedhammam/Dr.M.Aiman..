//
//  PlaylistModel.swift
//  Dr.M.Aiman
//
//  Created by Muhamed Hammam on 24/06/2021.
//

import Foundation
class PlaylistModel : NSObject {
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

class VideosModel : NSObject {
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

class AllVideoUrlModel : NSObject {
    var EncryptedURLVlaue = ""
    var EncryptedURLKey   = ""
    init (EncryptedURLVlaue : String , EncryptedURLKey : String) {
        self.EncryptedURLVlaue  = EncryptedURLVlaue
        self.EncryptedURLKey    = EncryptedURLKey
    }
}
